import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'l10n/app_localizations.dart'; // Corrected import path
import 'providers/tarot_provider.dart';
import 'providers/history_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/quick_picks/quick_pick_screen.dart';
import 'screens/oracle/oracle_pick_screen.dart';
import 'screens/setting/settings_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  // Note: You must run `flutterfire configure` for this to work properly
  try {
    await Firebase.initializeApp();
    // Perform anonymous login when app starts
    await AuthService().signInAnonymously();
  } catch (e) {
    print("Firebase initialization error: $e");
    print("Please make sure you have run `flutterfire configure`");
  }

  final historyProvider = HistoryProvider();
  await historyProvider.init();

  final settingsProvider = SettingsProvider();
  await settingsProvider.init();

  final tarotProvider = TarotProvider();
  await tarotProvider.init(settingsProvider.languageCode);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: tarotProvider),
        ChangeNotifierProvider.value(value: historyProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: const OracleApp(),
    ),
  );
}

class OracleApp extends StatefulWidget {
  const OracleApp({super.key});

  @override
  State<OracleApp> createState() => _OracleAppState();
}

class _OracleAppState extends State<OracleApp> {
  static const _defaultSeedColor = Colors.amber;
  String? _previousLanguage;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    if (_previousLanguage != null && _previousLanguage != settings.languageCode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<TarotProvider>().loadTarotData(settings.languageCode);
      });
    }
    _previousLanguage = settings.languageCode;

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme = lightDynamic?.harmonized() ??
            ColorScheme.fromSeed(seedColor: _defaultSeedColor, brightness: Brightness.light);

        ColorScheme darkColorScheme = darkDynamic?.harmonized() ??
            ColorScheme.fromSeed(seedColor: _defaultSeedColor, brightness: Brightness.dark);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

          // --- LOCALIZATION START ---
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('zh', ''), // Chinese
          ],
          locale: settings.languageCode == 'system'
              ? null // Let Flutter decide based on system settings
              : Locale(settings.languageCode),
          // --- LOCALIZATION END ---

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

  final List<Widget> _pages = [
    const QuickPickScreen(),
    // const Center(child: Text('AI Draw - Coming Soon')),
    const OraclePickScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Use the generated localizations
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
          NavigationDestination(icon: const Icon(Icons.grid_view_rounded), label: l10n.bottomNavQuick),
          //NavigationDestination(icon: const Icon(Icons.auto_awesome), label: l10n.bottomNavAiDraw),
          NavigationDestination(icon: const Icon(Icons.fort_rounded), label: l10n.bottomNavOracle),
          NavigationDestination(icon: const Icon(Icons.person_outline), label: l10n.bottomNavMe),
        ],
      ),
    );
  }
}