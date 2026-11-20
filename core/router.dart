import 'package:go_router/go_router.dart';
import '../features/auth/change_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_placeholder.dart';
import '../features/splash/splash_screen.dart';
import '../providers/auth_provider.dart';

GoRouter createRouter(AuthProvider auth) => GoRouter(
      initialLocation: '/',
      refreshListenable: auth,
      redirect: (context, state) {
        final loc = state.matchedLocation;
        if (loc == '/') return null; // السبلاش بيقرر بنفسه

        final u = auth.user;
        if (u == null) return loc == '/login' ? null : '/login';

        // أول دخول: لازم يغيّر الباسورد قبل أي حاجة
        if (u.mustChangePassword) {
          return loc == '/change-password' ? null : '/change-password';
        }

        final home = u.isManager ? '/manager' : '/employee';
        if (loc == '/login') return home;
        // منع أي دور من فتح صفحة الدور التاني
        if (loc.startsWith('/manager') && !u.isManager) return home;
        if (loc.startsWith('/employee') && u.isManager) return home;
        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/change-password', builder: (_, __) => const ChangePasswordScreen()),
        GoRoute(path: '/employee', builder: (_, __) => const HomePlaceholder()),
        GoRoute(path: '/manager', builder: (_, __) => const HomePlaceholder()),
      ],
    );
