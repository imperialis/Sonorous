import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track_model.dart';
import '../core/constants/app_colors.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Track? currentTrack;
  final Function(Track)? onTrackChanged;
  final List<Track>? playlist;
  final bool showFullControls;

  const AudioPlayerWidget({
    Key? key,
    this.currentTrack,
    this.onTrackChanged,
    this.playlist,
    this.showFullControls = true,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  bool _isInitialized = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    _player = AudioPlayer();
    
    _player.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      }
    });

    _player.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _player.playingStream.listen((playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });

    _player.processingStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isLoading = state == ProcessingState.loading;
        });
      }
    });

    _isInitialized = true;
  }

  @override
  void didUpdateWidget(AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTrack != oldWidget.currentTrack && widget.currentTrack != null) {
      _loadTrack(widget.currentTrack!);
    }
  }

  Future<void> _loadTrack(Track track) async {
    if (!_isInitialized) return;
    
    try {
      setState(() => _isLoading = true);
      await _player.setUrl(track.filepath);
    } catch (e) {
      print('Error loading track: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> _skipNext() async {
    if (widget.playlist != null && widget.playlist!.isNotEmpty && widget.currentTrack != null) {
      final currentIndex = widget.playlist!.indexOf(widget.currentTrack!);
      if (currentIndex < widget.playlist!.length - 1) {
        widget.onTrackChanged?.call(widget.playlist![currentIndex + 1]);
      }
    }
  }

  Future<void> _skipPrevious() async {
    if (widget.playlist != null && widget.playlist!.isNotEmpty && widget.currentTrack != null) {
      final currentIndex = widget.playlist!.indexOf(widget.currentTrack!);
      if (currentIndex > 0) {
        widget.onTrackChanged?.call(widget.playlist![currentIndex - 1]);
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentTrack == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Track Info
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.currentTrack!.title ?? 'Unknown Title',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.currentTrack!.artist ?? 'Unknown Artist',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Progress Bar
          Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.2),
                  trackHeight: 3,
                ),
                child: Slider(
                  value: _duration.inMilliseconds > 0 
                    ? _position.inMilliseconds / _duration.inMilliseconds 
                    : 0.0,
                  onChanged: (value) {
                    final position = Duration(
                      milliseconds: (value * _duration.inMilliseconds).round(),
                    );
                    _seek(position);
                  },
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.showFullControls && widget.playlist != null)
                IconButton(
                  onPressed: _skipPrevious,
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              
              // Play/Pause Button
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: IconButton(
                  onPressed: _isLoading ? null : _togglePlayPause,
                  icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                ),
              ),
              
              if (widget.showFullControls && widget.playlist != null)
                IconButton(
                  onPressed: _skipNext,
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
            ],
          ),
          
          if (widget.showFullControls) ...[
            const SizedBox(height: 16),
            
            // Additional Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // Shuffle functionality
                  },
                  icon: const Icon(
                    Icons.shuffle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Repeat functionality
                  },
                  icon: const Icon(
                    Icons.repeat,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Volume control
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Queue/playlist
                  },
                  icon: const Icon(
                    Icons.queue_music,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}