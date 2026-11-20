import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'services/data_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ds = await DataService.create();
  final auth = AuthProvider(ds);
  final router = createRouter(auth);
  runApp(ChangeNotifierProvider.value(value: auth, child: DarbApp(router: router)));
}

class DarbApp extends StatelessWidget {
  const DarbApp({super.key, required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'درب',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: router,
      locale: const Locale('ar', 'EG'), 
      supportedLocales: const [Locale('ar', 'EG')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
