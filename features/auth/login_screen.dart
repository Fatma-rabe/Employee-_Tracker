import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/cat_logo.dart';
import '../../core/theme.dart';
import '../../models/app_user.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  UserRole _role = UserRole.employee;
  bool _hide = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_user.text.trim().isEmpty || _pass.text.isEmpty) {
      setState(() => _error = 'اكتب اسم المستخدم وكلمة المرور.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final err = await context.read<AuthProvider>().login(_user.text, _pass.text, _role);
    if (!mounted) return; // لو نجح، الراوتر نقلنا للصفحة التانية
    setState(() {
      _busy = false;
      _error = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isManager = _role == UserRole.manager;
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
                  const Center(child: CatLogo(size: 64)),
                  const SizedBox(height: 16),
                  Text(
                    isManager ? 'دخول المدير' : 'أهلاً بيك',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'سجّل دخولك بالبيانات اللي وصلتك من الشركة',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.mute),
                  ),
                  const SizedBox(height: 22),
                  _RoleSwitch(
                    role: _role,
                    onChanged: (r) => setState(() {
                      _role = r;
                      _error = null;
                    }),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _user,
                    textDirection: TextDirection.ltr,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    decoration: const InputDecoration(labelText: 'اسم المستخدم'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _pass,
                    obscureText: _hide,
                    textDirection: TextDirection.ltr,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      suffixIcon: IconButton(
                        tooltip: _hide ? 'إظهار' : 'إخفاء',
                        icon: Icon(
                          _hide ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.mute,
                        ),
                        onPressed: () => setState(() => _hide = !_hide),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'أول مرة؟ كلمة المرور المبدئية هي اللي بعتتها الشركة، وهتغيّرها في الخطوة الجاية.',
                    style: TextStyle(color: AppColors.mute, fontSize: 13, height: 1.6),
                  ),
                  SizedBox(
                    height: 34,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(_error ?? '',
                          style: const TextStyle(color: AppColors.error, fontSize: 13.5)),
                    ),
                  ),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.cream),
                          )
                        : const Text('دخول'),
                  ),
                  const SizedBox(height: 22),
                  // حسابات تجريبية: امسحي الكارت ده قبل التسليم النهائي
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.sageLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'حسابات تجريبية:\n'
                      'موظف: ahmed.samir\n'
                      'مدير: heba.adel\n'
                      'كلمة المرور المبدئية: Welcome@123',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 12.5, height: 1.7, color: Color(0xFF4D5236)),
                    ),
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

class _RoleSwitch extends StatelessWidget {
  const _RoleSwitch({required this.role, required this.onChanged});
  final UserRole role;
  final ValueChanged<UserRole> onChanged;

  Widget _tab(String label, UserRole r) {
    final on = role == r;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: on ? AppColors.ink : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: on ? AppColors.cream : AppColors.mute,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.paper,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(children: [
        _tab('موظف', UserRole.employee),
        _tab('مدير', UserRole.manager),
      ]),
    );
  }
}
