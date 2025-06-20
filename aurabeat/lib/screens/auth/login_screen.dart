import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo/Title
                    const Icon(
                      Icons.music_note,
                      size: 80,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.appName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Username field
                    CustomTextField(
                      controller: _usernameController,
                      label: AppStrings.username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    CustomTextField(
                      controller: _passwordController,
                      label: AppStrings.password,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Error message
                    if (authProvider.error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Text(
                          authProvider.error!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),

                    // Login button
                    CustomButton(
                      text: AppStrings.login,
                      isLoading: authProvider.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await authProvider.login(
                            _usernameController.text,
                            _passwordController.text,
                          );
                          if (success && mounted) {
                            context.go('/home');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Register link
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text(
                        'Don\'t have an account? Register',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// //*************version 2 *//
// // lib/screens/auth/login_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
// import '../../core/widgets/custom_button.dart';
// import '../../core/widgets/custom_text_field.dart';
// import '../../core/constants/app_colors.dart';
// import '../../core/constants/app_strings.dart';
// import '../../providers/auth_provider.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       final authProvider = context.read<AuthProvider>();
//       final success = await authProvider.login(
//         _usernameController.text.trim(),
//         _passwordController.text,
//       );
      
//       if (success && mounted) {
//         context.go('/home');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Logo/Title
//                 Icon(
//                   Icons.music_note,
//                   size: 80,
//                   color: AppColors.primaryColor,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   AppStrings.appName,
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Welcome back to your music studio',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: AppColors.textSecondary,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 48),

//                 // Username Field
//                 CustomTextField(
//                   label: 'Username',
//                   controller: _usernameController,
//                   isRequired: true,
//                   prefixIcon: Icons.person_outline,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Username is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // Password Field
//                 CustomTextField(
//                   label: 'Password',
//                   controller: _passwordController,
//                   isPassword: true,
//                   isRequired: true,
//                   prefixIcon: Icons.lock_outline,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Password is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 32),

//                 // Login Button
//                 Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) {
//                     return CustomButton(
//                       text: 'Sign In',
//                       onPressed: authProvider.isLoading ? null : _login,
//                       isLoading: authProvider.isLoading,
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // Register Link
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Don't have an account? ",
//                       style: TextStyle(color: AppColors.textSecondary),
//                     ),
//                     TextButton(
//                       onPressed: () => context.push('/register'),
//                       child: Text(
//                         'Sign Up',
//                         style: TextStyle(
//                           color: AppColors.primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // Error Message
//                 Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) {
//                     if (authProvider.error != null) {
//                       return Container(
//                         margin: const EdgeInsets.only(top: 16),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: AppColors.errorColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: AppColors.errorColor.withOpacity(0.3),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.error_outline,
//                               color: AppColors.errorColor,
//                               size: 20,
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 authProvider.error!,
//                                 style: TextStyle(
//                                   color: AppColors.errorColor,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }