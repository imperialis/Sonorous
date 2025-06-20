// // lib/screens/lyrics/lyrics_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
// import '../../core/constants/app_colors.dart';
// import '../../core/widgets/loading_widget.dart';
// import '../../providers/lyrics_provider.dart';
// import '../../models/track_model.dart';


// class LyricsScreen extends StatefulWidget {
//   final String? trackId;
//   final Track? track;

//   const LyricsScreen({
//     Key? key,
//     required this.trackId,
//     this.track,
//   }) : super(key: key);

//   @override
//   State<LyricsScreen> createState() => _LyricsScreenState();
// }

// class _LyricsScreenState extends State<LyricsScreen> {
//   bool _isTranscribing = false;
//   bool _showScrollToTop = false;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadLyrics();
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollListener() {
//     if (_scrollController.offset > 200 && !_showScrollToTop) {
//       setState(() => _showScrollToTop = true);
//     } else if (_scrollController.offset <= 200 && _showScrollToTop) {
//       setState(() => _showScrollToTop = false);
//     }
//   }

//   Future<void> _loadLyrics() async {
//     final provider = context.read<LyricsProvider>();
//     if (widget.trackId == null) {
//   debugPrint('Track ID is null. Cannot load lyrics.');
//   return;
//   }
//     await provider.getLyricsForTrack(int.parse(widget.trackId!));
//   }

//   Future<void> _transcribeLyrics() async {
//     setState(() => _isTranscribing = true);
//     try {
//       final provider = context.read<LyricsProvider>();
//       if (widget.trackId == null) {
//         debugPrint('Track ID is null. Cannot load lyrics.');
//        return;
//        }
//       await provider.transcribeLyrics(int.parse(widget.trackId!));
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Lyrics transcribed successfully'),
//             backgroundColor: AppColors.primaryColor,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to transcribe lyrics: $e'),
//             backgroundColor: AppColors.errorColor,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isTranscribing = false);
//       }
//     }
//   }

//   void _handleMenuAction(String action) {
//     switch (action) {
//       case 'transcribe':
//         _transcribeLyrics();
//         break;
//       case 'edit':
//         context.push('/lyrics/${widget.trackId}/edit', extra: widget.track);
//         break;
//       case 'export':
//         _exportLyrics();
//         break;
//     }
//   }

//   Future<void> _exportLyrics() async {
//     try {
//       final provider = context.read<LyricsProvider>();
//       if (widget.trackId == null) {
//            debugPrint('Track ID is null. Cannot load lyrics.');
//           return;
//          }
//       await provider.exportLyrics(int.parse(widget.trackId!));
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Lyrics exported successfully'),
//             backgroundColor: AppColors.primaryColor,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to export lyrics: $e'),
//             backgroundColor: AppColors.errorColor,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.surfaceColor,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => context.pop(),
//           icon: Icon(
//             Icons.arrow_back,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Lyrics',
//               style: TextStyle(
//                 color: AppColors.textPrimary,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 18,
//               ),
//             ),
//             if (widget.track?.title != null)
//               Text(
//                 widget.track!.title!,
//                 style: TextStyle(
//                   color: AppColors.textSecondary,
//                   fontSize: 12,
//                 ),
//               ),
//           ],
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             icon: Icon(
//               Icons.more_vert,
//               color: AppColors.textSecondary,
//             ),
//             onSelected: (value) => _handleMenuAction(value),
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'transcribe',
//                 child: Row(
//                   children: [
//                     Icon(Icons.transcribe),
//                     SizedBox(width: 8),
//                     Text('Transcribe Audio'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'edit',
//                 child: Row(
//                   children: [
//                     Icon(Icons.edit),
//                     SizedBox(width: 8),
//                     Text('Edit Lyrics'),
//                   ],
//                 ),
//               ),
//               const PopupMenuItem(
//                 value: 'export',
//                 child: Row(
//                   children: [
//                     Icon(Icons.download),
//                     SizedBox(width: 8),
//                     Text('Export'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Consumer<LyricsProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading || _isTranscribing) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const LoadingWidget(),
//                   const SizedBox(height: 16),
//                   Text(
//                     _isTranscribing ? 'Transcribing lyrics...' : 'Loading lyrics...',
//                     style: TextStyle(
//                       color: AppColors.textSecondary,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (provider.error != null) {
//             return _buildErrorState(provider.error!);
//           }

//           if (provider.currentLyrics == null || provider.currentLyrics!.lyrics.isEmpty) {
//             return _buildEmptyState();
//           }

//           return _buildLyricsContent(provider.currentLyrics!.lyrics);
//         },
//       ),
//       floatingActionButton: _showScrollToTop
//           ? FloatingActionButton(
//               mini: true,
//               onPressed: () {
//                 _scrollController.animateTo(
//                   0,
//                   duration: const Duration(milliseconds: 500),
//                   curve: Curves.easeInOut,
//                 );
//               },
//               backgroundColor: AppColors.primaryColor,
//               child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
//             )
//           : null,
//     );
//   }

//   Widget _buildLyricsContent(String lyrics) {
//     final lines = lyrics.split('\n').where((line) => line.trim().isNotEmpty).toList();
    
//     return SingleChildScrollView(
//       controller: _scrollController,
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Lyrics Header
//           _buildLyricsHeader(),
//           const SizedBox(height: 24),

//           // Lyrics Content
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: AppColors.surfaceColor,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ...lines.map((line) => _buildLyricsLine(line)).toList(),
//               ],
//             ),
//           ),

//           const SizedBox(height: 24),

//           // Actions
//           _buildActionButtons(),
//         ],
//       ),
//     );
//   }

//   Widget _buildLyricsHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.primaryColor.withOpacity(0.1),
//             AppColors.accentColor.withOpacity(0.1),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.lyrics,
//             color: AppColors.primaryColor,
//             size: 24,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.track?.title ?? 'Unknown Track',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 if (widget.track?.artist != null)
//                   Text(
//                     'by ${widget.track!.artist}',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLyricsLine(String line) {
//     // Check if line might be a section header (e.g., [Verse 1], [Chorus])
//     final isSection = line.startsWith('[') && line.endsWith(']');
    
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Text(
//         line,
//         style: TextStyle(
//           fontSize: isSection ? 16 : 18,
//           fontWeight: isSection ? FontWeight.w600 : FontWeight.normal,
//           color: isSection ? AppColors.primaryColor : AppColors.textPrimary,
//           height: 1.6,
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () => _handleMenuAction('edit'),
//             icon: const Icon(Icons.edit),
//             label: const Text('Edit'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primaryColor,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () => _handleMenuAction('export'),
//             icon: const Icon(Icons.download),
//             label: const Text('Export'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.accentColor,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.lyrics_outlined,
//               size: 80,
//               color: AppColors.textSecondary.withOpacity(0.5),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No Lyrics Available',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Transcribe the audio to extract lyrics automatically',
//               style: TextStyle(
//                 color: AppColors.textSecondary.withOpacity(0.7),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () => _transcribeLyrics(),
//               icon: const Icon(Icons.transcribe),
//               label: const Text('Transcribe Audio'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryColor,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorState(String error) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 80,
//               color: AppColors.errorColor.withOpacity(0.5),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Error Loading Lyrics',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.errorColor,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               error,
//               style: TextStyle(
//                 color: AppColors.textSecondary,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () => _loadLyrics(),
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryColor,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/lyrics/lyrics_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/lyrics_provider.dart';
import '../../providers/track_provider.dart';
import '../../models/track_model.dart';

class LyricsScreen extends StatefulWidget {
  final String? trackId;
  final Track? track;

  const LyricsScreen({
    Key? key,
    required this.trackId,
    this.track,
  }) : super(key: key);

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  bool _isTranscribing = false;
  bool _showScrollToTop = false;
  Track? _selectedTrack;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _selectedTrack = widget.track;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedTrack != null) {
        _loadLyrics();
      } else {
        _loadTracks();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  Future<void> _loadTracks() async {
    final trackProvider = context.read<TrackProvider>();
    await trackProvider.loadTracks();
  }

  void _selectTrack(Track track) {
    setState(() {
      _selectedTrack = track;
    });
    context.read<TrackProvider>().setCurrentTrack(track);
    _loadLyrics();
  }

  Future<void> _loadLyrics() async {
    final provider = context.read<LyricsProvider>();
    if (_selectedTrack?.id == null) {
      debugPrint('Track ID is null. Cannot load lyrics.');
      return;
    }
    await provider.getLyricsForTrack(_selectedTrack!.id!);
  }

  Future<void> _transcribeLyrics() async {
    setState(() => _isTranscribing = true);
    try {
      final provider = context.read<LyricsProvider>();
      if (_selectedTrack?.id == null) {
        debugPrint('Track ID is null. Cannot transcribe lyrics.');
        return;
      }
      await provider.transcribeLyrics(_selectedTrack!.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lyrics transcribed successfully'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to transcribe lyrics: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTranscribing = false);
      }
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'transcribe':
        _transcribeLyrics();
        break;
      case 'edit':
        context.push('/lyrics/${_selectedTrack!.id}/edit', extra: _selectedTrack);
        break;
      case 'export':
        _exportLyrics();
        break;
    }
  }

  Future<void> _exportLyrics() async {
    try {
      final provider = context.read<LyricsProvider>();
      if (_selectedTrack?.id == null) {
        debugPrint('Track ID is null. Cannot export lyrics.');
        return;
      }
      await provider.exportLyrics(_selectedTrack!.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lyrics exported successfully'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export lyrics: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    }
  }

  Widget _buildTrackSelectionView() {
    return Consumer<TrackProvider>(
      builder: (context, trackProvider, child) {
        if (trackProvider.isLoading) {
          return const Center(child: LoadingWidget());
        }

        if (trackProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading tracks',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  trackProvider.error!,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Retry',
                  onPressed: _loadTracks,
                  icon: Icons.refresh,
                ),
              ],
            ),
          );
        }

        if (trackProvider.tracks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_off,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No tracks available',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload some tracks to view lyrics',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Select a track to view lyrics',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: trackProvider.tracks.length,
                itemBuilder: (context, index) {
                  final track = trackProvider.tracks[index];
                  return _TrackSelectionCard(
                    track: track,
                    onSelect: () => _selectTrack(track),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLyricsView() {
    return Consumer<LyricsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading || _isTranscribing) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoadingWidget(),
                const SizedBox(height: 16),
                Text(
                  _isTranscribing ? 'Transcribing lyrics...' : 'Loading lyrics...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.error != null) {
          return _buildErrorState(provider.error!);
        }

        if (provider.currentLyrics == null || provider.currentLyrics!.lyrics.isEmpty) {
          return _buildEmptyState();
        }

        return _buildLyricsContent(provider.currentLyrics!.lyrics);
      },
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
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedTrack == null ? 'Select Track' : 'Lyrics',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            if (_selectedTrack?.title != null)
              Text(
                _selectedTrack!.title!,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        actions: [
          if (_selectedTrack != null) ...[
            // Change Track Button
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedTrack = null;
                });
              },
              child: Text(
                'Change',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 12,
                ),
              ),
            ),
            // Menu
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: AppColors.textSecondary,
              ),
              onSelected: (value) => _handleMenuAction(value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'transcribe',
                  child: Row(
                    children: [
                      Icon(Icons.transcribe),
                      SizedBox(width: 8),
                      Text('Transcribe Audio'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit Lyrics'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.download),
                      SizedBox(width: 8),
                      Text('Export'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _selectedTrack == null ? _buildTrackSelectionView() : _buildLyricsView(),
      floatingActionButton: _showScrollToTop && _selectedTrack != null
          ? FloatingActionButton(
              mini: true,
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: AppColors.primaryColor,
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildLyricsContent(String lyrics) {
    final lines = lyrics.split('\n').where((line) => line.trim().isNotEmpty).toList();
    
    return Column(
      children: [
        // Track Info Section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lyrics,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedTrack?.title ?? 'Unknown Track',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedTrack?.artist ?? 'Unknown Artist',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lyrics available',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Lyrics Content
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...lines.map((line) => _buildLyricsLine(line)).toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Actions
                _buildActionButtons(),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLyricsLine(String line) {
    // Check if line might be a section header (e.g., [Verse 1], [Chorus])
    final isSection = line.startsWith('[') && line.endsWith(']');
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        line,
        style: TextStyle(
          fontSize: isSection ? 16 : 18,
          fontWeight: isSection ? FontWeight.w600 : FontWeight.normal,
          color: isSection ? AppColors.primaryColor : AppColors.textPrimary,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _handleMenuAction('edit'),
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _handleMenuAction('export'),
            icon: const Icon(Icons.download),
            label: const Text('Export'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lyrics_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Lyrics Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Transcribe the audio to extract lyrics automatically',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _transcribeLyrics(),
              icon: const Icon(Icons.transcribe),
              label: const Text('Transcribe Audio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.errorColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Lyrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.errorColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _loadLyrics(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackSelectionCard extends StatelessWidget {
  final Track track;
  final VoidCallback onSelect;

  const _TrackSelectionCard({
    Key? key,
    required this.track,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onSelect,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title ?? 'Unknown Track',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        track.artist ?? 'Unknown Artist',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      if (track.duration != null)
                        Text(
                          '${track.duration} seconds',
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}