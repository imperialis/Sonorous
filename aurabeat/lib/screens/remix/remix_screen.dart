// // lib/screens/remix/remix_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
// import '../../core/constants/app_colors.dart';
// import '../../core/widgets/loading_widget.dart';
// import '../../core/widgets/custom_button.dart';
// import '../../providers/remix_provider.dart';
// import '../../providers/stem_provider.dart';
// import '../../providers/track_provider.dart';
// import '../../models/track_model.dart';
// import '../../models/remix_model.dart';

// // Assuming these models exist and are correctly structured:
// // class Track { String? id; String? title; String? artist; int? duration; }
// // class RemixStructure { String source; String? section; RemixEffects? effects; RemixStructure copyWith({String? source, String? section, RemixEffects? effects}); }
// // class RemixEffects { double? volumeDb; double? tempo; bool? normalize; RemixEffects copyWith({double? volumeDb, double? tempo, bool? normalize}); }
// // class StemSection { String sectionName; } // Assuming StemSection has a sectionName property

// class RemixScreen extends StatefulWidget {
//   final String? trackId;
//   final Track? track;

//   const RemixScreen({
//     Key? key,
//     required this.trackId,
//     this.track,
//   }) : super(key: key);

//   @override
//   State<RemixScreen> createState() => _RemixScreenState();
// }

// class _RemixScreenState extends State<RemixScreen> {
//   List<RemixStructure> _remixStructure = [];
//   bool _isProcessing = false;
//   Track? _selectedTrack;

//   // Moved _cleanStemName here so it can be used for initial setup if needed
//   String _cleanStemName(String? name) {
//     if (name == null) return 'unknown';
//     // Remove common file extensions and convert to lowercase for consistent keys
//     return name.replaceAll(RegExp(r'\.(wav|mp3|aiff)$', caseSensitive: false), '').toLowerCase();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _selectedTrack = widget.track;

//     if (_selectedTrack != null) {
//       _loadStems();
//     } else {
//       _loadTracks();
//     }
//   }

//   Future<void> _loadTracks() async {
//     final trackProvider = context.read<TrackProvider>();
//     await trackProvider.loadTracks();
//     // If a trackId was passed and track is null, try to find it after loading tracks
//     // if (widget.trackId != null && _selectedTrack == null) {
//     //   final foundTrack = trackProvider.tracks.firstWhere(
//     //     (t) => t.id == widget.trackId,
//     //     orElse: () => Track(
//     //       id: -1, // Provide a dummy ID for not found track
//     //       filename: 'not_found_track.wav', // Provide a default filename
//     //       filepath: '/path/to/not_found_track.wav', // Provide a default filepath
//     //       createdAt: DateTime.now(), // Provide a default creation date
//     //       updatedAt: DateTime.now(), // Provide a default updated date
//     //       title: 'Not Found',
//     //       artist: 'N/A',
//     //     ), // Provide a default if not found
//     //   );
//     //   if (foundTrack.id != null) {
//     //     _selectTrack(foundTrack);
//     //   }
//     // }
//   }

//   Future<void> _loadStems() async {
//     if (_selectedTrack?.id != null) {
//       print('DEBUG: Loading stems for track ID: ${_selectedTrack!.id!}');
//       final stemProvider = context.read<StemProvider>();
//       await stemProvider.getStems(_selectedTrack!.id!);
//       print('DEBUG: Stems loaded. Available stems keys: ${stemProvider.stems.keys.toList()}');
//       print('DEBUG: Sections map after loading stems: ${stemProvider.sections.map((key, value) => MapEntry(key, value.map((s) => s.sectionName).toList()))}');
//     }
//   }

//   void _selectTrack(Track track) {
//     setState(() {
//       _selectedTrack = track;
//     });
//     context.read<TrackProvider>().setCurrentTrack(track);
//     _loadStems();
//   }

//   void _addRemixSection() {
//     setState(() {
//       // Initialize with a source that is likely to have sections (e.g., 'vocals')
//       // and ensure it's in the cleaned format.
//       _remixStructure.add(RemixStructure(
//         source: _cleanStemName('vocals'), // Default source, ensure it's cleaned
//         section: null, // No section selected initially
//         effects: RemixEffects(),
//       ));
//     });
//   }

//   void _removeRemixSection(int index) {
//     setState(() {
//       _remixStructure.removeAt(index);
//     });
//   }

//   void _updateRemixSection(int index, RemixStructure structure) {
//     setState(() {
//       _remixStructure[index] = structure;
//     });
//   }

//   Future<void> _createRemix() async {
//     if (_remixStructure.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Please add at least one section to the remix'),
//           backgroundColor: AppColors.errorColor,
//         ),
//       );
//       return;
//     }

//     // Check if any section is null or if source is not selected for any remix structure
//     final incompleteSections = _remixStructure.where((s) => s.source == 'unknown' || s.section == null).toList();
//     if (incompleteSections.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Please select a valid Source Stem and Section for all remix parts.'),
//           backgroundColor: AppColors.errorColor,
//         ),
//       );
//       return;
//     }


//     setState(() => _isProcessing = true);

//     try {
//       final provider = context.read<RemixProvider>();
//       await provider.createRemix(_selectedTrack!.id!, _remixStructure);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Remix created successfully!'),
//             backgroundColor: AppColors.primaryColor,
//           ),
//         );
//         context.pop();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to create remix: $e'),
//             backgroundColor: AppColors.errorColor,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isProcessing = false);
//       }
//     }
//   }

//   Widget _buildTrackSelectionView() {
//     return Consumer<TrackProvider>(
//       builder: (context, trackProvider, child) {
//         if (trackProvider.isLoading) {
//           return const Center(child: LoadingWidget());
//         }

//         if (trackProvider.error != null) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   size: 64,
//                   color: AppColors.errorColor,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Error loading tracks',
//                   style: TextStyle(
//                     color: AppColors.textPrimary,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   trackProvider.error!,
//                   style: TextStyle(
//                     color: AppColors.textSecondary,
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 CustomButton(
//                   text: 'Retry',
//                   onPressed: _loadTracks,
//                   icon: Icons.refresh,
//                 ),
//               ],
//             ),
//           );
//         }

//         if (trackProvider.tracks.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.music_off,
//                   size: 64,
//                   color: AppColors.textSecondary.withOpacity(0.5),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No tracks available',
//                   style: TextStyle(
//                     color: AppColors.textPrimary,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Upload some tracks to start remixing',
//                   style: TextStyle(
//                     color: AppColors.textSecondary,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 'Select a track to remix',
//                 style: TextStyle(
//                   color: AppColors.textPrimary,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: trackProvider.tracks.length,
//                 itemBuilder: (context, index) {
//                   final track = trackProvider.tracks[index];
//                   return _TrackSelectionCard(
//                     track: track,
//                     onSelect: () => _selectTrack(track),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildRemixView() {
//     return Consumer2<StemProvider, RemixProvider>(
//       builder: (context, stemProvider, remixProvider, child) {
//         if (stemProvider.isLoading && stemProvider.stems.isEmpty) {
//           return const Center(child: LoadingWidget());
//         }

//         return Column(
//           children: [
//             // Track Info Section
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: AppColors.surfaceColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryColor.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.music_note,
//                       color: AppColors.primaryColor,
//                       size: 30,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _selectedTrack?.title ?? 'Unknown Track',
//                           style: TextStyle(
//                             color: AppColors.textPrimary,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           _selectedTrack?.artist ?? 'Unknown Artist',
//                           style: TextStyle(
//                             color: AppColors.textSecondary,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '${stemProvider.stems.length} stems available',
//                           style: TextStyle(
//                             color: AppColors.primaryColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Change Track Button
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _selectedTrack = null;
//                         _remixStructure.clear();
//                       });
//                     },
//                     child: Text(
//                       'Change',
//                       style: TextStyle(
//                         color: AppColors.primaryColor,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Available Stems Section (Visual display of all available stems)
//             if (stemProvider.stems.isNotEmpty)
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColors.surfaceColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Available Stem Sections', // This label might be misleading, it's actually 'Available Stems'
//                       style: TextStyle(
//                         color: AppColors.textPrimary,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: stemProvider.stems.keys.map((stemName) {
//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.primaryColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: AppColors.primaryColor.withOpacity(0.3),
//                             ),
//                           ),
//                           child: Text(
//                             stemName, // This displays the actual stem names from the provider
//                             style: TextStyle(
//                               color: AppColors.primaryColor,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),

//             const SizedBox(height: 16),

//             // Remix Structure Section (where individual remix parts are added/configured)
//             Expanded(
//               child: Column(
//                 children: [
//                   // Header with Add Button
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Remix Structure',
//                           style: TextStyle(
//                             color: AppColors.textPrimary,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                           ),
//                         ),
//                         CustomButton(
//                           text: 'Add Section', // This should probably be 'Add Part' or 'Add Remix Segment'
//                           onPressed: _addRemixSection,
//                           isSmall: true,
//                           icon: Icons.add,
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // Remix Sections List
//                   Expanded(
//                     child: _remixStructure.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.queue_music,
//                                   size: 64,
//                                   color: AppColors.textSecondary.withOpacity(0.5),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   'No sections added yet',
//                                   style: TextStyle(
//                                     color: AppColors.textSecondary,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'Add sections to build your remix',
//                                   style: TextStyle(
//                                     color: AppColors.textSecondary.withOpacity(0.7),
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             itemCount: _remixStructure.length,
//                             itemBuilder: (context, index) {
//                               return _RemixSectionCard(
//                                 index: index,
//                                 structure: _remixStructure[index],
//                                 // Ensure these availableStems are correctly populated
//                                 // and match the expected keys in stemProvider.sections
//                                 availableStems: stemProvider.stems.keys.toList(),
//                                 onUpdate: (structure) => _updateRemixSection(index, structure),
//                                 onRemove: () => _removeRemixSection(index),
//                               );
//                             },
//                           ),
//                   ),
//                 ],
//               ),
//             ),

//             // Processing Indicator
//             if (_isProcessing)
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     const LoadingWidget(),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Creating your remix...',
//                       style: TextStyle(
//                         color: AppColors.textSecondary,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         );
//       },
//     );
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
//               _selectedTrack == null ? 'Select Track' : 'Create Remix',
//               style: TextStyle(
//                 color: AppColors.textPrimary,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 18,
//               ),
//             ),
//             if (_selectedTrack?.title != null)
//               Text(
//                 _selectedTrack!.title!,
//                 style: TextStyle(
//                   color: AppColors.textSecondary,
//                   fontSize: 14,
//                 ),
//               ),
//           ],
//         ),
//         actions: [
//           if (!_isProcessing && _selectedTrack != null)
//             TextButton(
//               onPressed: _createRemix,
//               child: Text(
//                 'Create',
//                 style: TextStyle(
//                   color: AppColors.primaryColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: _selectedTrack == null ? _buildTrackSelectionView() : _buildRemixView(),
//     );
//   }
// }

// class _TrackSelectionCard extends StatelessWidget {
//   final Track track;
//   final VoidCallback onSelect;

//   const _TrackSelectionCard({
//     Key? key,
//     required this.track,
//     required this.onSelect,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: onSelect,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     Icons.music_note,
//                     color: AppColors.primaryColor,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         track.title ?? 'Unknown Track',
//                         style: TextStyle(
//                           color: AppColors.textPrimary,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         track.artist ?? 'Unknown Artist',
//                         style: TextStyle(
//                           color: AppColors.textSecondary,
//                           fontSize: 14,
//                         ),
//                       ),
//                       if (track.duration != null)
//                         Text(
//                           '${track.duration} seconds',
//                           style: TextStyle(
//                             color: AppColors.textSecondary.withOpacity(0.7),
//                             fontSize: 12,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   color: AppColors.textSecondary,
//                   size: 16,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _RemixSectionCard extends StatefulWidget {
//   final int index;
//   final RemixStructure structure;
//   final List<String> availableStems; // These are the 'cleaned' stem names (e.g., 'vocals', 'drums')
//   final Function(RemixStructure) onUpdate;
//   final VoidCallback onRemove;

//   const _RemixSectionCard({
//     Key? key,
//     required this.index,
//     required this.structure,
//     required this.availableStems,
//     required this.onUpdate,
//     required this.onRemove,
//   }) : super(key: key);

//   @override
//   State<_RemixSectionCard> createState() => _RemixSectionCardState();
// }

// class _RemixSectionCardState extends State<_RemixSectionCard> {
//   late RemixStructure _structure;
//   bool _isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _structure = widget.structure;
//     // If the initial source is 'vocals' or similar, ensure it's cleaned if the provider expects cleaned names
//     // For consistency, ensure the default 'vocals' in _addRemixSection is also cleaned or matches provider's keys.
//   }

//   // This method ensures the selected stem name is consistent for lookup.
//   // It removes common audio file extensions and converts to lowercase.
//   String _cleanStemName(String? name) {
//     if (name == null) return 'unknown'; // Use 'unknown' or an empty string as a default if null
//     return name.replaceAll(RegExp(r'\.(wav|mp3|aiff)$', caseSensitive: false), '').toLowerCase();
//   }

//   void _updateStructure() {
//     widget.onUpdate(_structure);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final stemProvider = context.read<StemProvider>();

//     // --- DEBUG PRINTS ---
//     print('\n--- Building _RemixSectionCard for index ${widget.index} ---');
//     print('Current _structure.source: ${_structure.source}');
//     print('Current _structure.section: ${_structure.section}');
//     print('Available stems passed to card: ${widget.availableStems}');

//     if (_structure.source != null) {
//       final cleanedSource = _cleanStemName(_structure.source); // Ensure consistent lookup key
//       print('Cleaned source for lookup: $cleanedSource');
//       final sectionsForSource = stemProvider.sections[cleanedSource];
//       print('Sections found for "$cleanedSource" in StemProvider.sections: ${sectionsForSource?.map((s) => s.sectionName).toList()}');
//       print('Is sectionsForSource null? ${sectionsForSource == null}');
//       print('Is sectionsForSource empty? ${sectionsForSource?.isEmpty}');
//     }
//     print('--- End _RemixSectionCard debug ---\n');
//     // --- END DEBUG PRINTS ---


//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceColor,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: AppColors.primaryColor.withOpacity(0.2),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 32,
//                   height: 32,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryColor.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Center(
//                     child: Text(
//                       '${widget.index + 1}',
//                       style: TextStyle(
//                         color: AppColors.primaryColor,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _structure.source,
//                         style: TextStyle(
//                           color: AppColors.textPrimary,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                       if (_structure.section != null)
//                         Text(
//                           _structure.section!,
//                           style: TextStyle(
//                             color: AppColors.textSecondary,
//                             fontSize: 12,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () => setState(() => _isExpanded = !_isExpanded),
//                   icon: Icon(
//                     _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: widget.onRemove,
//                   icon: Icon(
//                     Icons.delete_outline,
//                     color: AppColors.errorColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Expanded Controls
//           if (_isExpanded)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Divider(),
//                   const SizedBox(height: 16),

//                   // Source Selection (Dropdown for Stem Type)
//                   Text(
//                     'Source Stem',
//                     style: TextStyle(
//                       color: AppColors.textPrimary,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<String>(
//                     value: _structure.source,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: AppColors.backgroundColor,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                     ),
//                     dropdownColor: AppColors.surfaceColor,
//                     style: TextStyle(color: AppColors.textPrimary),
//                     items: widget.availableStems.map((stem) {
//                       // Ensure the value here matches the format expected by _structure.source
//                       // which is then used to lookup in stemProvider.sections
//                       return DropdownMenuItem(
//                         value: _cleanStemName(stem), // Clean the stem name here for display and consistency
//                         child: Text(stem), // Display the original stem name
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         setState(() {
//                           _structure = _structure.copyWith(source: value, section: null); // Reset section when source changes
//                         });
//                         _updateStructure();
//                       }
//                     },
//                   ),

//                   // Conditional rendering for Section dropdown
//                   // This condition checks if the selected source is not null,
//                   // if the StemProvider has entries for this source,
//                   // and if that list of sections is not empty.
//                   if (_structure.source != null &&
//                       stemProvider.sections[_structure.source!] != null &&
//                       stemProvider.sections[_structure.source!]!.isNotEmpty)
//                     ...[
//                       const SizedBox(height: 16),
//                       Text(
//                         'Section',
//                         style: TextStyle(
//                           color: AppColors.textPrimary,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       DropdownButtonFormField<String>(
//                         value: _structure.section,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: AppColors.backgroundColor,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         ),
//                         items: stemProvider.sections[_structure.source!]!
//                             .map<DropdownMenuItem<String>>((s) => DropdownMenuItem<String>(
//                                   value: s.sectionName,
//                                   child: Text(s.sectionName),
//                                 ))
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             // CORRECTED: Update the 'section' field
//                             _structure = _structure.copyWith(section: value);
//                           });
//                           _updateStructure();
//                         },
//                       ),
//                     ],

//                   const SizedBox(height: 16),

//                   // Effects Section
//                   Text(
//                     'Effects',
//                     style: TextStyle(
//                       color: AppColors.textPrimary,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Volume Slider
//                   Row(
//                     children: [
//                       Text(
//                         'Volume',
//                         style: TextStyle(
//                           color: AppColors.textSecondary,
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Slider(
//                           value: (_structure.effects?.volumeDb ?? 0.0) + 10.0,
//                           min: -10.0,
//                           max: 20.0,
//                           divisions: 30,
//                           activeColor: AppColors.primaryColor,
//                           inactiveColor: AppColors.primaryColor.withOpacity(0.3),
//                           onChanged: (value) {
//                             setState(() {
//                               _structure = _structure.copyWith(
//                                 effects: _structure.effects?.copyWith(
//                                   volumeDb: value - 10.0,
//                                 ),
//                               );
//                             });
//                             _updateStructure();
//                           },
//                         ),
//                       ),
//                       Text(
//                         '${((_structure.effects?.volumeDb ?? 0.0)).toStringAsFixed(1)}dB',
//                         style: TextStyle(
//                           color: AppColors.textSecondary,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),

//                   // Tempo Slider
//                   Row(
//                     children: [
//                       Text(
//                         'Tempo',
//                         style: TextStyle(
//                           color: AppColors.textSecondary,
//                           fontSize: 12,
//                         ),
//                         ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Slider(
//                           value: _structure.effects?.tempo ?? 1.0,
//                           min: 0.5,
//                           max: 2.0,
//                           divisions: 30,
//                           activeColor: AppColors.primaryColor,
//                           inactiveColor: AppColors.primaryColor.withOpacity(0.3),
//                           onChanged: (value) {
//                             setState(() {
//                               _structure = _structure.copyWith(
//                                 effects: _structure.effects?.copyWith(
//                                   tempo: value,
//                                 ),
//                               );
//                             });
//                             _updateStructure();
//                           },
//                         ),
//                       ),
//                       Text(
//                         '${((_structure.effects?.tempo ?? 1.0) * 100).toStringAsFixed(0)}%',
//                         style: TextStyle(
//                           color: AppColors.textSecondary,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),

//                   // Normalize Toggle
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Normalize Audio',
//                         style: TextStyle(
//                           color: AppColors.textSecondary,
//                           fontSize: 12,
//                         ),
//                       ),
//                       Switch(
//                         value: _structure.effects?.normalize ?? false,
//                         activeColor: AppColors.primaryColor,
//                         onChanged: (value) {
//                           setState(() {
//                             _structure = _structure.copyWith(
//                               effects: _structure.effects?.copyWith(
//                                 normalize: value,
//                               ),
//                             );
//                           });
//                           _updateStructure();
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/remix_provider.dart';
import '../../providers/stem_provider.dart';
import '../../providers/track_provider.dart';
import '../../models/track_model.dart';
import '../../models/remix_model.dart';

class RemixScreen extends StatefulWidget {
  final String? trackId;
  final Track? track;

  const RemixScreen({
    Key? key,
    required this.trackId,
    this.track,
  }) : super(key: key);

  @override
  State<RemixScreen> createState() => _RemixScreenState();
}

class _RemixScreenState extends State<RemixScreen> {
  List<RemixStructure> _remixStructure = [];
  bool _isProcessing = false;
  Track? _selectedTrack;

  String _cleanStemName(String? name) {
    if (name == null) return 'unknown';
    return name.replaceAll(RegExp(r'\.(wav|mp3|aiff)$', caseSensitive: false), '').toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    _selectedTrack = widget.track;
    if (_selectedTrack != null) {
      _loadStems();
    } else {
      _loadTracks();
    }
  }

  Future<void> _loadTracks() async {
    final trackProvider = context.read<TrackProvider>();
    await trackProvider.loadTracks();
  }

  Future<void> _loadStems() async {
    if (_selectedTrack?.id != null) {
      print('DEBUG: Loading stems for track ID: ${_selectedTrack!.id!}');
      final stemProvider = context.read<StemProvider>();
      await stemProvider.getStems(_selectedTrack!.id!);
      print('DEBUG: Stems loaded. Available stems keys: ${stemProvider.stems.keys.toList()}');
      print('DEBUG: Sections map after loading stems: ${stemProvider.sections.map((key, value) => MapEntry(key, value.map((s) => s.sectionName).toList()))}');
    }
  }

  void _selectTrack(Track track) {
    setState(() {
      _selectedTrack = track;
    });
    context.read<TrackProvider>().setCurrentTrack(track);
    _loadStems();
  }

  void _addRemixSection() {
    setState(() {
      _remixStructure.add(RemixStructure(
        source: _cleanStemName('vocals'),
        section: null,
        effects: RemixEffects(),
      ));
    });
  }

  void _removeRemixSection(int index) {
    setState(() {
      _remixStructure.removeAt(index);
    });
  }

  void _updateRemixSection(int index, RemixStructure structure) {
    setState(() {
      _remixStructure[index] = structure;
    });
  }

  Future<void> _createRemix() async {
    if (_remixStructure.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least one section to the remix'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    final incompleteSections = _remixStructure.where((s) => s.source == 'unknown' || s.section == null).toList();
    if (incompleteSections.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a valid Source Stem and Section for all remix parts.'),
          backgroundColor: AppColors.errorColor,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final provider = context.read<RemixProvider>();
      await provider.createRemix(_selectedTrack!.id!, _remixStructure);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Remix created successfully!'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create remix: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
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
                  'Upload some tracks to start remixing',
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
                'Select a track to remix',
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

  Widget _buildRemixView() {
    return Consumer2<StemProvider, RemixProvider>(
      builder: (context, stemProvider, remixProvider, child) {
        if (stemProvider.isLoading && stemProvider.stems.isEmpty) {
          return const Center(child: LoadingWidget());
        }

        return Column(
          children: [
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
                        Text(
                          '${stemProvider.stems.length} stems available',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedTrack = null;
                        _remixStructure.clear();
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
            ),

            if (stemProvider.stems.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Stem Sections',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: stemProvider.stems.keys.map((stemName) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            stemName,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remix Structure',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      CustomButton(
                        text: 'Add Section',
                        onPressed: _addRemixSection,
                        isSmall: true,
                        icon: Icons.add,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (_remixStructure.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.queue_music,
                            size: 64,
                            color: AppColors.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No sections added yet',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add sections to build your remix',
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._remixStructure.asMap().entries.map((entry) {
                      final index = entry.key;
                      final structure = entry.value;
                      return _RemixSectionCard(
                        index: index,
                        structure: structure,
                        availableStems: stemProvider.stems.keys.toList(),
                        onUpdate: (structure) => _updateRemixSection(index, structure),
                        onRemove: () => _removeRemixSection(index),
                      );
                    }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                text: _isProcessing ? 'Processing...' : 'Create Remix',
                onPressed: _isProcessing ? null : _createRemix,
                icon: Icons.music_note,
              ),
            ),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Remix'),
      ),
      body: _selectedTrack == null
          ? _buildTrackSelectionView()
          : _buildRemixView(),
    );
  }
}

// Example placeholder widgets for _TrackSelectionCard and _RemixSectionCard.
// You should replace these with your actual widget implementations.

class _TrackSelectionCard extends StatelessWidget {
  final Track track;
  final VoidCallback onSelect;

  const _TrackSelectionCard({required this.track, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.music_note),
      title: Text(track.title!),
      subtitle: Text(track.artist ?? ''),
      onTap: onSelect,
    );
  }
}

class _RemixSectionCard extends StatelessWidget {
  final int index;
  final RemixStructure structure;
  final List<String> availableStems;
  final Function(RemixStructure) onUpdate;
  final VoidCallback onRemove;

  const _RemixSectionCard({
    required this.index,
    required this.structure,
    required this.availableStems,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // Your remix section card UI here
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('Section ${index + 1} - Source: ${structure.source}'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
