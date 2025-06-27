// // // lib/screens/stem/stem_screen.dart
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:go_router/go_router.dart';
// // import '../../core/constants/app_colors.dart';
// // import '../../core/widgets/loading_widget.dart';
// // import '../../core/widgets/custom_button.dart';
// // import '../../providers/stem_provider.dart';
// // import '../../models/track_model.dart';
// // import '../../widgets/audio_player_widget.dart';
// // import '../../widgets/stem_visualizer.dart';

// // class StemScreen extends StatefulWidget {
// //   final String trackId;
// //   final TrackModel? track;

// //   const StemScreen({
// //     Key? key,
// //     required this.trackId,
// //     this.track,
// //   }) : super(key: key);

// //   @override
// //   State<StemScreen> createState() => _StemScreenState();
// // }

// // class _StemScreenState extends State<StemScreen> with TickerProviderStateMixin {
// //   late TabController _tabController;
// //   bool _isExtracting = false;
// //   String? _selectedStem;
  
// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 2, vsync: this);
// //     _loadStems();
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _loadStems() async {
// //     final provider = context.read<StemProvider>();
// //     await provider.getStems(int.parse(widget.trackId));
// //   }

// //   Future<void> _extractStems() async {
// //     setState(() => _isExtracting = true);
    
// //     try {
// //       final provider = context.read<StemProvider>();
// //       await provider.extractStems(int.parse(widget.trackId));
      
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: const Text('Stems extracted successfully!'),
// //             backgroundColor: AppColors.primaryColor,
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Failed to extract stems: $e'),
// //             backgroundColor: AppColors.errorColor,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() => _isExtracting = false);
// //       }
// //     }
// //   }

// //   Future<void> _extractStemsAndSections() async {
// //     setState(() => _isExtracting = true);
    
// //     try {
// //       final provider = context.read<StemProvider>();
// //       await provider.extractStemsAndSections(int.parse(widget.trackId));
      
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: const Text('Stems and sections extracted successfully!'),
// //             backgroundColor: AppColors.primaryColor,
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Failed to extract stems and sections: $e'),
// //             backgroundColor: AppColors.errorColor,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() => _isExtracting = false);
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.backgroundColor,
// //       appBar: AppBar(
// //         backgroundColor: AppColors.surfaceColor,
// //         elevation: 0,
// //         leading: IconButton(
// //           onPressed: () => context.pop(),
// //           icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
// //         ),
// //         title: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Stem Separation',
// //               style: TextStyle(
// //                 color: AppColors.textPrimary,
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 18,
// //               ),
// //             ),
// //             if (widget.track?.title != null)
// //               Text(
// //                 widget.track!.title,
// //                 style: TextStyle(
// //                   color: AppColors.textSecondary,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //           ],
// //         ),
// //         bottom: TabBar(
// //           controller: _tabController,
// //           indicatorColor: AppColors.primaryColor,
// //           labelColor: AppColors.primaryColor,
// //           unselectedLabelColor: AppColors.textSecondary,
// //           tabs: const [
// //             Tab(text: 'Stems'),
// //             Tab(text: 'Sections'),
// //           ],
// //         ),
// //         actions: [
// //           PopupMenuButton<String>(
// //             icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
// //             color: AppColors.surfaceColor,
// //             onSelected: (value) {
// //               if (value == 'extract') {
// //                 _extractStems();
// //               } else if (value == 'extract_sections') {
// //                 _extractStemsAndSections();
// //               }
// //             },
// //             itemBuilder: (context) => [
// //               PopupMenuItem(
// //                 value: 'extract',
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.music_note, color: AppColors.textPrimary),
// //                     const SizedBox(width: 8),
// //                     Text(
// //                       'Extract Stems',
// //                       style: TextStyle(color: AppColors.textPrimary),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               PopupMenuItem(
// //                 value: 'extract_sections',
// //                 child: Row(
// //                   children: [
// //                     Icon(Icons.library_music, color: AppColors.textPrimary),
// //                     const SizedBox(width: 8),
// //                     Text(
// //                       'Extract Stems + Sections',
// //                       style: TextStyle(color: AppColors.textPrimary),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //       body: Consumer<StemProvider>(
// //         builder: (context, provider, child) {
// //           if (_isExtracting) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   const LoadingWidget(),
// //                   const SizedBox(height: 16),
// //                   Text(
// //                     'Extracting stems...',
// //                     style: TextStyle(
// //                       color: AppColors.textPrimary,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     'This may take a few minutes',
// //                     style: TextStyle(
// //                       color: AppColors.textSecondary,
// //                       fontSize: 14,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }

// //           return TabBarView(
// //             controller: _tabController,
// //             children: [
// //               _buildStemsTab(provider),
// //               _buildSectionsTab(provider),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildStemsTab(StemProvider provider) {
// //     if (provider.isLoading && provider.stems.isEmpty) {
// //       return const Center(child: LoadingWidget());
// //     }

// //     if (provider.stems.isEmpty) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Icons.music_off,
// //               size: 64,
// //               color: AppColors.textSecondary.withOpacity(0.5),
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               'No stems available',
// //               style: TextStyle(
// //                 color: AppColors.textPrimary,
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Extract stems from this track to separate vocals, drums, bass, and other instruments',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 color: AppColors.textSecondary,
// //                 fontSize: 14,
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             CustomButton(
// //               text: 'Extract Stems',
// //               onPressed: _extractStems,
// //               icon: Icons.music_note,
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     return Column(
// //       children: [
// //         // Stems List
// //         Expanded(
// //           child: ListView.builder(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             itemCount: provider.stems.keys.length,
// //             itemBuilder: (context, index) {
// //               final stemName = provider.stems.keys.elementAt(index);
// //               final stemData = provider.stems[stemName]!;
// //               final isSelected = _selectedStem == stemName;

// //               return Container(
// //                 margin: const EdgeInsets.only(bottom: 12),
// //                 decoration: BoxDecoration(
// //                   color: AppColors.surfaceColor,
// //                   borderRadius: BorderRadius.circular(12),
// //                   border: Border.all(
// //                     color: isSelected 
// //                         ? AppColors.primaryColor 
// //                         : AppColors.surfaceColor,
// //                     width: 2,
// //                   ),
// //                 ),
// //                 child: Material(
// //                   color: Colors.transparent,
// //                   child: InkWell(
// //                     borderRadius: BorderRadius.circular(12),
// //                     onTap: () {
// //                       setState(() {
// //                         _selectedStem = isSelected ? null : stemName;
// //                       });
// //                     },
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(16),
// //                       child: Column(
// //                         children: [
// //                           Row(
// //                             children: [
// //                               Container(
// //                                 width: 48,
// //                                 height: 48,
// //                                 decoration: BoxDecoration(
// //                                   color: _getStemColor(stemName).withOpacity(0.2),
// //                                   borderRadius: BorderRadius.circular(8),
// //                                 ),
// //                                 child: Icon(
// //                                   _getStemIcon(stemName),
// //                                   color: _getStemColor(stemName),
// //                                   size: 24,
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 16),
// //                               Expanded(
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text(
// //                                       _formatStemName(stemName),
// //                                       style: TextStyle(
// //                                         color: AppColors.textPrimary,
// //                                         fontWeight: FontWeight.w600,
// //                                         fontSize: 16,
// //                                       ),
// //                                     ),
// //                                     const SizedBox(height: 4),
// //                                     Text(
// //                                       '${_formatDuration(stemData.duration ?? 0)} • ${_formatFileSize(stemData.fileSize ?? 0)}',
// //                                       style: TextStyle(
// //                                         color: AppColors.textSecondary,
// //                                         fontSize: 12,
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                               Row(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   IconButton(
// //                                     onPressed: () {
// //                                       // Play/pause stem
// //                                       _playStem(stemName, stemData.filePath);
// //                                     },
// //                                     icon: Icon(
// //                                       Icons.play_arrow,
// //                                       color: AppColors.primaryColor,
// //                                     ),
// //                                   ),
// //                                   IconButton(
// //                                     onPressed: () {
// //                                       // Download stem
// //                                       _downloadStem(stemName, stemData.filePath);
// //                                     },
// //                                     icon: Icon(
// //                                       Icons.download,
// //                                       color: AppColors.textSecondary,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
                          
// //                           // Visualizer when selected
// //                           if (isSelected) ...[
// //                             const SizedBox(height: 16),
// //                             const Divider(),
// //                             const SizedBox(height: 16),
// //                             StemVisualizer(
// //                               stemData: stemData,
// //                               color: _getStemColor(stemName),
// //                             ),
// //                             const SizedBox(height: 16),
// //                             AudioPlayerWidget(
// //                               audioUrl: stemData.filePath,
// //                               title: _formatStemName(stemName),
// //                               artist: widget.track?.artist ?? 'Unknown Artist',
// //                             ),
// //                           ],
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildSectionsTab(StemProvider provider) {
// //     if (provider.isLoading && provider.sections.isEmpty) {
// //       return const Center(child: LoadingWidget());
// //     }

// //     if (provider.sections.isEmpty) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Icons.library_music,
// //               size: 64,
// //               color: AppColors.textSecondary.withOpacity(0.5),
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               'No sections available',
// //               style: TextStyle(
// //                 color: AppColors.textPrimary,
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               'Extract stems and sections to identify different parts of the song like chorus, verse, bridge, etc.',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 color: AppColors.textSecondary,
// //                 fontSize: 14,
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //             CustomButton(
// //               text: 'Extract Stems + Sections',
// //               onPressed: _extractStemsAndSections,
// //               icon: Icons.library_music,
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     return ListView.builder(
// //       padding: const EdgeInsets.all(16),
// //       itemCount: provider.sections.keys.length,
// //       itemBuilder: (context, index) {
// //         final stemName = provider.sections.keys.elementAt(index);
// //         final sections = provider.sections[stemName]!;

// //         return Container(
// //           margin: const EdgeInsets.only(bottom: 16),
// //           decoration: BoxDecoration(
// //             color: AppColors.surfaceColor,
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Stem Header
// //               Padding(
// //                 padding: const EdgeInsets.all(16),
// //                 child: Row(
// //                   children: [
// //                     Container(
// //                       width: 40,
// //                       height: 40,
// //                       decoration: BoxDecoration(
// //                         color: _getStemColor(stemName).withOpacity(0.2),
// //                         borderRadius: BorderRadius.circular(6),
// //                       ),
// //                       child: Icon(
// //                         _getStemIcon(stemName),
// //                         color: _getStemColor(stemName),
// //                         size: 20,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Text(
// //                       _formatStemName(stemName),
// //                       style: TextStyle(
// //                         color: AppColors.textPrimary,
// //                         fontWeight: FontWeight.w600,
// //                         fontSize: 16,
// //                       ),
// //                     ),
// //                     const Spacer(),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 8,
// //                         vertical: 4,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: AppColors.primaryColor.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: Text(
// //                         '${sections.length} sections',
// //                         style: TextStyle(
// //                           color: AppColors.primaryColor,
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // Sections List
// //               ...sections.asMap().entries.map((entry) {
// //                 final sectionIndex = entry.key;
// //                 final section = entry.value;
// //                 final isLast = sectionIndex == sections.length - 1;

// //                 return Container(
// //                   margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 16 : 8),
// //                   padding: const EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: AppColors.backgroundColor,
// //                     borderRadius: BorderRadius.circular(8),
// //                     border: Border.all(
// //                       color: _getStemColor(stemName).withOpacity(0.2),
// //                     ),
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Container(
// //                         width: 24,
// //                         height: 24,
// //                         decoration: BoxDecoration(
// //                           color: _getStemColor(stemName).withOpacity(0.2),
// //                           borderRadius: BorderRadius.circular(4),
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             '${sectionIndex + 1}',
// //                             style: TextStyle(
// //                               color: _getStemColor(stemName),
// //                               fontWeight: FontWeight.w600,
// //                               fontSize: 12,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               section.name ?? 'Section ${sectionIndex + 1}',
// //                               style: TextStyle(
// //                                 color: AppColors.textPrimary,
// //                                 fontWeight: FontWeight.w500,
// //                                 fontSize: 14,
// //                               ),
// //                             ),
// //                             const SizedBox(height: 2),
// //                             Text(
// //                               '${_formatTime(section.startTime)} - ${_formatTime(section.endTime)}',
// //                               style: TextStyle(
// //                                 color: AppColors.textSecondary,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       IconButton(
// //                         onPressed: () {
// //                           _playSection(section);
// //                         },
// //                         icon: Icon(
// //                           Icons.play_arrow,
// //                           color: _getStemColor(stemName),
// //                           size: 20,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               }).toList(),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Color _getStemColor(String stemName) {
// //     switch (stemName.toLowerCase()) {
// //       case 'vocals':
// //         return Colors.purple;
// //       case 'drums':
// //         return Colors.red;
// //       case 'bass':
// //         return Colors.blue;
// //       case 'other':
// //         return Colors.green;
// //       case 'piano':
// //         return Colors.orange;
// //       case 'guitar':
// //         return Colors.amber;
// //       default:
// //         return AppColors.primaryColor;
// //     }
// //   }

// //   IconData _getStemIcon(String stemName) {
// //     switch (stemName.toLowerCase()) {
// //       case 'vocals':
// //         return Icons.mic;
// //       case 'drums':
// //         return Icons.music_note;
// //       case 'bass':
// //         return Icons.graphic_eq;
// //       case 'other':
// //         return Icons.library_music;
// //       case 'piano':
// //         return Icons.piano;
// //       case 'guitar':
// //         return Icons.music_note;
// //       default:
// //         return Icons.audiotrack;
// //     }
// //   }

// //   String _formatStemName(String stemName) {
// //     return stemName.split('_')
// //         .map((word) => word[0].toUpperCase() + word.substring(1))
// //         .join(' ');
// //   }

// //   String _formatDuration(double seconds) {
// //     final minutes = (seconds / 60).floor();
// //     final remainingSeconds = (seconds % 60).floor();
// //     return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
// //   }

// //   String _formatFileSize(int bytes) {
// //     if (bytes < 1024) return '${bytes}B';
// //     if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
// //     return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
// //   }

// //   String _formatTime(double seconds) {
// //     final minutes = (seconds / 60).floor();
// //     final remainingSeconds = (seconds % 60).floor();
// //     return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
// //   }

// //   void _playStem(String stemName, String filePath) {
// //     // TODO: Implement stem playback
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text('Playing $stemName stem'),
// //         duration: const Duration(seconds: 2),
// //       ),
// //     );
// //   }

// //   void _downloadStem(String stemName, String filePath) {
// //     // TODO: Implement stem download
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text('Downloading $stemName stem'),
// //         duration: const Duration(seconds: 2),
// //       ),
// //     );
// //   }

// //   void _playSection(dynamic section) {
// //     // TODO: Implement section playback
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text('Playing section: ${section.name}'),
// //         duration: const Duration(seconds: 2),
// //       ),
// //     );
// //   } Track Info
// //         Container(
// //           margin: const EdgeInsets.all(16),
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: AppColors.surfaceColor,
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           child: Row(
// //             children: [
// //               Container(
// //                 width: 60,
// //                 height: 60,
// //                 decoration: BoxDecoration(
// //                   color: AppColors.primaryColor.withOpacity(0.2),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Icon(
// //                   Icons.music_note,
// //                   color: AppColors.primaryColor,
// //                   size: 30,
// //                 ),
// //               ),
// //               const SizedBox(width: 16),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       widget.track?.title ?? 'Unknown Track',
// //                       style: TextStyle(
// //                         color: AppColors.textPrimary,
// //                         fontWeight: FontWeight.w600,
// //                         fontSize: 16,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       widget.track?.artist ?? 'Unknown Artist',
// //                       style: TextStyle(
// //                         color: AppColors.textSecondary,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     Text(
// //                       '${provider.stems.length} stems extracted',
// //                       style: TextStyle(
// //                         color: AppColors.primaryColor,
// //                         fontSize: 12,
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),

// //         //
// //**************version 2 ********/
// // lib/screens/stem/stem_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
// import '../../core/constants/app_colors.dart';
// import '../../core/widgets/loading_widget.dart';
// import '../../core/widgets/custom_button.dart';
// import '../../providers/stem_provider.dart';
// import '../../models/track_model.dart';
// import '../../widgets/audio_player_widget.dart';
// import '../../widgets/stem_visualizer.dart';

// class StemScreen extends StatefulWidget {
//   final String? trackId;
//   final Track? track;

//   const StemScreen({
//     Key? key,
//     required this.trackId,
//     this.track,
//   }) : super(key: key);

//   @override
//   State<StemScreen> createState() => _StemScreenState();
// }

// class _StemScreenState extends State<StemScreen> with TickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isExtracting = false;
//   String? _selectedStem;
//   String? _currentlyPlayingStem;
  
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _loadStems();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadStems() async {
//     final provider = context.read<StemProvider>();
//     await provider.getStems(int.parse(widget.trackId!));
//   }

//   Future<void> _extractStems() async {
//     setState(() => _isExtracting = true);
    
//     try {
//       final provider = context.read<StemProvider>();
//       await provider.extractStems(int.parse(widget.trackId!));
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Stems extracted successfully!'),
//             backgroundColor: AppColors.primaryColor,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to extract stems: $e'),
//             backgroundColor: AppColors.errorColor,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isExtracting = false);
//       }
//     }
//   }

//   Future<void> _extractStemsAndSections() async {
//     setState(() => _isExtracting = true);
    
//     try {
//       final provider = context.read<StemProvider>();
//       await provider.extractStemsAndSections(int.parse(widget.trackId!));
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Stems and sections extracted successfully!'),
//             backgroundColor: AppColors.primaryColor,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to extract stems and sections: $e'),
//             backgroundColor: AppColors.errorColor,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isExtracting = false);
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
//           icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Stem Separation',
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
//                   fontSize: 14,
//                 ),
//               ),
//           ],
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: AppColors.primaryColor,
//           labelColor: AppColors.primaryColor,
//           unselectedLabelColor: AppColors.textSecondary,
//           tabs: const [
//             Tab(text: 'Stems'),
//             Tab(text: 'Sections'),
//           ],
//         ),
//         actions: [
//           PopupMenuButton<String>(
//             icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
//             color: AppColors.surfaceColor,
//             onSelected: (value) {
//               if (value == 'extract') {
//                 _extractStems();
//               } else if (value == 'extract_sections') {
//                 _extractStemsAndSections();
//               }
//             },
//             itemBuilder: (context) => [
//               PopupMenuItem(
//                 value: 'extract',
//                 child: Row(
//                   children: [
//                     Icon(Icons.music_note, color: AppColors.textPrimary),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Extract Stems',
//                       style: TextStyle(color: AppColors.textPrimary),
//                     ),
//                   ],
//                 ),
//               ),
//               PopupMenuItem(
//                 value: 'extract_sections',
//                 child: Row(
//                   children: [
//                     Icon(Icons.library_music, color: AppColors.textPrimary),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Extract Stems + Sections',
//                       style: TextStyle(color: AppColors.textPrimary),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Consumer<StemProvider>(
//         builder: (context, provider, child) {
//           if (_isExtracting) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const LoadingWidget(),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Extracting stems...',
//                     style: TextStyle(
//                       color: AppColors.textPrimary,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'This may take a few minutes',
//                     style: TextStyle(
//                       color: AppColors.textSecondary,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return Column(
//             children: [
//               // Track Info Card
//               if (widget.track != null) _buildTrackInfoCard(provider),
              
//               // Tab Content
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildStemsTab(provider),
//                     _buildSectionsTab(provider),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTrackInfoCard(StemProvider provider) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: AppColors.primaryColor.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               Icons.music_note,
//               color: AppColors.primaryColor,
//               size: 30,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.track?.title ?? 'Unknown Track',
//                   style: TextStyle(
//                     color: AppColors.textPrimary,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   widget.track?.artist ?? 'Unknown Artist',
//                   style: TextStyle(
//                     color: AppColors.textSecondary,
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     if (provider.stems.isNotEmpty) ...[
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           '${provider.stems.length} stems',
//                           style: TextStyle(
//                             color: AppColors.primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                     ],
//                     if (provider.sections.isNotEmpty)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           '${provider.sections.values.fold<int>(0, (sum, sections) => sum + sections.length)} sections',
//                           style: TextStyle(
//                             color: AppColors.primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStemsTab(StemProvider provider) {
//     if (provider.isLoading && provider.stems.isEmpty) {
//       return const Center(child: LoadingWidget());
//     }

//     if (provider.stems.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.music_off,
//                 size: 64,
//                 color: AppColors.textSecondary.withOpacity(0.5),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'No stems available',
//                 style: TextStyle(
//                   color: AppColors.textPrimary,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Extract stems from this track to separate vocals, drums, bass, and other instruments',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.textSecondary,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               CustomButton(
//                 text: 'Extract Stems',
//                 onPressed: _extractStems,
//                 icon: Icons.music_note,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemCount: provider.stems.keys.length,
//       itemBuilder: (context, index) {
//         final stemName = provider.stems.keys.elementAt(index);
//         final stemData = provider.stems[stemName]!;
//         final isSelected = _selectedStem == stemName;
//         final isPlaying = _currentlyPlayingStem == stemName;

//         return Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           decoration: BoxDecoration(
//             color: AppColors.surfaceColor,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: isSelected 
//                   ? AppColors.primaryColor 
//                   : AppColors.surfaceColor,
//               width: 2,
//             ),
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               borderRadius: BorderRadius.circular(12),
//               onTap: () {
//                 setState(() {
//                   _selectedStem = isSelected ? null : stemName;
//                 });
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: 48,
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: _getStemColor(stemName).withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Icon(
//                             _getStemIcon(stemName),
//                             color: _getStemColor(stemName),
//                             size: 24,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _formatStemName(stemName),
//                                 style: TextStyle(
//                                   color: AppColors.textPrimary,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 '${_formatDuration(stemData.duration ?? 0)} • ${_formatFileSize(stemData.fileSize ?? 0)}',
//                                 style: TextStyle(
//                                   color: AppColors.textSecondary,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 _playStem(stemName, stemData.filePath);
//                               },
//                               icon: Icon(
//                                 isPlaying ? Icons.pause : Icons.play_arrow,
//                                 color: AppColors.primaryColor,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _downloadStem(stemName, stemData.filePath);
//                               },
//                               icon: Icon(
//                                 Icons.download,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
                    
//                     // Visualizer and player when selected
//                     if (isSelected) ...[
//                       const SizedBox(height: 16),
//                       Divider(color: AppColors.textSecondary.withOpacity(0.2)),
//                       const SizedBox(height: 16),
//                       StemVisualizerWidget(
//                         stems: stemData,
//                         //color: _getStemColor(stemName),
//                       ),
//                       const SizedBox(height: 16),
//                       AudioPlayerWidget(
//   currentTrack: Track(
//     id: stemData.id ?? 0, // fallback to 0 or generate a unique ID
//     filename: stemData.name ?? 'stem.wav',
//     title: _formatStemName(stemName),
//     artist: widget.track?.artist,
//     album: widget.track?.album,
//     duration: null, // optional
//     userId: widget.track?.userId,
//     filepath: stemData.filePath,
//     createdAt: DateTime.now(), // temporary placeholder
//     updatedAt: DateTime.now(), // temporary placeholder
//   ),
// ),

//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSectionsTab(StemProvider provider) {
//     if (provider.isLoading && provider.sections.isEmpty) {
//       return const Center(child: LoadingWidget());
//     }

//     if (provider.sections.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.library_music,
//                 size: 64,
//                 color: AppColors.textSecondary.withOpacity(0.5),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'No sections available',
//                 style: TextStyle(
//                   color: AppColors.textPrimary,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Extract stems and sections to identify different parts of the song like chorus, verse, bridge, etc.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: AppColors.textSecondary,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               CustomButton(
//                 text: 'Extract Stems + Sections',
//                 onPressed: _extractStemsAndSections,
//                 icon: Icons.library_music,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: provider.sections.keys.length,
//       itemBuilder: (context, index) {
//         final stemName = provider.sections.keys.elementAt(index);
//         final sections = provider.sections[stemName]!;

//         return Container(
//           margin: const EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             color: AppColors.surfaceColor,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Stem Header
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 40,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: _getStemColor(stemName).withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Icon(
//                         _getStemIcon(stemName),
//                         color: _getStemColor(stemName),
//                         size: 20,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       _formatStemName(stemName),
//                       style: TextStyle(
//                         color: AppColors.textPrimary,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const Spacer(),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.primaryColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         '${sections.length} sections',
//                         style: TextStyle(
//                           color: AppColors.primaryColor,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Sections List
//               ...sections.asMap().entries.map((entry) {
//                 final sectionIndex = entry.key;
//                 final section = entry.value;
//                 final isLast = sectionIndex == sections.length - 1;

//                 return Container(
//                   margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 16 : 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: AppColors.backgroundColor,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: _getStemColor(stemName).withOpacity(0.2),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 24,
//                         height: 24,
//                         decoration: BoxDecoration(
//                           color: _getStemColor(stemName).withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Center(
//                           child: Text(
//                             '${sectionIndex + 1}',
//                             style: TextStyle(
//                               color: _getStemColor(stemName),
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               section.name ?? 'Section ${sectionIndex + 1}',
//                               style: TextStyle(
//                                 color: AppColors.textPrimary,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               '${_formatTime(section.startTime)} - ${_formatTime(section.endTime)}',
//                               style: TextStyle(
//                                 color: AppColors.textSecondary,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           _playSection(section);
//                         },
//                         icon: Icon(
//                           Icons.play_arrow,
//                           color: _getStemColor(stemName),
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Color _getStemColor(String stemName) {
//     switch (stemName.toLowerCase()) {
//       case 'vocals':
//         return Colors.purple;
//       case 'drums':
//         return Colors.red;
//       case 'bass':
//         return Colors.blue;
//       case 'other':
//         return Colors.green;
//       case 'piano':
//         return Colors.orange;
//       case 'guitar':
//         return Colors.amber;
//       default:
//         return AppColors.primaryColor;
//     }
//   }

//   IconData _getStemIcon(String stemName) {
//     switch (stemName.toLowerCase()) {
//       case 'vocals':
//         return Icons.mic;
//       case 'drums':
//         return Icons.music_note;
//       case 'bass':
//         return Icons.graphic_eq;
//       case 'other':
//         return Icons.library_music;
//       case 'piano':
//         return Icons.piano;
//       case 'guitar':
//         return Icons.music_note;
//       default:
//         return Icons.audiotrack;
//     }
//   }

//   String _formatStemName(String stemName) {
//     return stemName.split('_')
//         .map((word) => word[0].toUpperCase() + word.substring(1))
//         .join(' ');
//   }

//   String _formatDuration(double seconds) {
//     final minutes = (seconds / 60).floor();
//     final remainingSeconds = (seconds % 60).floor();
//     return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   String _formatFileSize(int bytes) {
//     if (bytes < 1024) return '${bytes}B';
//     if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
//     return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
//   }

//   String _formatTime(double seconds) {
//     final minutes = (seconds / 60).floor();
//     final remainingSeconds = (seconds % 60).floor();
//     return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }

//   void _playStem(String stemName, String filePath) {
//     setState(() {
//       _currentlyPlayingStem = _currentlyPlayingStem == stemName ? null : stemName;
//     });
    
//     // TODO: Implement actual stem playback logic
//     // This would typically involve an audio service or player
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(_currentlyPlayingStem == stemName 
//             ? 'Playing $stemName stem' 
//             : 'Stopped $stemName stem'),
//         duration: const Duration(seconds: 2),
//         backgroundColor: AppColors.primaryColor,
//       ),
//     );
//   }



//   void _downloadStem(String stemName, String filePath) {
//     // TODO: Implement stem download functionality
//     // This would typically involve file download service
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Downloading $stemName stem...'),
//         duration: const Duration(seconds: 2),
//         action: SnackBarAction(
//           label: 'Cancel',
//           textColor: Colors.white,
//           onPressed: () {
//             // Cancel download logic
//           },
//         ),
//       ),
//     );
//   }

//   void _playSection(dynamic section) {
//     // TODO: Implement section playback with start/end time
//     // This would typically involve seeking to specific timestamps
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Playing section: ${section.name ?? "Unnamed"}'),
//         duration: const Duration(seconds: 2),
//         backgroundColor: AppColors.primaryColor,
//       ),
//     );
//   }
// }


//****version 2 *****//
// lib/screens/stem/stem_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/stem_provider.dart';
import '../../providers/track_provider.dart';
import '../../models/track_model.dart';
import '../../widgets/audio_player_widget.dart';
import '../../widgets/stem_visualizer.dart';

class StemScreen extends StatefulWidget {
  final String? trackId;
  final Track? track;

  const StemScreen({
    Key? key,
    this.trackId,
    this.track,
  }) : super(key: key);

  @override
  State<StemScreen> createState() => _StemScreenState();
}

class _StemScreenState extends State<StemScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isExtracting = false;
  String? _selectedStem;
  String? _currentlyPlayingStem;
  Track? _selectedTrack;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedTrack = widget.track;
    
    if (_selectedTrack != null) {
      _loadStems();
    } else {
      _loadTracks();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTracks() async {
    final trackProvider = context.read<TrackProvider>();
    await trackProvider.loadTracks();
  }

  Future<void> _loadStems() async {
    if (_selectedTrack?.id != null) {
      final provider = context.read<StemProvider>();
      await provider.getStems(_selectedTrack!.id!);
      debugPrint('Loading stems for track ID: ${_selectedTrack!.id}, title: ${_selectedTrack!.title}');
      
    }
  }

  void _selectTrack(Track track) {
    setState(() {
      _selectedTrack = track;
    });
    context.read<TrackProvider>().setCurrentTrack(track);
    _loadStems();
  }

  Future<void> _extractStems() async {
    if (_selectedTrack?.id == null) return;
    
    setState(() => _isExtracting = true);
    
    try {
      final provider = context.read<StemProvider>();
      await provider.extractStems(_selectedTrack!.id!);
      
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Stems extracted successfully!'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to extract stems: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExtracting = false);
      }
    }
  }

  Future<void> _extractStemsAndSections() async {
    if (_selectedTrack?.id == null) return;
    
    setState(() => _isExtracting = true);
    
    try {
      final provider = context.read<StemProvider>();
      await provider.extractStemsAndSections(_selectedTrack!.id!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Stems and sections extracted successfully!'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to extract stems and sections: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExtracting = false);
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
                  'Upload some tracks to start stem separation',
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
                'Select a track for stem separation',
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedTrack == null ? 'Select Track' : 'Stem Separation',
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
                  fontSize: 14,
                ),
              ),
          ],
        ),
        bottom: _selectedTrack != null ? TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Stems'),
            Tab(text: 'Sections'),
          ],
        ) : null,
        actions: [
          if (_selectedTrack != null)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
              color: AppColors.surfaceColor,
              onSelected: (value) {
                if (value == 'extract') {
                  _extractStems();
                } else if (value == 'extract_sections') {
                  _extractStemsAndSections();
                } else if (value == 'change_track') {
                  setState(() {
                    _selectedTrack = null;
                    _selectedStem = null;
                    _currentlyPlayingStem = null;
                  });
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'extract',
                  child: Row(
                    children: [
                      Icon(Icons.music_note, color: AppColors.textPrimary),
                      const SizedBox(width: 8),
                      Text(
                        'Extract Stems',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'extract_sections',
                  child: Row(
                    children: [
                      Icon(Icons.library_music, color: AppColors.textPrimary),
                      const SizedBox(width: 8),
                      Text(
                        'Extract Stems + Sections',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'change_track',
                  child: Row(
                    children: [
                      Icon(Icons.swap_horiz, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        'Change Track',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _selectedTrack == null 
          ? _buildTrackSelectionView() 
          : Consumer<StemProvider>(
              builder: (context, provider, child) {
                if (_isExtracting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LoadingWidget(),
                        const SizedBox(height: 16),
                        Text(
                          'Extracting stems...',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This may take a few minutes',
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
                  children: [
                    // Track Info Card
                    _buildTrackInfoCard(provider),
                    
                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildStemsTab(provider),
                          _buildSectionsTab(provider),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildTrackInfoCard(StemProvider provider) {
    return Container(
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
              Icons.music_note,
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
                Row(
                  children: [
                    if (provider.stems.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${provider.stems.length} stems',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (provider.sections.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${provider.sections.values.fold<int>(0, (sum, sections) => sum + sections.length)} sections',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Change Track Button
          TextButton(
            onPressed: () {
              setState(() {
                _selectedTrack = null;
                _selectedStem = null;
                _currentlyPlayingStem = null;
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
        ],
      ),
    );
  }

  Widget _buildStemsTab(StemProvider provider) {
    if (provider.isLoading && provider.stems.isEmpty) {
      return const Center(child: LoadingWidget());
    }

    if (provider.stems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
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
                'No stems available',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Extract stems from this track to separate vocals, drums, bass, and other instruments',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Extract Stems',
                onPressed: _extractStems,
                icon: Icons.music_note,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.stems.keys.length,
      itemBuilder: (context, index) {
        final stemName = provider.stems.keys.elementAt(index);
        final stemData = provider.stems[stemName]!;
        final isSelected = _selectedStem == stemName;
        final isPlaying = _currentlyPlayingStem == stemName;
        print('🧪 Stem Debug → index: $index | stemName: $stemName | isSelected: $isSelected | isPlaying: $isPlaying | duration: ${stemData.duration} | filePath: ${stemData.filepath} | name: ${stemData.name}');

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected 
                  ? AppColors.primaryColor 
                  : AppColors.surfaceColor,
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  _selectedStem = isSelected ? null : stemName;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _getStemColor(stemName).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getStemIcon(stemName),
                            color: _getStemColor(stemName),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatStemName(stemName),
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_formatDuration(stemData.duration ?? 0)}', //• ${_formatFileSize(stemData.fileSize ?? 0)}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _playStem(stemName, stemData.filepath);
                              },
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _downloadStem(stemName, stemData.filepath);
                              },
                              icon: Icon(
                                Icons.download,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Visualizer and player when selected
                    if (isSelected) ...[
                      const SizedBox(height: 16),
                      Divider(color: AppColors.textSecondary.withOpacity(0.2)),
                      const SizedBox(height: 16),
                      StemVisualizerWidget(
                        stems: [stemData],
                        //color: _getStemColor(stemName),
                      ),
                      const SizedBox(height: 16),
                      AudioPlayerWidget(
                        currentTrack: Track(
                          id: stemData.id ?? 0,
                          filename: stemData.name ?? 'stem.wav',
                          title: _formatStemName(stemName),
                          artist: _selectedTrack?.artist,
                          album: _selectedTrack?.album,
                          duration: null,
                          userId: _selectedTrack?.userId,
                          filepath: stemData.filepath,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionsTab(StemProvider provider) {
    if (provider.isLoading && provider.sections.isEmpty) {
      return const Center(child: LoadingWidget());
    }

    if (provider.sections.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_music,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No sections available',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Extract stems and sections to identify different parts of the song like chorus, verse, bridge, etc.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Extract Stems + Sections',
                onPressed: _extractStemsAndSections,
                icon: Icons.library_music,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.sections.keys.length,
      itemBuilder: (context, index) {
        final stemName = provider.sections.keys.elementAt(index);
        final sections = provider.sections[stemName]!;
        debugPrint('Returned from listview builder- Stem: $stemName → Sections: ${sections.map((s) => s?.sectionName ?? "Unnamed").toList()}');


        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stem Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getStemColor(stemName).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        _getStemIcon(stemName),
                        color: _getStemColor(stemName),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatStemName(stemName),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${sections.length} sections',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sections List
              ...sections.asMap().entries.map((entry) {
                final sectionIndex = entry.key;
                final section = entry.value;
                final isLast = sectionIndex == sections.length - 1;
                debugPrint('From sections list-  Stem: $stemName | Section Index: $sectionIndex | Name: ${section.sectionName} | isLast: $isLast');

                return Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, isLast ? 16 : 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getStemColor(stemName).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _getStemColor(stemName).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '${sectionIndex + 1}',
                            style: TextStyle(
                              color: _getStemColor(stemName),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.sectionName ?? 'Section ${sectionIndex + 1}',                              
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_formatTime(section.startTime)} - ${_formatTime(section.endTime)}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _playSection(section);
                        },
                        icon: Icon(
                          Icons.play_arrow,
                          color: _getStemColor(stemName),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Color _getStemColor(String stemName) {
    switch (stemName.toLowerCase()) {
      case 'vocals':
        return Colors.purple;
      case 'drums':
        return Colors.red;
      case 'bass':
        return Colors.blue;
      case 'other':
        return Colors.green;
      case 'piano':
        return Colors.orange;
      case 'guitar':
        return Colors.amber;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData _getStemIcon(String stemName) {
    switch (stemName.toLowerCase()) {
      case 'vocals':
        return Icons.mic;
      case 'drums':
        return Icons.music_note;
      case 'bass':
        return Icons.graphic_eq;
      case 'other':
        return Icons.library_music;
      case 'piano':
        return Icons.piano;
      case 'guitar':
        return Icons.music_note;
      default:
        return Icons.audiotrack;
    }
  }

  String _formatStemName(String stemName) {
    return stemName.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String _formatTime(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _playStem(String stemName, String filepath) {
    setState(() {
      _currentlyPlayingStem = _currentlyPlayingStem == stemName ? null : stemName;
    });
    
    // TODO: Implement actual stem playback logic
    // This would typically involve an audio service or player
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_currentlyPlayingStem == stemName 
            ? 'Playing $stemName stem' 
            : 'Stopped $stemName stem'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }


     void _downloadStem(String stemName, String filePath) {
    // TODO: Implement stem download functionality
    // This would typically involve file download service
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading $stemName stem...'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Cancel',
          textColor: Colors.white,
          onPressed: () {
            // Cancel download logic
          },
        ),
      ),
    );
  }

  void _playSection(dynamic section) {
    // TODO: Implement section playback with start/end time
    // This would typically involve seeking to specific timestamps
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing section: ${section.name ?? "Unnamed"}'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor,
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