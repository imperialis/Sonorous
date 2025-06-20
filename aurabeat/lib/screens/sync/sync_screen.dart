// lib/screens/sync/sync_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/sync_provider.dart';
import '../../providers/track_provider.dart';
import '../../models/sync_model.dart';
import '../../models/track_model.dart';
import '../../widgets/audio_player_widget.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({Key? key}) : super(key: key);

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  Timer? _syncTimer;
  bool _isHosting = false;
  String? _sessionCode;
  final TextEditingController _sessionController = TextEditingController();
  final TextEditingController _hostCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _sessionController.dispose();
    _hostCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final syncProvider = context.read<SyncProvider>();
    final trackProvider = context.read<TrackProvider>();
    
    await Future.wait([
      syncProvider.loadPlaybackState(),
      trackProvider.loadTracks(),
    ]);
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        context.read<SyncProvider>().loadPlaybackState();
      }
    });
  }

  void _stopSyncTimer() {
    _syncTimer?.cancel();
  }

  Future<void> _createSession() async {
    final code = _generateSessionCode();
    setState(() {
      _isHosting = true;
      _sessionCode = code;
    });
    
    _startSyncTimer();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session created! Code: $code'),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _joinSession() async {
    final code = _sessionController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a session code'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    try {
      setState(() {
        _sessionCode = code;
        _isHosting = false;
      });
      
      _startSyncTimer();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Joined session: $code'),
          backgroundColor: AppColors.primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join session: $e'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  Future<void> _leaveSession() async {
    setState(() {
      _sessionCode = null;
      _isHosting = false;
    });
    
    _stopSyncTimer();
    _sessionController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Left sync session'),
        backgroundColor: AppColors.textSecondary,
      ),
    );
  }

  String _generateSessionCode() {
    final chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(6, (index) => chars[random % chars.length]).join();
  }

  Future<void> _updatePlaybackState(int trackId, double position, bool isPlaying) async {
    final provider = context.read<SyncProvider>();
    // await provider.updatePlaybackState(trackId, position, isPlaying);
    await provider.updatePlaybackState(
     trackId: trackId,
     position: position,
     isPlaying: isPlaying,
   );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: Text(
          'Sync Playback',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          if (_sessionCode != null)
            IconButton(
              onPressed: _leaveSession,
              icon: Icon(Icons.exit_to_app, color: AppColors.errorColor),
              tooltip: 'Leave Session',
            ),
        ],
      ),
      body: Consumer2<SyncProvider, TrackProvider>(
        builder: (context, syncProvider, trackProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Session Status Card
                _buildSessionStatusCard(),
                
                const SizedBox(height: 20),
                
                // Session Controls
                if (_sessionCode == null) ...[
                  _buildSessionControls(),
                ] else ...[
                  _buildActiveSessionControls(syncProvider),
                ],
                
                const SizedBox(height: 20),
                
                // Current Playback State
                if (_sessionCode != null) ...[
                  _buildCurrentPlaybackCard(syncProvider, trackProvider),
                  const SizedBox(height: 20),
                ],
                
                // Track Selection for Host
                if (_isHosting && _sessionCode != null) ...[
                  _buildTrackSelectionCard(trackProvider, syncProvider),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _sessionCode != null 
              ? AppColors.primaryColor.withOpacity(0.3)
              : AppColors.textSecondary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (_sessionCode != null ? AppColors.primaryColor : AppColors.textSecondary)
                  .withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              _sessionCode != null ? Icons.sync : Icons.sync_disabled,
              color: _sessionCode != null ? AppColors.primaryColor : AppColors.textSecondary,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _sessionCode != null ? 'Session Active' : 'No Active Session',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          if (_sessionCode != null) ...[
            Text(
              'Session Code: $_sessionCode',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 24,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isHosting ? 'You are hosting' : 'You are a participant',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ] else ...[
            Text(
              'Create or join a session to sync playback with others',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Controls',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        
        // Create Session
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.add_circle, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Host a Session',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Create a new sync session and control playback for all participants',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Create Session',
                onPressed: _createSession,
                icon: Icons.add,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Join Session
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.login, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Join a Session',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Enter a session code to join an existing sync session',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sessionController,
                decoration: InputDecoration(
                  hintText: 'Enter session code',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Join Session',
                onPressed: _joinSession,
                icon: Icons.login,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSessionControls(SyncProvider syncProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.sync, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Sync Controls',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Sync Now',
                  onPressed: () => syncProvider.loadPlaybackState(),
                  icon: Icons.refresh,
                  //isOutlined: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Leave Session',
                  onPressed: _leaveSession,
                  icon: Icons.exit_to_app,
                  backgroundColor: AppColors.errorColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlaybackCard(SyncProvider syncProvider, TrackProvider trackProvider) {
  //   final state = syncProvider.currentState;
  //   final track = state?.trackId != null 
  //       ? trackProvider.tracks.firstWhere(
  //           (t) => t.id == state!.trackId,
  //           orElse: () => Track(
  //   id: state.trackId!,
  //   filename: 'unknown.mp3',
  //   title: 'Unknown Track',
  //   artist: 'Unknown Artist',
  //   album: null,
  //   duration: 0.0,
  //   userId: null,
  //   filepath: '',
  //   createdAt: DateTime.now(),
  //   updatedAt: DateTime.now(),
  // ),
  //         )
  //       : null;
  final state = syncProvider.currentState;

Track? track;
if (state != null && state.trackId != null) {
  track = trackProvider.tracks.firstWhere(
    (t) => t.id == state.trackId,
    orElse: () => Track(
      id: state.trackId!, // Safe here because of the null check above
      filename: 'unknown.mp3',
      title: 'Unknown Track',
      artist: 'Unknown Artist',
      album: null,
      duration: 0.0,
      userId: null,
      filepath: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
} else {
  track = null;
}


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.music_note, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Current Playback',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (state?.isPlaying == true ? Colors.green : Colors.orange)
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state?.isPlaying == true ? 'Playing' : 'Paused',
                  style: TextStyle(
                    color: state?.isPlaying == true ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (track != null) ...[
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title!,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        track.artist!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
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
            
            // Progress bar
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (track.duration != null && track.duration! > 0)
                    ? (state?.position ?? 0) / track.duration! 
                    : 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(state?.position ?? 0),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  //_formatDuration(track.duration.toDouble()),
                  _formatDuration(track.duration ?? 0.0),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ] else ...[
            Center(
              child: Text(
                'No track selected',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackSelectionCard(TrackProvider trackProvider, SyncProvider syncProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.queue_music, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Select Track to Play',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (trackProvider.tracks.isNotEmpty) ...[
            ...trackProvider.tracks.take(5).map((track) => 
              _buildTrackListItem(track, syncProvider)
            ),
            if (trackProvider.tracks.length > 5) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'And ${trackProvider.tracks.length - 5} more tracks...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ] else ...[
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.music_off,
                    color: AppColors.textSecondary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No tracks available',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackListItem(Track track, SyncProvider syncProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.music_note,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title!,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  track.artist!,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _updatePlaybackState(track.id, 0, true),
            icon: Icon(
              Icons.play_arrow,
              color: AppColors.primaryColor,
            ),
            tooltip: 'Play for all participants',
          ),
        ],
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.round());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$secs';
  }
}