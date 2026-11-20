import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';


class DataService {
  DataService._(this._p);
  final SharedPreferences _p;

  static const defaultPassword = 'Welcome@123';
  static const _usersKey = 'darb_users_v1';
  static const _sessionKey = 'darb_session_v1';

  static Future<DataService> create() async {
    final ds = DataService._(await SharedPreferences.getInstance());
    if (!ds._p.containsKey(_usersKey)) await ds._seed();
    return ds;
  }

  static String hash(String username, String password) =>
      sha256.convert(utf8.encode('${username.toLowerCase()}::$password')).toString();

  static AppUser _mk(String id, String username, String name, String job, UserRole role) =>
      AppUser(
        id: id,
        username: username,
        name: name,
        job: job,
        role: role,
        passwordHash: hash(username, defaultPassword),
        mustChangePassword: true,
      );

  Future<void> _seed() => _save([
        _mk('u0', 'heba.adel', 'هبة عادل', 'مديرة العمليات', UserRole.manager),
        _mk('u1', 'ahmed.samir', 'أحمد سمير', 'مندوب مبيعات', UserRole.employee),
        _mk('u2', 'mona.khaled', 'منى خالد', 'فنية صيانة', UserRole.employee),
        _mk('u3', 'mahmoud.adel', 'محمود عادل', 'سائق توصيل', UserRole.employee),
        _mk('u4', 'yasmin.tarek', 'ياسمين طارق', 'مندوبة تحصيل', UserRole.employee),
      ]);

  Future<void> _save(List<AppUser> users) =>
      _p.setString(_usersKey, jsonEncode(users.map((u) => u.toJson()).toList()));

  List<AppUser> get users {
    final raw = _p.getString(_usersKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  AppUser? findById(String id) {
    for (final u in users) {
      if (u.id == id) return u;
    }
    return null;
  }


  AppUser? verify(String username, String password) {
    final name = username.trim().toLowerCase();
    for (final u in users) {
      if (u.username == name && u.passwordHash == hash(name, password)) return u;
    }
    return null;
  }

  Future<void> changePassword(String id, String newPassword) => _save(users
      .map((u) => u.id == id
          ? u.copyWith(passwordHash: hash(u.username, newPassword), mustChangePassword: false)
          : u)
      .toList());


  AppUser? get currentUser {
    final id = _p.getString(_sessionKey);
    return id == null ? null : findById(id);
  }

  Future<void> setSession(String id) => _p.setString(_sessionKey, id);
  Future<void> clearSession() => _p.remove(_sessionKey);
}
