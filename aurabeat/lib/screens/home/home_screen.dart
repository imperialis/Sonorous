// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../providers/auth_provider.dart';
import '../../providers/track_provider.dart';
import '../../widgets/track_card.dart';
import '../../widgets/audio_player_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackProvider>().loadTracks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.music_note,
              color: AppColors.primaryColor,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'AuraGen Studio',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/analytics'),
            icon: Icon(
              Icons.analytics_outlined,
              color: AppColors.textSecondary,
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.textSecondary,
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                await context.read<AuthProvider>().logout();
                if (mounted) {
                  context.go('/login');
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryColor,
          tabs: const [
            Tab(text: 'My Tracks'),
            Tab(text: 'Recommendations'),
            Tab(text: 'Recent'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyTracksTab(),
          _buildRecommendationsTab(),
          _buildRecentTab(),
          _buildFavoritesTab(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'upload',
            onPressed: () => context.push('/upload'),
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.upload_file, color: Colors.white),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'generate',
            onPressed: () => context.push('/auragen'),
            backgroundColor: AppColors.accentColor,
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
        ],
      ),
      bottomSheet: const AudioPlayerWidget(),
    );
  }

  Widget _buildMyTracksTab() {
    return Consumer<TrackProvider>(
      builder: (context, trackProvider, child) {
        if (trackProvider.isLoading) {
          return const Center(child: LoadingWidget());
        }

        if (trackProvider.tracks.isEmpty) {
          return _buildEmptyState(
            icon: Icons.library_music_outlined,
            title: 'No tracks yet',
            subtitle: 'Upload your first track or generate one with AI',
            actionText: 'Get Started',
            onAction: () => context.push('/upload'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => trackProvider.loadTracks(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trackProvider.tracks.length,
            itemBuilder: (context, index) {
              final track = trackProvider.tracks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TrackCard(
                  track: track,
                  onTap: () => _playTrack(track),
                  onMoreTap: () => _showTrackOptions(track),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRecommendationsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.recommend_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Recommendations Coming Soon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re working on personalized recommendations for you',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTab() {
    return Consumer<TrackProvider>(
      builder: (context, trackProvider, child) {
        final recentTracks = trackProvider.tracks.take(5).toList();
        
        if (recentTracks.isEmpty) {
          return _buildEmptyState(
            icon: Icons.history,
            title: 'No recent activity',
            subtitle: 'Your recently played tracks will appear here',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recentTracks.length,
          itemBuilder: (context, index) {
            final track = recentTracks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TrackCard(
                track: track,
                onTap: () => _playTrack(track),
                onMoreTap: () => _showTrackOptions(track),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    return _buildEmptyState(
      icon: Icons.favorite_outline,
      title: 'No favorites yet',
      subtitle: 'Mark tracks as favorites to see them here',
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _playTrack(track) {
    // Implementation will be handled by AudioPlayerWidget
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing: ${track.title ?? 'Unknown Track'}'),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _showTrackOptions(track) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              track.title ?? 'Unknown Track',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              icon: Icons.lyrics,
              title: 'View Lyrics',
              onTap: () {
                Navigator.pop(context);
                //context.push('/lyrics/${track.id}');
                context.push('/lyrics?trackId=${track.id}');
              },
            ),
            _buildOptionTile(
              icon: Icons.tune,
              title: 'Create Remix',
              onTap: () {
                Navigator.pop(context);
                //context.push('/remix/${track.id}');
                context.push('/remix?trackId=${track.id}');
              },
            ),
            _buildOptionTile(
              icon: Icons.graphic_eq,
              title: 'Extract Stems',
              onTap: () {
                Navigator.pop(context);
                //context.push('/stems/${track.id}');
                context.push('/stem?trackId=${track.id}');
              },
            ),
            _buildOptionTile(
              icon: Icons.info_outline,
              title: 'Track Info',
              onTap: () {
                Navigator.pop(context);
                _showTrackInfo(track);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        title,
        style: TextStyle(color: AppColors.textPrimary),
      ),
      onTap: onTap,
    );
  }

  void _showTrackInfo(track) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
        title: Text(
          'Track Information',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Title', track.title ?? 'Unknown'),
            _buildInfoRow('Artist', track.artist ?? 'Unknown'),
            _buildInfoRow('Duration', '${track.duration ?? 0}s'),
            _buildInfoRow('Created', track.createdAt?.toString() ?? 'Unknown'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}