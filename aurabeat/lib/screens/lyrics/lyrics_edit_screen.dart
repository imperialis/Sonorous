// // lib/screens/lyrics/lyrics_edit_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
// import '../../core/constants/app_colors.dart';
// import '../../core/widgets/loading_widget.dart';
// import '../../core/widgets/custom_button.dart';
// import '../../providers/lyrics_provider.dart';
// import '../../models/track_model.dart';

// class LyricsEditScreen extends StatefulWidget {
//   final String? trackId;
//   final Track? track;
//   //decide on removal
//   final String? currentLyrics;

//   const LyricsEditScreen({
//     Key? key,
//     required this.trackId,
//     this.track,
//     //decide on removal
//     this.currentLyrics,
//   }) : super(key: key);

//   @override
//   State<LyricsEditScreen> createState() => _LyricsEditScreenState();
// }

// class _LyricsEditScreenState extends State<LyricsEditScreen> {
//   late TextEditingController _lyricsController;
//   bool _hasChanges = false;
//   bool _isSaving = false;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _lyricsController = TextEditingController();
//     _lyricsController.addListener(() {
//       if (!_hasChanges) {
//         setState(() => _hasChanges = true);
//       }
//     });
//     _loadCurrentLyrics();
//   }

//   @override
//   void dispose() {
//     _lyricsController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadCurrentLyrics() async {
//     final provider = context.read<LyricsProvider>();
//     if (widget.trackId == null) {
//        debugPrint('Track ID is null. Cannot load lyrics.');
//        return;
//       }
//     await provider.getLyricsForTrack(int.parse(widget.trackId!));
//     if (provider.currentLyrics != null) {
//       _lyricsController.text = provider.currentLyrics!.lyrics;
//     }
//   }

//   Future<void> _saveLyrics() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isSaving = true);
//     try {
//       final provider = context.read<LyricsProvider>();
//       if (widget.trackId == null) {
//           debugPrint('Track ID is null. Cannot load lyrics.');
//        return;
//        }
//       await provider.editLyrics(
//         int.parse(widget.trackId!),
//         _lyricsController.text,
//       );
      
//       if (mounted) {
//         setState(() => _hasChanges = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Lyrics saved successfully'),
//             backgroundColor: AppColors.primaryColor,
//           ),
//         );
//         context.pop();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to save lyrics: $e'),
//             backgroundColor: AppColors.errorColor,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isSaving = false);
//       }
//     }
//   }

//   void _insertSection(String sectionType) {
//     final text = _lyricsController.text;
//     final selection = _lyricsController.selection;
//     final sectionLabel = '[$sectionType]\n';
    
//     final newText = text.replaceRange(
//       selection.start,
//       selection.end,
//       sectionLabel,
//     );
    
//     _lyricsController.text = newText;
//     _lyricsController.selection = TextSelection.collapsed(
//       offset: selection.start + sectionLabel.length,
//     );
//   }

//   Future<bool> _onWillPop() async {
//     if (!_hasChanges) return true;
    
//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: AppColors.surfaceColor,
//         title: Text(
//           'Unsaved Changes',
//           style: TextStyle(color: AppColors.textPrimary),
//         ),
//         content: Text(
//           'You have unsaved changes. Do you want to discard them?',
//           style: TextStyle(color: AppColors.textSecondary),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: Text('Discard', style: TextStyle(color: AppColors.errorColor)),
//           ),
//         ],
//       ),
//     );
    
//     return result ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         appBar: AppBar(
//           backgroundColor: AppColors.surfaceColor,
//           elevation: 0,
//           leading: IconButton(
//             onPressed: () async {
//               if (await _onWillPop()) {
//                 context.pop();
//               }
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Edit Lyrics',
//                 style: TextStyle(
//                   color: AppColors.textPrimary,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 18,
//                 ),
//               ),
//               if (widget.track?.title != null)
//                 Text(
//                   widget.track!.title!,
//                   style: TextStyle(
//                     color: AppColors.textSecondary,
//                     fontSize: 12,
//                   ),
//                 ),
//             ],
//           ),
//           actions: [
//             if (_hasChanges)
//               IconButton(
//                 onPressed: _isSaving ? null : _saveLyrics,
//                 icon: _isSaving
//                     ? SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             AppColors.primaryColor,
//                           ),
//                         ),
//                       )
//                     : Icon(
//                         Icons.save,
//                         color: AppColors.primaryColor,
//                       ),
//               ),
//           ],
//         ),
//         body: Consumer<LyricsProvider>(
//           builder: (context, provider, child) {
//             if (provider.isLoading && _lyricsController.text.isEmpty) {
//               return const Center(child: LoadingWidget());
//             }

//             return Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // Quick Actions Bar
//                   _buildQuickActionsBar(),
                  
//                   // Lyrics Editor
//                   Expanded(
//                     child: _buildLyricsEditor(),
//                   ),
                  
//                   // Bottom Action Bar
//                   _buildBottomActionBar(),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActionsBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceColor,
//         border: Border(
//           bottom: BorderSide(
//             color: AppColors.textSecondary.withOpacity(0.1),
//             width: 1,
//           ),
//         ),
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: [
//             _buildQuickActionChip('Verse', 'Verse 1'),
//             const SizedBox(width: 8),
//             _buildQuickActionChip('Chorus', 'Chorus'),
//             const SizedBox(width: 8),
//             _buildQuickActionChip('Bridge', 'Bridge'),
//             const SizedBox(width: 8),
//             _buildQuickActionChip('Pre-Chorus', 'Pre-Chorus'),
//             const SizedBox(width: 8),
//             _buildQuickActionChip('Outro', 'Outro'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActionChip(String label, String sectionType) {
//     return ActionChip(
//       label: Text(
//         label,
//         style: TextStyle(
//           color: AppColors.textPrimary,
//           fontSize: 12,
//         ),
//       ),
//       onPressed: () => _insertSection(sectionType),
//       backgroundColor: AppColors.backgroundColor,
//       side: BorderSide(color: AppColors.primaryColor.withOpacity(0.3)),
//     );
//   }

//   Widget _buildLyricsEditor() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Lyrics',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Tip: Use [Section Name] to mark different parts of the song',
//             style: TextStyle(
//               fontSize: 12,
//               color: AppColors.textSecondary,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.surfaceColor,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: AppColors.textSecondary.withOpacity(0.2),
//                 ),
//               ),
//               child: TextFormField(
//                 controller: _lyricsController,
//                 maxLines: null,
//                 expands: true,
//                 textAlignVertical: TextAlignVertical.top,
//                 style: TextStyle(
//                   color: AppColors.textPrimary,
//                   fontSize: 16,
//                   height: 1.5,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: 'Enter lyrics here...\n\n[Verse 1]\nSample lyrics\n\n[Chorus]\nSample chorus',
//                   hintStyle: TextStyle(
//                     color: AppColors.textSecondary.withOpacity(0.7),
//                   ),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.all(16),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Please enter some lyrics';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomActionBar() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceColor,
//         border: Border(
//           top: BorderSide(
//             color: AppColors.textSecondary.withOpacity(0.1),
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: CustomButton(
//               text: 'Cancel',
//               onPressed: () async {
//                 if (await _onWillPop()) {
//                   context.pop();
//                 }
//               },
//               backgroundColor: AppColors.backgroundColor,
//               textColor: AppColors.textSecondary,
//               borderColor: AppColors.textSecondary.withOpacity(0.3),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: CustomButton(
//               text: _isSaving ? 'Saving...' : 'Save Changes',
//               onPressed: _isSaving ? null : _saveLyrics,
//               backgroundColor: AppColors.primaryColor,
//               textColor: Colors.white,
//               isLoading: _isSaving,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/screens/lyrics/lyrics_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/lyrics_provider.dart';
import '../../providers/track_provider.dart';
import '../../models/track_model.dart';

class LyricsEditScreen extends StatefulWidget {
  final String? trackId;
  final Track? track;
  //decide on removal
  final String? currentLyrics;

  const LyricsEditScreen({
    Key? key,
    required this.trackId,
    this.track,
    //decide on removal
    this.currentLyrics,
  }) : super(key: key);

  @override
  State<LyricsEditScreen> createState() => _LyricsEditScreenState();
}

class _LyricsEditScreenState extends State<LyricsEditScreen> {
  late TextEditingController _lyricsController;
  bool _hasChanges = false;
  bool _isSaving = false;
  Track? _selectedTrack;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _lyricsController = TextEditingController();
    _lyricsController.addListener(() {
      if (!_hasChanges) {
        setState(() => _hasChanges = true);
      }
    });
    _selectedTrack = widget.track;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedTrack != null) {
        _loadCurrentLyrics();
      } else {
        _loadTracks();
      }
    });
  }

  @override
  void dispose() {
    _lyricsController.dispose();
    super.dispose();
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
    _loadCurrentLyrics();
  }

  Future<void> _loadCurrentLyrics() async {
    final provider = context.read<LyricsProvider>();
    if (_selectedTrack?.id == null) {
       debugPrint('Track ID is null. Cannot load lyrics.');
       return;
    }
    await provider.getLyricsForTrack(_selectedTrack!.id!);
    if (provider.currentLyrics != null) {
      _lyricsController.text = provider.currentLyrics!.lyrics;
    }
  }

  Future<void> _saveLyrics() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final provider = context.read<LyricsProvider>();
      if (_selectedTrack?.id == null) {
          debugPrint('Track ID is null. Cannot save lyrics.');
       return;
       }
      await provider.editLyrics(
        _selectedTrack!.id!,
        _lyricsController.text,
      );
      
      if (mounted) {
        setState(() => _hasChanges = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Lyrics saved successfully'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save lyrics: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _insertSection(String sectionType) {
    final text = _lyricsController.text;
    final selection = _lyricsController.selection;
    final sectionLabel = '[$sectionType]\n';
    
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      sectionLabel,
    );
    
    _lyricsController.text = newText;
    _lyricsController.selection = TextSelection.collapsed(
      offset: selection.start + sectionLabel.length,
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceColor,
        title: Text(
          'Unsaved Changes',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'You have unsaved changes. Do you want to discard them?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Discard', style: TextStyle(color: AppColors.errorColor)),
          ),
        ],
      ),
    );
    
    return result ?? false;
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
                  'Upload some tracks to edit lyrics',
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
                'Select a track to edit lyrics',
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

  Widget _buildEditView() {
    return Consumer<LyricsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && _lyricsController.text.isEmpty) {
          return const Center(child: LoadingWidget());
        }

        return Form(
          key: _formKey,
          child: Column(
            children: [
              // Quick Actions Bar
              _buildQuickActionsBar(),
              
              // Lyrics Editor
              Expanded(
                child: _buildLyricsEditor(),
              ),
              
              // Bottom Action Bar
              _buildBottomActionBar(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                context.pop();
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedTrack == null ? 'Select Track' : 'Edit Lyrics',
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
                    _lyricsController.clear();
                    _hasChanges = false;
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
              // Save Button
              if (_hasChanges)
                IconButton(
                  onPressed: _isSaving ? null : _saveLyrics,
                  icon: _isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.save,
                          color: AppColors.primaryColor,
                        ),
                ),
            ],
          ],
        ),
        body: _selectedTrack == null ? _buildTrackSelectionView() : _buildEditView(),
      ),
    );
  }

  Widget _buildQuickActionsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildQuickActionChip('Verse', 'Verse 1'),
            const SizedBox(width: 8),
            _buildQuickActionChip('Chorus', 'Chorus'),
            const SizedBox(width: 8),
            _buildQuickActionChip('Bridge', 'Bridge'),
            const SizedBox(width: 8),
            _buildQuickActionChip('Pre-Chorus', 'Pre-Chorus'),
            const SizedBox(width: 8),
            _buildQuickActionChip('Outro', 'Outro'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionChip(String label, String sectionType) {
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 12,
        ),
      ),
      onPressed: () => _insertSection(sectionType),
      backgroundColor: AppColors.backgroundColor,
      side: BorderSide(color: AppColors.primaryColor.withOpacity(0.3)),
    );
  }

  Widget _buildLyricsEditor() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lyrics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tip: Use [Section Name] to mark different parts of the song',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textSecondary.withOpacity(0.2),
                ),
              ),
              child: TextFormField(
                controller: _lyricsController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter lyrics here...\n\n[Verse 1]\nSample lyrics\n\n[Chorus]\nSample chorus',
                  hintStyle: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some lyrics';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        border: Border(
          top: BorderSide(
            color: AppColors.textSecondary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Cancel',
              onPressed: () async {
                if (await _onWillPop()) {
                  context.pop();
                }
              },
              backgroundColor: AppColors.backgroundColor,
              textColor: AppColors.textSecondary,
              borderColor: AppColors.textSecondary.withOpacity(0.3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              text: _isSaving ? 'Saving...' : 'Save Changes',
              onPressed: _isSaving ? null : _saveLyrics,
              backgroundColor: AppColors.primaryColor,
              textColor: Colors.white,
              isLoading: _isSaving,
            ),
          ),
        ],
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