import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ricktrollstore/provider/theme_mode_provider.dart';
import 'package:ricktrollstore/provider/shared_preferences.dart';
import 'package:ricktrollstore/view/apps_view.dart';
import 'package:ricktrollstore/view/settings_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(await SharedPreferences.getInstance())
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeData lightTheme(ColorScheme? lightColorScheme) {
      final scheme = lightColorScheme ?? ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      );
      return ThemeData(
        colorScheme: scheme,
        useMaterial3: true
      );
    }

    ThemeData darkTheme(ColorScheme? darkColorScheme) {
      final scheme = darkColorScheme ?? ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      );
      return ThemeData(
        colorScheme: scheme,
        useMaterial3: true
      );
    }

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'RickTrollStore',
          theme: lightTheme(lightDynamic),
          darkTheme: darkTheme(darkDynamic),
          themeMode: ref.watch(themeModeNotifierProvider),
          home: const MainView(),
        );
      }
    );
  }
}

class MainView extends HookConsumerWidget {
  const MainView({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState<int>(0);
    final pageController = usePageController();

    const pageList = [
      AppsView(),
      SettingsView(),
    ];

    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.apps_outlined),
        selectedIcon: Icon(Icons.apps),
        label: 'Apps',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];

    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pageList.length,
        controller: pageController,
        onPageChanged: (index) {
          selectedIndex.value = index;
        },
        itemBuilder: (context, index) {
          return pageList[index];
        }
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        destinations: destinations,
        selectedIndex: selectedIndex.value,
        onDestinationSelected: (index) {
          if (pageController.hasClients) {
            selectedIndex.value = index;
            pageController.jumpToPage(index);
          }
        },
      )
    );
  }
}