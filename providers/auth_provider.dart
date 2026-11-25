import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/data_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._ds) {
    _user = _ds.currentUser;
  }

  final DataService _ds;
  AppUser? _user;
  AppUser? get user => _user;

  /// بيرجّع رسالة خطأ، أو null لو الدخول نجح.
  Future<String?> login(String username, String password, UserRole role) async {
    final u = _ds.verify(username, password);
    if (u == null) return 'اسم المستخدم أو كلمة المرور غلط.';
    if (u.role != role) {
      return u.isManager
          ? 'الحساب ده حساب مدير. غيّر نوع الدخول من فوق.'
          : 'الحساب ده حساب موظف. غيّر نوع الدخول من فوق.';
    }
    await _ds.setSession(u.id);
    _user = u;
    notifyListeners();
    return null;
  }

  Future<void> changePassword(String newPassword) async {
    final current = _user;
    if (current == null) return;
    await _ds.changePassword(current.id, newPassword);
    _user = _ds.findById(current.id);
    notifyListeners();
  }

  Future<void> logout() async {
    await _ds.clearSession();
    _user = null;
    notifyListeners();
  }
}
