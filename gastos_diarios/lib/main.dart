import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'telas/home_page.dart';
import 'login/login.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception(
      'SUPABASE_URL ou SUPABASE_ANON_KEY não encontrados no .env. '
      'Verifique o arquivo .env na raiz do projeto.',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const GastosDiariosApp(),
    ),
  );
}

class GastosDiariosApp extends StatelessWidget {
  const GastosDiariosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final ThemeData lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      cardColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF3F4A5A),
        secondary: Color(0xFF111827),
      ),
      dividerColor: const Color(0xFFE5E9F0),
    );

    final ThemeData darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF050816),
      cardColor: const Color(0xFF111827),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF38BDF8),
        secondary: Color(0xFF6366F1),
      ),
    );

    return MaterialApp(
      title: 'Gastos Diários',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: const _AuthGate(), 
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate({super.key});

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
