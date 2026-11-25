import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';

/// شاشة مؤقتة لحد ما نبني رئيسية الموظف وداشبورد المدير.
/// فيها تسجيل الخروج عشان نجرّب دورة الدخول كاملة.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.pink,
                    child: Text(user.name.characters.first,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 14),
                  Text(user.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  Text(user.job,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.mute)),
                  const SizedBox(height: 10),
                  Text(
                    user.isManager ? 'هنا هتبقى الداشبورد' : 'هنا هتبقى الرئيسية',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.olive),
                  ),
                  const SizedBox(height: 28),
                  OutlinedButton(
                    onPressed: () => context.push('/change-password'),
                    child: const Text('تغيير كلمة المرور'),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: () => context.read<AuthProvider>().logout(),
                    child: const Text('تسجيل خروج'),
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
