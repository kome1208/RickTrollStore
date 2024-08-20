import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ricktrollstore/provider/theme_mode_provider.dart';
import 'package:ricktrollstore/view/license_view.dart';

class SettingsView extends HookConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('App Theme'),
            trailing: DropdownButton(
              value: ref.watch(themeModeNotifierProvider),
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light')
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark')
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System')
                ),
              ],
              onChanged: (ThemeMode? value) {
                if (value != null) ref.watch(themeModeNotifierProvider.notifier).setTheme(value);
              },
            )
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Licenses'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LicenseView()));
            },
          )
        ],
      )
    );
  }
}