// // // lib/screens/upload/upload_screen.dart
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:go_router/go_router.dart';
// // import '../../core/constants/app_colors.dart';
// // import '../../core/widgets/custom_button.dart';
// // import '../../core/widgets/loading_widget.dart';
// // import '../../providers/track_provider.dart';
// // import '../../services/upload_service.dart';

// // class UploadScreen extends StatefulWidget {
// //   const UploadScreen({Key? key}) : super(key: key);

// //   @override
// //   State<UploadScreen> createState() => _UploadScreenState();
// // }

// // class _UploadScreenState extends State<UploadScreen> {
// //   File? _selectedFile;
// //   bool _isUploading = false;
// //   double _uploadProgress = 0.0;
// //   String? _errorMessage;

// //   final List<String> _supportedFormats = [
// //     'mp3', 'wav', 'flac', 'm4a', 'aac', 'ogg'
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.backgroundColor,
// //       appBar: AppBar(
// //         backgroundColor: AppColors.surfaceColor,
// //         elevation: 0,
// //         leading: IconButton(
// //           onPressed: () => context.pop(),
// //           icon: Icon(
// //             Icons.arrow_back,
// //             color: AppColors.textPrimary,
// //           ),
// //         ),
// //         title: Text(
// //           'Upload Track',
// //           style: TextStyle(
// //             color: AppColors.textPrimary,
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(24),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             // Upload Area
// //             GestureDetector(
// //               onTap: _isUploading ? null : _pickFile,
// //               child: Container(
// //                 height: 200,
// //                 decoration: BoxDecoration(
// //                   color: AppColors.surfaceColor,
// //                   borderRadius: BorderRadius.circular(16),
// //                   border: Border.all(
// //                     color: _selectedFile != null 
// //                         ? AppColors.primaryColor
// //                         : AppColors.textSecondary.withOpacity(0.3),
// //                     width: 2,
// //                     style: BorderStyle.solid,
// //                   ),
// //                 ),
// //                 child: _buildUploadContent(),
// //               ),
// //             ),
            
// //             const SizedBox(height: 24),

// //             // File Info
// //             if (_selectedFile != null) _buildFileInfo(),

// //             // Supported Formats
// //             _buildSupportedFormats(),

// //             const SizedBox(height: 32),

// //             // Upload Progress
// //             if (_isUploading) _buildUploadProgress(),

// //             // Error Message
// //             if (_errorMessage != null) _buildErrorMessage(),

// //             const SizedBox(height: 24),

// //             // Upload Button
// //             CustomButton(
// //               text: _isUploading ? 'Uploading...' : 'Upload Track',
// //               onPressed: _selectedFile != null && !_isUploading ? _uploadFile : null,
// //               isLoading: _isUploading,
// //             ),

// //             const SizedBox(height: 16),

// //             // Tips
// //             _buildTips(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildUploadContent() {
// //     if (_isUploading) {
// //       return const Center(
// //         child: LoadingWidget(),
// //       );
// //     }

// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(
// //             _selectedFile != null ? Icons.audio_file : Icons.cloud_upload_outlined,
// //             size: 64,
// //             color: _selectedFile != null 
// //                 ? AppColors.primaryColor 
// //                 : AppColors.textSecondary.withOpacity(0.5),
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             _selectedFile != null 
// //                 ? 'File Selected'
// //                 : 'Tap to select audio file',
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.w600,
// //               color: _selectedFile != null 
// //                   ? AppColors.primaryColor 
// //                   : AppColors.textSecondary,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             _selectedFile != null 
// //                 ? _selectedFile!.path.split('/').last
// //                 : 'Choose an audio file to upload',
// //             style: TextStyle(
// //               color: AppColors.textSecondary.withOpacity(0.7),
// //               fontSize: 14,
// //             ),
// //             textAlign: TextAlign.center,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFileInfo() {
// //     final fileSize = _selectedFile!.lengthSync();
// //     final fileSizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(2);
    
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: AppColors.surfaceColor,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'File Information',
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.w600,
// //               color: AppColors.textPrimary,
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           _buildInfoRow('Name', _selectedFile!.path.split('/').last),
// //           _buildInfoRow('Size', '$fileSizeMB MB'),
// //           _buildInfoRow('Format', _selectedFile!.path.split('.').last.toUpperCase()),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildInfoRow(String label, String value) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Row(
// //         children: [
// //           SizedBox(
// //             width: 80,
// //             child: Text(
// //               '$label:',
// //               style: TextStyle(
// //                 color: AppColors.textSecondary,
// //                 fontSize: 14,
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: Text(
// //               value,
// //               style: TextStyle(
// //                 color: AppColors.textPrimary,
// //                 fontSize: 14,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSupportedFormats() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: AppColors.surfaceColor.withOpacity(0.5),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'Supported Formats',
// //             style: TextStyle(
// //               fontSize: 14,
// //               fontWeight: FontWeight.w600,
// //               color: AppColors.textSecondary,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Wrap(
// //             spacing: 8,
// //             runSpacing: 4,
// //             children: _supportedFormats.map((format) => Chip(
// //               label: Text(
// //                 format.toUpperCase(),
// //                 style: const TextStyle(fontSize: 12),
// //               ),
// //               backgroundColor: AppColors.primaryColor.withOpacity(0.1),
// //               labelStyle: TextStyle(color: AppColors.primaryColor),
// //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //             )).toList(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildUploadProgress() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: AppColors.surfaceColor,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(
// //                 'Uploading...',
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.w600,
// //                   color: AppColors.textPrimary,
// //                 ),
// //               ),
// //               Text(
// //                 '${(_uploadProgress * 100).toInt()}%',
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.w600,
// //                   color: AppColors.primaryColor,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           LinearProgressIndicator(
// //             value: _uploadProgress,
// //             backgroundColor: AppColors.textSecondary.withOpacity(0.2),
// //             valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildErrorMessage() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: AppColors.errorColor.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(
// //           color: AppColors.errorColor.withOpacity(0.3),
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(
// //             Icons.error_outline,
// //             color: AppColors.errorColor,
// //             size: 20,
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Text(
// //               _errorMessage!,
// //               style: TextStyle(
// //                 color: AppColors.errorColor,
// //                 fontSize: 14,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTips() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: AppColors.accentColor.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(
// //                 Icons.tips_and_updates,
// //                 color: AppColors.accentColor,
// //                 size: 20,
// //               ),
// //               const SizedBox(width: 8),
// //               Text(
// //                 'Tips for best results',
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.w600,
// //                   color: AppColors.accentColor,
// //                   fontSize: 14,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 12),
// //           _buildTipItem('Use high-quality audio files (320kbps or higher)'),
// //           _buildTipItem('Ensure your file is under 50MB for faster processing'),
// //           _buildTipItem('Choose clear audio without excessive noise'),
// //           _buildTipItem('Supported formats work best for AI processing'),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildTipItem(String tip) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 2),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             width: 4,
// //             height: 4,
// //             margin: const EdgeInsets.only(top: 8, right: 8),
// //             decoration: BoxDecoration(
// //               color: AppColors.accentColor,
// //               shape: BoxShape.circle,
// //             ),
// //           ),
// //           Expanded(
// //             child: Text(
// //               tip,
// //               style: TextStyle(
// //                 color: AppColors.textSecondary,
// //                 fontSize: 12,
// //                 height: 1.4,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _pickFile() async {
// //     try {
// //       FilePickerResult? result = await FilePicker.platform.pickFiles(
// //         type: FileType.custom,
// //         allowedExtensions: _supportedFormats,
// //         allowMultiple: false,
// //       );

// //       if (result != null && result.files.single.path != null) {
// //         setState(() {
// //           _selectedFile = File(result.files.single.path!);
// //           _errorMessage = null;
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         _errorMessage = 'Error selecting file: ${e.toString()}';
// //       });
// //     }
// //   }

// //   Future<void> _uploadFile() async {
// //     if (_selectedFile == null) return;

// //     setState(() {
// //       _isUploading = true;
// //       _uploadProgress = 0.0;
// //       _errorMessage = null;
// //     });

// //     try {
// //       final uploadService = UploadService();
      
// //       // Simulate upload progress
// //       for (int i = 0; i <= 100; i += 10) {
// //         await Future.delayed(const Duration(milliseconds: 200));
// //         setState(() {
// //           _uploadProgress = i / 100;
// //         });
// //       }

// //       final success = await uploadService.uploadAudioFile(_selectedFile!);
      
// //       if (success !=null) {
// //         // Refresh tracks list
// //         if (mounted) {
// //           context.read<TrackProvider>().loadTracks();
          
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: const Text('Track uploaded successfully!'),
// //               backgroundColor: AppColors.primaryColor,
// //               action: SnackBarAction(
// //                 label: 'View',
// //                 textColor: Colors.white,
// //                 onPressed: () => context.go('/home'),
// //               ),
// //             ),
// //           );
          
// //           context.pop();
// //         }
// //       }
// //     } catch (e) {
// //       setState(() {
// //         _errorMessage = 'Upload failed: ${e.toString()}';
// //       });
// //     } finally {
// //       setState(() {
// //         _isUploading = false;
// //         _uploadProgress = 0.0;
// //       });
// //     }
// //   }
// // }

// //****version 2 ****//
// // lib/screens/upload/upload_screen.dart
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:go_router/go_router.dart';
// import '../../core/constants/app_colors.dart';
// import '../../core/widgets/custom_button.dart';
// import '../../core/widgets/loading_widget.dart';
// import '../../providers/track_provider.dart';
// import '../../services/upload_service.dart';

// class UploadScreen extends StatefulWidget {
//   const UploadScreen({Key? key}) : super(key: key);

//   @override
//   State<UploadScreen> createState() => _UploadScreenState();
// }

// class _UploadScreenState extends State<UploadScreen> {
//   File? _selectedFile;
//   PlatformFile? _selectedWebFile;
//   Uint8List? _webFileBytes;
//   bool _isUploading = false;
//   double _uploadProgress = 0.0;
//   String? _errorMessage;

//   final List<String> _supportedFormats = [
//     'mp3', 'wav', 'flac', 'm4a', 'aac', 'ogg'
//   ];

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
//         title: Text(
//           'Upload Track',
//           style: TextStyle(
//             color: AppColors.textPrimary,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Upload Area
//             GestureDetector(
//               onTap: _isUploading ? null : _pickFile,
//               child: Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: AppColors.surfaceColor,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: _hasSelectedFile() 
//                         ? AppColors.primaryColor
//                         : AppColors.textSecondary.withOpacity(0.3),
//                     width: 2,
//                     style: BorderStyle.solid,
//                   ),
//                 ),
//                 child: _buildUploadContent(),
//               ),
//             ),
            
//             const SizedBox(height: 24),

//             // File Info
//             if (_hasSelectedFile()) _buildFileInfo(),

//             // Supported Formats
//             _buildSupportedFormats(),

//             const SizedBox(height: 32),

//             // Upload Progress
//             if (_isUploading) _buildUploadProgress(),

//             // Error Message
//             if (_errorMessage != null) _buildErrorMessage(),

//             const SizedBox(height: 24),

//             // Upload Button
//             CustomButton(
//               text: _isUploading ? 'Uploading...' : 'Upload Track',
//               onPressed: _hasSelectedFile() && !_isUploading ? _uploadFile : null,
//               isLoading: _isUploading,
//             ),

//             const SizedBox(height: 16),

//             // Tips
//             _buildTips(),
//           ],
//         ),
//       ),
//     );
//   }

//   bool _hasSelectedFile() {
//     return kIsWeb ? _selectedWebFile != null : _selectedFile != null;
//   }

//   String _getFileName() {
//     if (kIsWeb) {
//       return _selectedWebFile?.name ?? '';
//     } else {
//       return _selectedFile?.path.split('/').last ?? '';
//     }
//   }

//   String _getFileExtension() {
//     final fileName = _getFileName();
//     return fileName.split('.').last.toUpperCase();
//   }

//   int _getFileSize() {
//     if (kIsWeb) {
//       return _selectedWebFile?.size ?? 0;
//     } else {
//       return _selectedFile?.lengthSync() ?? 0;
//     }
//   }

//   Widget _buildUploadContent() {
//     if (_isUploading) {
//       return const Center(
//         child: LoadingWidget(),
//       );
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             _hasSelectedFile() ? Icons.audio_file : Icons.cloud_upload_outlined,
//             size: 64,
//             color: _hasSelectedFile() 
//                 ? AppColors.primaryColor 
//                 : AppColors.textSecondary.withOpacity(0.5),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _hasSelectedFile() 
//                 ? 'File Selected'
//                 : 'Tap to select audio file',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: _hasSelectedFile() 
//                   ? AppColors.primaryColor 
//                   : AppColors.textSecondary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _hasSelectedFile() 
//                 ? _getFileName()
//                 : 'Choose an audio file to upload',
//             style: TextStyle(
//               color: AppColors.textSecondary.withOpacity(0.7),
//               fontSize: 14,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFileInfo() {
//     final fileSize = _getFileSize();
//     final fileSizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(2);
    
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'File Information',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _buildInfoRow('Name', _getFileName()),
//           _buildInfoRow('Size', '$fileSizeMB MB'),
//           _buildInfoRow('Format', _getFileExtension()),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 color: AppColors.textSecondary,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: AppColors.textPrimary,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSupportedFormats() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceColor.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Supported Formats',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textSecondary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 8,
//             runSpacing: 4,
//             children: _supportedFormats.map((format) => Chip(
//               label: Text(
//                 format.toUpperCase(),
//                 style: const TextStyle(fontSize: 12),
//               ),
//               backgroundColor: AppColors.primaryColor.withOpacity(0.1),
//               labelStyle: TextStyle(color: AppColors.primaryColor),
//               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             )).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUploadProgress() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Uploading...',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               Text(
//                 '${(_uploadProgress * 100).toInt()}%',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: _uploadProgress,
//             backgroundColor: AppColors.textSecondary.withOpacity(0.2),
//             valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorMessage() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.errorColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: AppColors.errorColor.withOpacity(0.3),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.error_outline,
//             color: AppColors.errorColor,
//             size: 20,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               _errorMessage!,
//               style: TextStyle(
//                 color: AppColors.errorColor,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTips() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.accentColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.tips_and_updates,
//                 color: AppColors.accentColor,
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Tips for best results',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.accentColor,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildTipItem('Use high-quality audio files (320kbps or higher)'),
//           _buildTipItem('Ensure your file is under 50MB for faster processing'),
//           _buildTipItem('Choose clear audio without excessive noise'),
//           _buildTipItem('Supported formats work best for AI processing'),
//         ],
//       ),
//     );
//   }

//   Widget _buildTipItem(String tip) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 4,
//             height: 4,
//             margin: const EdgeInsets.only(top: 8, right: 8),
//             decoration: BoxDecoration(
//               color: AppColors.accentColor,
//               shape: BoxShape.circle,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               tip,
//               style: TextStyle(
//                 color: AppColors.textSecondary,
//                 fontSize: 12,
//                 height: 1.4,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: _supportedFormats,
//         allowMultiple: false,
//         withData: kIsWeb, // Load file data for web
//       );

//       if (result != null && result.files.single.path != null || 
//           (kIsWeb && result!.files.single.bytes != null)) {
//         setState(() {
//           if (kIsWeb) {
//             _selectedWebFile = result.files.single;
//             _webFileBytes = result.files.single.bytes;
//           } else {
//             _selectedFile = File(result.files.single.path!);
//           }
//           _errorMessage = null;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error selecting file: ${e.toString()}';
//       });
//     }
//   }

//   Future<void> _uploadFile() async {
//     if (!_hasSelectedFile()) return;

//     setState(() {
//       _isUploading = true;
//       _uploadProgress = 0.0;
//       _errorMessage = null;
//     });

//     try {
//       final trackProvider = context.read<TrackProvider>();
      
//       // Simulate upload progress
//       for (int i = 0; i <= 100; i += 10) {
//         await Future.delayed(const Duration(milliseconds: 200));
//         if (mounted) {
//           setState(() {
//             _uploadProgress = i / 100;
//           });
//         }
//       }

//       // Use TrackProvider's uploadTrack method for consistency
//       if (kIsWeb) {
//         // For web, you'll need to modify TrackProvider.uploadTrack to handle web files
//         // or create a separate method for web uploads
//         await _uploadWebFile(trackProvider);
//       } else {
//         await trackProvider.uploadTrack(_selectedFile!);
//       }
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Track uploaded successfully!'),
//             backgroundColor: AppColors.primaryColor,
//             action: SnackBarAction(
//               label: 'View',
//               textColor: Colors.white,
//               onPressed: () => context.go('/home'),
//             ),
//           ),
//         );
        
//         context.pop();
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorMessage = 'Upload failed: ${e.toString()}';
//         });
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isUploading = false;
//           _uploadProgress = 0.0;
//         });
//       }
//     }
//   }

//  // In your upload screen's _uploadFile method
// Future<void> _uploadFile() async {
//   if (!_hasSelectedFile()) return;

//   final uploadService = UploadService();
  
//   // Validate file first
//   final validation = uploadService.validateFile(
//     file: _selectedFile,
//     fileBytes: _webFileBytes,
//     fileName: _getFileName(),
//   );
  
//   if (!validation.isValid) {
//     setState(() {
//       _errorMessage = validation.error;
//     });
//     return;
//   }

//   setState(() {
//     _isUploading = true;
//     _uploadProgress = 0.0;
//     _errorMessage = null;
//   });

//   try {
//     // Use the universal upload method with progress
//     final response = await uploadService.uploadWithProgress(
//       file: _selectedFile,
//       fileBytes: _webFileBytes,
//       fileName: _getFileName(),
//       onProgress: (sent, total) {
//         if (mounted) {
//           setState(() {
//             _uploadProgress = sent / total;
//           });
//         }
//       },
//     );
    
//     // Handle successful upload
//     if (mounted) {
//       context.read<TrackProvider>().addTrack(response.track);
//       // Show success message and navigate
//     }
//   } catch (e) {
//     if (mounted) {
//       setState(() {
//         _errorMessage = 'Upload failed: ${e.toString()}';
//       });
//     }
//   } finally {
//     if (mounted) {
//       setState(() {
//         _isUploading = false;
//         _uploadProgress = 0.0;
//       });
//     }
//   }
// }

// ***** version 3 *****//
// lib/screens/upload/upload_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/loading_widget.dart';
import '../../providers/track_provider.dart';
import '../../services/upload_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;
  PlatformFile? _selectedWebFile;
  Uint8List? _webFileBytes;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _errorMessage;

  final List<String> _supportedFormats = [
    'mp3', 'wav', 'flac', 'm4a', 'aac', 'ogg'
  ];

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
        title: Text(
          'Upload Track',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Upload Area
            GestureDetector(
              onTap: _isUploading ? null : _pickFile,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hasSelectedFile() 
                        ? AppColors.primaryColor
                        : AppColors.textSecondary.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _buildUploadContent(),
              ),
            ),
            
            const SizedBox(height: 24),

            // File Info
            if (_hasSelectedFile()) _buildFileInfo(),

            // Supported Formats
            _buildSupportedFormats(),

            const SizedBox(height: 32),

            // Upload Progress
            if (_isUploading) _buildUploadProgress(),

            // Error Message
            if (_errorMessage != null) _buildErrorMessage(),

            const SizedBox(height: 24),

            // Upload Button
            CustomButton(
              text: _isUploading ? 'Uploading...' : 'Upload Track',
              onPressed: _hasSelectedFile() && !_isUploading ? _uploadFile : null,
              isLoading: _isUploading,
            ),

            const SizedBox(height: 16),

            // Tips
            _buildTips(),
          ],
        ),
      ),
    );
  }

  bool _hasSelectedFile() {
    return kIsWeb ? _selectedWebFile != null : _selectedFile != null;
  }

  String _getFileName() {
    if (kIsWeb) {
      return _selectedWebFile?.name ?? '';
    } else {
      return _selectedFile?.path.split('/').last ?? '';
    }
  }

  String _getFileExtension() {
    final fileName = _getFileName();
    return fileName.split('.').last.toUpperCase();
  }

  // int _getFileSize() {
  //   if (kIsWeb) {
  //     return _selectedWebFile?.size ?? 0;
  //   } else {
  //     return _selectedFile?.lengthSync() ?? 0;
  //   }
  // }
  int _getFileSize() {
  if (kIsWeb) {
    return _selectedWebFile?.size ?? 0;
  } else {
    try {
      return _selectedFile?.lengthSync() ?? 0;
    } catch (e) {
      return 0;
    }
  }
  }


  Widget _buildUploadContent() {
    if (_isUploading) {
      return const Center(
        child: LoadingWidget(),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _hasSelectedFile() ? Icons.audio_file : Icons.cloud_upload_outlined,
            size: 64,
            color: _hasSelectedFile() 
                ? AppColors.primaryColor 
                : AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _hasSelectedFile() 
                ? 'File Selected'
                : 'Tap to select audio file',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _hasSelectedFile() 
                  ? AppColors.primaryColor 
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _hasSelectedFile() 
                ? _getFileName()
                : 'Choose an audio file to upload',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFileInfo() {
    final fileSize = _getFileSize();
    final fileSizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(2);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'File Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Name', _getFileName()),
          _buildInfoRow('Size', '$fileSizeMB MB'),
          _buildInfoRow('Format', _getFileExtension()),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportedFormats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supported Formats',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _supportedFormats.map((format) => Chip(
              label: Text(
                format.toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              labelStyle: TextStyle(color: AppColors.primaryColor),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Uploading...',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(_uploadProgress * 100).toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _uploadProgress,
            backgroundColor: AppColors.textSecondary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.errorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.errorColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: AppColors.errorColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates,
                color: AppColors.accentColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Tips for best results',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipItem('Use high-quality audio files (320kbps or higher)'),
          _buildTipItem('Ensure your file is under 50MB for faster processing'),
          _buildTipItem('Choose clear audio without excessive noise'),
          _buildTipItem('Supported formats work best for AI processing'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 8),
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _pickFile() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: _supportedFormats,
  //       allowMultiple: false,
  //       withData: kIsWeb, // Load file data for web
  //     );

  //     if (result != null && result.files.single.path != null || 
  //         (kIsWeb && result!.files.single.bytes != null)) {
  //       setState(() {
  //         if (kIsWeb) {
  //           _selectedWebFile = result.files.single;
  //           _webFileBytes = result.files.single.bytes;
  //         } else {
  //           _selectedFile = File(result.files.single.path!);
  //         }
  //         _errorMessage = null;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'Error selecting file: ${e.toString()}';
  //     });
  //   }
  // }

  Future<void> _pickFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _supportedFormats,
      allowMultiple: false,
      withData: kIsWeb,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      
      if (kIsWeb) {
        if (file.bytes != null) {
          setState(() {
            _selectedWebFile = file;
            _webFileBytes = file.bytes;
            _errorMessage = null;
          });
        }
      } else {
        if (file.path != null) {
          setState(() {
            _selectedFile = File(file.path!);
            _errorMessage = null;
          });
        }
      }
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'Error selecting file: ${e.toString()}';
    });
  }
  }



  Future<void> _uploadFile() async {
  final fileName = _getFileName();
  final uploadService = UploadService();

  setState(() {
    _isUploading = true;
    _uploadProgress = 0.0;
    _errorMessage = null;
  });

  // Validate file
  final validation = uploadService.validateFile(
    file: _selectedFile,
    fileBytes: _webFileBytes,
    fileName: fileName,
  );

  if (!validation.isValid) {
    setState(() {
      _isUploading = false;
      _errorMessage = validation.error;
    });
    return;
  }

  try {
    final response = await uploadService.uploadWithProgress(
      file: _selectedFile,
      fileBytes: _webFileBytes,
      fileName: fileName,
      onProgress: (sent, total) {
        setState(() {
          _uploadProgress = total > 0 ? sent / total : 0.0;
        });
      },
    );

    // Success handling (you can change this as needed)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Upload successful!')),
    );

    // Optionally clear selected file
    setState(() {
      _selectedFile = null;
      _selectedWebFile = null;
      _webFileBytes = null;
    });

  } catch (e) {
    setState(() {
      _errorMessage = 'Upload failed: ${e.toString()}';
    });
  } finally {
    setState(() {
      _isUploading = false;
    });
  }
}


}
  