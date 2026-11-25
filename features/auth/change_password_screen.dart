import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../services/data_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();
  bool _hide = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final a = _p1.text;
    final b = _p2.text;
    if (a.length < 8) {
      setState(() => _error = 'كلمة المرور أقل من ٨ حروف.');
      return;
    }
    if (a != b) {
      setState(() => _error = 'كلمتين المرور مش متطابقين.');
      return;
    }
    if (a == DataService.defaultPassword) {
      setState(() => _error = 'اختار كلمة مرور غير المبدئية.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = context.read<AuthProvider>();
    await auth.changePassword(a);
    if (!mounted) return;
    context.go(auth.user!.isManager ? '/manager' : '/employee');
  }

  @override
  Widget build(BuildContext context) {
    final forced = context.read<AuthProvider>().user?.mustChangePassword ?? false;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('غيّر كلمة المرور',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text(
                    'عشان حسابك يبقى بتاعك لوحدك. استخدم ٨ حروف أو أكتر.',
                    style: TextStyle(color: AppColors.mute, height: 1.6),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: _p1,
                    obscureText: _hide,
                    textDirection: TextDirection.ltr,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور الجديدة',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hide ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.mute,
                        ),
                        onPressed: () => setState(() => _hide = !_hide),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _p2,
                    obscureText: _hide,
                    textDirection: TextDirection.ltr,
                    onSubmitted: (_) => _save(),
                    decoration: const InputDecoration(labelText: 'تأكيد كلمة المرور'),
                  ),
                  SizedBox(
                    height: 38,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(_error ?? '',
                          style: const TextStyle(color: AppColors.error, fontSize: 13.5)),
                    ),
                  ),
                  FilledButton(
                    onPressed: _busy ? null : _save,
                    child: const Text('حفظ وكمّل'),
                  ),
                  if (!forced) ...[
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('رجوع'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
