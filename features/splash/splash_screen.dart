import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/cat_logo.dart';
import '../../core/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  late final Animation<double> _curve = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) context.go('/login');
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _curve,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1).animate(_curve),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CatLogo(size: 110, head: AppColors.cream, face: AppColors.ink),
                  const SizedBox(height: 22),
                  const Text(
                    'درب',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'تابع خط سير فريقك بهدوء',
                    style: TextStyle(color: AppColors.sage, fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.pink),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
