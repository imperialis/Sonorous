// import 'package:flutter/material.dart';
// import '../models/track_model.dart';
// import '../core/constants/app_colors.dart';
// import 'tag_chip.dart';

// class TrackCard extends StatelessWidget {
//   final Track track;
//   final VoidCallback? onTap;
//   final VoidCallback? onPlay;
//   final VoidCallback? onRemix;
//   final VoidCallback? onDownload;
//   final bool isPlaying;
//   final bool showActions;

//   const TrackCard({
//     Key? key,
//     required this.track,
//     this.onTap,
//     this.onPlay,
//     this.onRemix,
//     this.onDownload,
//     this.isPlaying = false,
//     this.showActions = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: isPlaying 
//               ? LinearGradient(
//                   colors: [
//                     AppColors.primary.withOpacity(0.1),
//                     AppColors.secondary.withOpacity(0.1),
//                   ],
//                 )
//               : null,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   // Album Art Placeholder
//                   Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       gradient: LinearGradient(
//                         colors: [AppColors.primary, AppColors.secondary],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Icon(
//                       Icons.music_note,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
                  
//                   // Track Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           track.title ?? 'Unknown Title',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           track.artist ?? 'Unknown Artist',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         if (track.duration != null)
//                           Text(
//                             _formatDuration(track.duration!),
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[500],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
                  
//                   // Play Button
//                   if (onPlay != null)
//                     IconButton(
//                       onPressed: onPlay,
//                       icon: Icon(
//                         isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
//                         size: 32,
//                         color: AppColors.primary,
//                       ),
//                     ),
//                 ],
//               ),
              
//               // Tags
//               if (track.tags != null && track.tags!.isNotEmpty) ...[
//                 const SizedBox(height: 12),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 4,
//                   children: track.tags!.take(3).map((tag) => TagChip(
//                     label: tag.name,
//                     type: tag.type,
//                     size: TagChipSize.small,
//                   )).toList(),
//                 ),
//               ],
              
//               // Action Buttons
//               if (showActions) ...[
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     if (onRemix != null)
//                       _ActionButton(
//                         icon: Icons.remix_on,
//                         label: 'Remix',
//                         onTap: onRemix!,
//                       ),
//                     _ActionButton(
//                       icon: Icons.lyrics,
//                       label: 'Lyrics',
//                       onTap: () {
//                         // Navigate to lyrics screen
//                       },
//                     ),
//                     _ActionButton(
//                       icon: Icons.analytics,
//                       label: 'Stats',
//                       onTap: () {
//                         // Show analytics
//                       },
//                     ),
//                     if (onDownload != null)
//                       _ActionButton(
//                         icon: Icons.download,
//                         label: 'Export',
//                         onTap: onDownload!,
//                       ),
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDuration(int seconds) {
//     final minutes = seconds ~/ 60;
//     final remainingSeconds = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
//   }
// }

// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   const _ActionButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(8),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               size: 20,
//               color: AppColors.primary,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/track_model.dart';
import '../core/constants/app_colors.dart';
import 'tag_chip.dart';

class TrackCard extends StatelessWidget {
  final Track track;
  final VoidCallback? onTap;
  final VoidCallback? onPlay;
  final VoidCallback? onRemix;
  final VoidCallback? onDownload;
  final VoidCallback? onMoreTap; // Add the missing parameter
  final bool isPlaying;
  final bool showActions;

  const TrackCard({
    Key? key,
    required this.track,
    this.onTap,
    this.onPlay,
    this.onRemix,
    this.onDownload,
    this.onMoreTap, // Add to constructor
    this.isPlaying = false,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isPlaying 
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                )
              : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Album Art Placeholder
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Track Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title ?? 'Unknown Title',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          track.artist ?? 'Unknown Artist',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (track.duration != null)
                          Text(
                            _formatDuration(track.duration!.toInt()),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Play Button
                  if (onPlay != null)
                    IconButton(
                      onPressed: onPlay,
                      icon: Icon(
                        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                  
                  // More Options Button
                  if (onMoreTap != null)
                    IconButton(
                      onPressed: onMoreTap,
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
              //uncomment if the backend supplies em and update the models
              // Tags
              // if (track.tags != null && track.tags!.isNotEmpty) ...[
              //   const SizedBox(height: 12),
              //   Wrap(
              //     spacing: 8,
              //     runSpacing: 4,
              //     children: track.tags!.take(3).map((tag) => TagChip(
              //       label: tag.name,
              //       type: tag.type,
              //       size: TagChipSize.small,
              //     )).toList(),
              //   ),
              // ],
              
              // Action Buttons
              if (showActions) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (onRemix != null)
                      _ActionButton(
                        icon: Icons.auto_awesome,
                        label: 'Remix',
                        onTap: onRemix!,
                      ),
                    _ActionButton(
                      icon: Icons.lyrics,
                      label: 'Lyrics',
                      onTap: () {
                        // Navigate to lyrics screen
                      },
                    ),
                    _ActionButton(
                      icon: Icons.analytics,
                      label: 'Stats',
                      onTap: () {
                        // Show analytics
                      },
                    ),
                    if (onDownload != null)
                      _ActionButton(
                        icon: Icons.download,
                        label: 'Export',
                        onTap: onDownload!,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}