// // lib/core/widgets/custom_button.dart
// import 'package:flutter/material.dart';
// import '../constants/app_colors.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final bool isLoading;
//   final bool isSecondary;
//   final IconData? icon;
//   final double? width;
//   final double height;

//   const CustomButton({
//     Key? key,
//     required this.text,
//     this.onPressed,
//     this.isLoading = false,
//     this.isSecondary = false,
//     this.icon,
//     this.width,
//     this.height = 50,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width ?? double.infinity,
//       height: height,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isSecondary 
//             ? AppColors.cardColor 
//             : AppColors.primaryColor,
//           foregroundColor: isSecondary 
//             ? AppColors.textPrimary 
//             : Colors.white,
//           elevation: 2,
//           shadowColor: AppColors.primaryColor.withOpacity(0.3),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: isSecondary 
//               ? BorderSide(color: AppColors.borderColor, width: 1)
//               : BorderSide.none,
//           ),
//         ),
//         child: isLoading
//           ? SizedBox(
//               height: 20,
//               width: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   isSecondary ? AppColors.primaryColor : Colors.white,
//                 ),
//               ),
//             )
//           : Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (icon != null) ...[
//                   Icon(icon, size: 18),
//                   const SizedBox(width: 8),
//                 ],
//                 Text(
//                   text,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//       ),
//     );
//   }
// }




//**************version 2 **************//
// lib/core/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final IconData? icon;
  final double? width;
  final backgroundColor;
  final textColor;
  final borderColor;
  final double height;
  final bool isSmall;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.borderColor,
    this.backgroundColor,
    this.isLoading = false,
    this.isSecondary = false,
    this.icon,
    this.textColor,
    this.width,
    this.height = 50,
    this.isSmall = false, // ✅ default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSecondary 
        ? AppColors.cardColor 
        : AppColors.primaryColor;

    final foregroundColor = isSecondary 
        ? AppColors.textPrimary 
        : Colors.white;

    final borderSide = isSecondary 
        ? BorderSide(color: AppColors.borderColor, width: 1)
        : BorderSide.none;

    return SizedBox(
      width: width ?? double.infinity,
      height: isSmall ? 40 : height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 2,
          shadowColor: AppColors.primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderSide,
          ),
          padding: isSmall 
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
              : const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: isSmall ? 13 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
