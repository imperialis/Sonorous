// // lib/core/widgets/custom_text_field.dart
// import 'package:flutter/material.dart';
// import '../constants/app_colors.dart';

// class CustomTextField extends StatefulWidget {
//   final String label;
//   final String? labelText;
//   final String? hintText;
//   final String? hint;
//   final TextEditingController? controller;
//   final bool isPassword;
//   final bool isRequired;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;
//   final void Function(String)? onChanged;
//   final IconData? prefixIcon;
//   final Widget? suffixIcon;
//   final int maxLines;
//   final bool readOnly;

//   const CustomTextField({
//     Key? key,
//     required this.label,
//     this.hint,
//     this.controller,
//     this.hintText,
//     this.labelText,
//     this.isPassword = false,
//     this.isRequired = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//     this.onChanged,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.maxLines = 1,
//     this.readOnly = false,
//   }) : super(key: key);

//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _obscureText = true;
//   late FocusNode _focusNode;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             text: widget.label,
//             style: TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//             children: [
//               if (widget.isRequired)
//                 TextSpan(
//                   text: ' *',
//                   style: TextStyle(color: AppColors.errorColor),
//                 ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: widget.controller,
//           focusNode: _focusNode,
//           obscureText: widget.isPassword && _obscureText,
//           keyboardType: widget.keyboardType,
//           validator: widget.validator,
//           onChanged: widget.onChanged,
//           maxLines: widget.maxLines,
//           readOnly: widget.readOnly,
//           style: TextStyle(color: AppColors.textPrimary),
//           decoration: InputDecoration(
//             hintText: widget.hint,
//             labelText: labelText,
//             hintStyle: TextStyle(color: AppColors.textSecondary),
//             prefixIcon: widget.prefixIcon != null 
//               ? Icon(widget.prefixIcon, color: AppColors.textSecondary)
//               : null,
//             suffixIcon: widget.isPassword
//               ? IconButton(
//                   icon: Icon(
//                     _obscureText ? Icons.visibility_off : Icons.visibility,
//                     color: AppColors.textSecondary,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscureText = !_obscureText;
//                     });
//                   },
//                 )
//               : null,
//             filled: true,
//             fillColor: AppColors.cardColor,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: AppColors.borderColor),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: AppColors.borderColor),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: AppColors.errorColor),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 16,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// lib/core/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? labelText;
  final String? hintText;
  final String? hint;
  final TextEditingController? controller;
  final bool isPassword;
  final bool obscureText; // Added this parameter
  final bool isRequired;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool readOnly;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.obscureText = false, // Added this parameter with default
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _obscureText = widget.isPassword || widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: [
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.errorColor),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: (widget.isPassword || widget.obscureText) && _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          readOnly: widget.readOnly,
          style: TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hint ?? widget.hintText,
            labelText: widget.labelText,
            hintStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: widget.prefixIcon != null 
              ? Icon(widget.prefixIcon, color: AppColors.textSecondary)
              : null,
            suffixIcon: widget.suffixIcon ?? 
              ((widget.isPassword || widget.obscureText)
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null),
            filled: true,
            fillColor: AppColors.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.errorColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}