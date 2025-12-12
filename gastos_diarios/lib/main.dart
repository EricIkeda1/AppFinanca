import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'telas/home_page.dart';
import 'login/login.dart';

class ThemeProvider extends ChangeNotifier {
  static const _kFontScaleKey = 'font_scale';

  ThemeMode _themeMode = ThemeMode.light;
  double _fontScale = 1.0;
  bool _loaded = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  double get fontScale => _fontScale;
  bool get loaded => _loaded;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> loadLocalFontScale() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getDouble(_kFontScaleKey) ?? 1.0;
    _fontScale = v.clamp(0.8, 1.6);
    _loaded = true;
    notifyListeners();
  }

  Future<void> setFontScale(double v) async {
    final clamped = v.clamp(0.8, 1.6);
    _fontScale = clamped;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kFontScaleKey, clamped);
  }

  Future<void> clearLocalFontScale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kFontScaleKey);
    _fontScale = 1.0;
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception('SUPABASE_URL / SUPABASE_ANON_KEY ausentes no .env');
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

class GastosDiariosApp extends StatefulWidget {
  const GastosDiariosApp({super.key});

  @override
  State<GastosDiariosApp> createState() => _GastosDiariosAppState();
}

class _GastosDiariosAppState extends State<GastosDiariosApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().loadLocalFontScale();
    });
  }

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

      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: TextScaler.linear(themeProvider.fontScale),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return const HomePage();
    }
    return const LoginPage();
  }
}
