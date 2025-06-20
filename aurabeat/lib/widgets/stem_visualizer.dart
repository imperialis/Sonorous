// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import '../models/stem_model.dart';
// import '../core/constants/app_colors.dart';

// class StemVisualizerWidget extends StatefulWidget {
//   final List<Stem> stems;
//   final Function(Stem, bool)? onStemToggled;
//   final Function(Stem, double)? onVolumeChanged;
//   final bool isPlaying;
//   final Duration currentPosition;

//   const StemVisualizerWidget({
//     Key? key,
//     required this.stems,
//     this.onStemToggled,
//     this.onVolumeChanged,
//     this.isPlaying = false,
//     this.currentPosition = Duration.zero,
//   }) : super(key: key);

//   @override
//   State<StemVisualizerWidget> createState() => _StemVisualizerWidgetState();
// }

// class _StemVisualizerWidgetState extends State<StemVisualizerWidget>
//     with TickerProviderStateMixin {
//   late AnimationController _waveController;
//   late List<AnimationController> _stemControllers;
//   Map<String, bool> _stemStates = {};
//   Map<String, double> _stemVolumes = {};

//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     _initializeStemStates();
//   }

//   void _initializeControllers() {
//     _waveController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _stemControllers = widget.stems.map((stem) => AnimationController(
//       duration: const Duration(milliseconds: 300),

//*******version 2 *//
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/stem_model.dart';
import '../core/constants/app_colors.dart';

class StemVisualizerWidget extends StatefulWidget {
  final List<Stem> stems;
  final Function(Stem, bool)? onStemToggled;
  final Function(Stem, double)? onVolumeChanged;
  final bool isPlaying;
  final Duration currentPosition;

  const StemVisualizerWidget({
    Key? key,
    required this.stems,
    this.onStemToggled,
    this.onVolumeChanged,
    this.isPlaying = false,
    this.currentPosition = Duration.zero,
  }) : super(key: key);

  @override
  State<StemVisualizerWidget> createState() => _StemVisualizerWidgetState();
}

class _StemVisualizerWidgetState extends State<StemVisualizerWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late List<AnimationController> _stemControllers;
  Map<int, bool> _stemStates = {};
  Map<int, double> _stemVolumes = {};
  //Map<String, bool> _stemStates = {};
  //Map<String, double> _stemVolumes = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeStemStates();
  }

  void _initializeControllers() {
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _stemControllers = widget.stems.map((stem) => AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )).toList();

    if (widget.isPlaying) {
      _waveController.repeat();
    }
  }

  void _initializeStemStates() {
    for (var stem in widget.stems) {
      _stemStates[stem.id] = true; // All stems enabled by default
      _stemVolumes[stem.id] = 1.0; // Full volume by default
    }
  }

  @override
  void didUpdateWidget(StemVisualizerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _waveController.repeat();
      } else {
        _waveController.stop();
      }
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    for (var controller in _stemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Color _getStemColor(String stemType) {
    switch (stemType.toLowerCase()) {
      case 'vocals':
        return AppColors.vocals;
      case 'drums':
        return AppColors.drums;
      case 'bass':
        return AppColors.bass;
      case 'other':
        return AppColors.other;
      case 'piano':
        return AppColors.piano;
      case 'guitar':
        return AppColors.guitar;
      default:
        return AppColors.defaultStem;
    }
  }

  IconData _getStemIcon(String stemType) {
    switch (stemType.toLowerCase()) {
      case 'vocals':
        return Icons.mic;
      case 'drums':
        return Icons.album;
      case 'bass':
        return Icons.music_note;
      case 'piano':
        return Icons.piano;
      case 'guitar':
        return Icons.music_note_sharp;
      case 'other':
        return Icons.equalizer;
      default:
        return Icons.audiotrack;
    }
  }

  void _toggleStem(Stem stem) {
    setState(() {
      _stemStates[stem.id] = !(_stemStates[stem.id] ?? true);
    });
    
    if (widget.onStemToggled != null) {
      widget.onStemToggled!(stem, _stemStates[stem.id] ?? true);
    }

    // Animate the stem controller
    int index = widget.stems.indexOf(stem);
    if (index >= 0 && index < _stemControllers.length) {
      if (_stemStates[stem.id] == true) {
        _stemControllers[index].forward();
      } else {
        _stemControllers[index].reverse();
      }
    }
  }

  void _onVolumeChanged(Stem stem, double volume) {
    setState(() {
      _stemVolumes[stem.id] = volume;
    });
    
    if (widget.onVolumeChanged != null) {
      widget.onVolumeChanged!(stem, volume);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.backgroundGradientStart,
            AppColors.backgroundGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildWaveformVisualization(),
          const SizedBox(height: 24),
          _buildStemControls(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.equalizer,
          color: AppColors.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Stem Visualizer',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isPlaying ? AppColors.success : AppColors.inactive,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isPlaying ? Icons.play_arrow : Icons.pause,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                widget.isPlaying ? 'Playing' : 'Paused',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaveformVisualization() {
    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              animationValue: _waveController.value,
              stems: widget.stems,
              stemStates: _stemStates.map((key, value) => MapEntry(key.toString(), value)),
              //stemStates: _stemStates,
              getStemColor: _getStemColor,
              isPlaying: widget.isPlaying,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  Widget _buildStemControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stem Controls',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...widget.stems.asMap().entries.map((entry) {
          int index = entry.key;
          Stem stem = entry.value;
          return _buildStemControlItem(stem, index);
        }).toList(),
      ],
    );
  }

  Widget _buildStemControlItem(Stem stem, int index) {
    bool isEnabled = _stemStates[stem.id] ?? true;
    double volume = _stemVolumes[stem.id] ?? 1.0;
    Color stemColor = _getStemColor(stem.stemType);

    return AnimatedBuilder(
      animation: index < _stemControllers.length ? _stemControllers[index] : _waveController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isEnabled 
                ? stemColor.withOpacity(0.1) 
                : AppColors.cardBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEnabled ? stemColor : AppColors.border,
              width: isEnabled ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Stem icon and toggle
                  GestureDetector(
                    onTap: () => _toggleStem(stem),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isEnabled ? stemColor : AppColors.inactive,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getStemIcon(stem.stemType),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Stem info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stem.stemType.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isEnabled ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          stem.filepath ?? 'Unknown file',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Volume indicator
                  Text(
                    '${(volume * 100).round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isEnabled ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Volume slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: stemColor,
                  inactiveTrackColor: stemColor.withOpacity(0.3),
                  thumbColor: stemColor,
                  overlayColor: stemColor.withOpacity(0.2),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                ),
                child: Slider(
                  value: volume,
                  onChanged: isEnabled ? (value) => _onVolumeChanged(stem, value) : null,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double animationValue;
  final List<Stem> stems;
  final Map<String, bool> stemStates;
  final Color Function(String) getStemColor;
  final bool isPlaying;

  WaveformPainter({
    required this.animationValue,
    required this.stems,
    required this.stemStates,
    required this.getStemColor,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (stems.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final width = size.width;
    final barWidth = width / 100; // 100 bars across the width
    
    for (int i = 0; i < 100; i++) {
      final x = i * barWidth + barWidth / 2;
      
      // Create waveform for each enabled stem
      double totalAmplitude = 0;
      int enabledStems = 0;
      
      for (var stem in stems) {
        if (stemStates[stem.id] == true) {
          enabledStems++;
          // Generate pseudo-random waveform based on stem type and animation
          final stemHash = stem.stemType.hashCode;
          final phase = (animationValue * 2 * math.pi) + (i * 0.1) + (stemHash * 0.01);
          final amplitude = math.sin(phase) * 
                           math.sin(phase * 0.7) * 
                           (0.3 + 0.7 * math.sin(animationValue * math.pi + stemHash));
          totalAmplitude += amplitude;
        }
      }
      
      if (enabledStems > 0) {
        totalAmplitude /= enabledStems;
        
        // Add some base movement even when not playing
        if (!isPlaying) {
          totalAmplitude *= 0.3;
        }
        
        final barHeight = (totalAmplitude.abs() * size.height * 0.4).clamp(2.0, size.height * 0.4);
        
        // Create gradient effect
        final gradient = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            getStemColor(stems.first.stemType).withOpacity(0.8),
            getStemColor(stems.first.stemType).withOpacity(0.3),
          ],
        );
        
        paint.shader = gradient.createShader(
          Rect.fromLTWH(x - barWidth/2, centerY - barHeight, barWidth, barHeight * 2),
        );
        
        // Draw the waveform bar
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              x - barWidth/2, 
              centerY - barHeight, 
              barWidth - 1, 
              barHeight * 2
            ),
            const Radius.circular(1),
          ),
          paint,
        );
      }
    }
    
    // Draw center line
    paint.shader = null;
    paint.color = Colors.white.withOpacity(0.1);
    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(0, centerY),
      Offset(width, centerY),
      paint,
    );
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
           isPlaying != oldDelegate.isPlaying ||
           stems != oldDelegate.stems ||
           stemStates != oldDelegate.stemStates;
  }
}