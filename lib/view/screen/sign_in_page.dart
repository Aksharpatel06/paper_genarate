import 'package:paper_genarate_app/view/screen/category_page.dart';

import '../../controller/auth_provider.dart';
import '../../utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleAuthPage extends StatefulWidget {
  const GoogleAuthPage({super.key});

  @override
  State<GoogleAuthPage> createState() => _GoogleAuthPageState();
}

class _GoogleAuthPageState extends State<GoogleAuthPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.signInWithGoogle();

    if (authProvider.isAuthenticated && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: const Text('Google Sign-In successful!'), backgroundColor: CustomColors.blueColor));

      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
      // Navigate to home page or next screen
      // Navigator.pushReplacementNamed(context, '/home');
    } else if (authProvider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign-In failed: ${authProvider.error}'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CustomColors.blueColor, CustomColors.blueColor.withOpacity(0.8)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(shape: BoxShape.circle, color: CustomColors.orangeColor.withOpacity(0.1)),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(shape: BoxShape.circle, color: CustomColors.whiteColor.withOpacity(0.05)),
              ),
            ),

            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // Welcome text
                        Text(
                          'Welcome Back',
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: CustomColors.whiteColor, letterSpacing: -0.5),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Sign in to continue',
                          style: TextStyle(fontSize: 16, color: CustomColors.whiteColor.withOpacity(0.8), fontWeight: FontWeight.w400),
                        ),

                        const SizedBox(height: 60),

                        // Auth card
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: CustomColors.whiteColor,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 15))],
                          ),
                          child: Column(
                            children: [
                              // Google Sign-In Button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: authProvider.isLoading ? null : _handleGoogleSignIn,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color: CustomColors.whiteColor,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                                    ),
                                    child: authProvider.isLoading
                                        ? Center(
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                valueColor: AlwaysStoppedAnimation<Color>(CustomColors.blueColor),
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.network('https://www.google.com/favicon.ico', width: 24, height: 24),
                                              const SizedBox(width: 12),
                                              const Text(
                                                'Continue with Google',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Divider
                              Row(
                                children: [
                                  Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Email sign-in option
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: const Text('Email sign-in coming soon!'), backgroundColor: CustomColors.orangeColor),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [CustomColors.orangeColor, CustomColors.orangeColor.withOpacity(0.8)]),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(color: CustomColors.orangeColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.email_outlined, color: Colors.white, size: 22),
                                        SizedBox(width: 12),
                                        Text(
                                          'Sign in with Email',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Terms and privacy
                        Text(
                          'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: CustomColors.whiteColor.withOpacity(0.7), height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
