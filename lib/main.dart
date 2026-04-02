import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'l10n/app_localizations.dart';
import 'providers/tarot_provider.dart';
import 'providers/history_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/choice_provider.dart';
import 'screens/setting/settings_screen.dart';
import 'screens/choice/choice_screen.dart';
import 'screens/decision_map/decision_map_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // All initializations that don't depend on auth state
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await Firebase.initializeApp();

  // Initialize providers
  final settingsProvider = SettingsProvider();
  await settingsProvider.init();
  
  final historyProvider = HistoryProvider();
  await historyProvider.init();

  final tarotProvider = TarotProvider();
  await tarotProvider.init(settingsProvider.languageCode);

  final choiceProvider = ChoiceProvider();

  // Attempt to sign in silently in the background
  AuthService().signInAnonymously();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: tarotProvider),
        ChangeNotifierProvider.value(value: historyProvider),
        ChangeNotifierProvider.value(value: choiceProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: const OracleApp(),
    ),
  );
}

class OracleApp extends StatelessWidget {
  const OracleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme = lightDynamic?.harmonized() ??
            ColorScheme.fromSeed(seedColor: Colors.amber, brightness: Brightness.light);

        ColorScheme darkColorScheme = darkDynamic?.harmonized() ??
            ColorScheme.fromSeed(seedColor: Colors.amber, brightness: Brightness.dark);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('zh', ''),
          ],
          locale: settings.languageCode == 'system'
              ? null
              : Locale(settings.languageCode),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            scaffoldBackgroundColor: lightColorScheme.surface,
            appBarTheme: AppBarTheme(
              backgroundColor: lightColorScheme.surface,
              centerTitle: true,
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: lightColorScheme.secondaryContainer.withAlpha(204),
              indicatorColor: lightColorScheme.primary.withAlpha(77),
            )
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            scaffoldBackgroundColor: darkColorScheme.surface,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: darkColorScheme.secondaryContainer.withAlpha(204),
              indicatorColor: darkColorScheme.primary.withAlpha(77),
            )
          ),
          themeMode: settings.themeMode,
          home: const MainNavigation(),
        );
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  StreamSubscription? _authSubscription;
  bool _loginFailed = false;

  final List<Widget> _pages = [
    const ChoiceScreen(),
    const DecisionMapScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // After a short delay, check if we are still logged out.
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && AuthService().currentUser == null) {
        setState(() {
          _loginFailed = true;
        });
        _showLoginFailedSnackbar();
      }
    });

    // Listen for auth state changes to hide the message if login succeeds later.
    _authSubscription = AuthService().authStateChanges.listen((user) {
      if (user != null && _loginFailed) {
        setState(() {
          _loginFailed = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _showLoginFailedSnackbar() {
    // TODO: Localize this string
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Silent login failed. Cloud features are disabled.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.casino_outlined),
            label: l10n.bottomNavChoice,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            label: l10n.bottomNavMap,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: l10n.bottomNavMe,
          ),
        ],
      ),
    );
  }
}
