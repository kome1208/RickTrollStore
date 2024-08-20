import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ricktrollstore/provider/installed_apps_provider.dart';
import 'package:ricktrollstore/widget/loading_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppsView extends HookConsumerWidget {
  const AppsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apps'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add),
            onSelected: (value) async {
              switch (value) {
                case 'IPA':
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowedExtensions: ['tipa', 'ipa', 'apk'],
                    type: FileType.custom
                  );

                  if (result != null) {
                    break;
                  } else {
                    return;
                  }
                case 'URL':
                  final install = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Install from URL'),
                        content: const TextField(
                          selectionWidthStyle: BoxWidthStyle.max,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'URL'
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Install')
                          ),
                        ],
                      );
                    }
                  );

                  if (install == true) {
                    break;
                  } else {
                    return;
                  }
                default:
              }

              await Future.delayed(const Duration(milliseconds: 500));

              if (context.mounted) LoadingDialog.show(context, 'Installing');

              await Future.delayed(const Duration(seconds: 2));

              ref.read(installedAppsNotifierProvider.notifier).add();

              if (context.mounted) LoadingDialog.hide(context);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'IPA',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Install ${Platform.isIOS ? 'IPA' : 'APK'} File'),
                    trailing: const Icon(Icons.file_open_outlined),
                  )
                ),
                const PopupMenuItem(
                  value: 'URL',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Install from URL'),
                    trailing: Icon(Icons.add_link),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: ref.watch(installedAppsNotifierProvider).length,
        itemBuilder: (context, index) {
          final app = json.decode(ref.watch(installedAppsNotifierProvider)[index]);

          return ListTile(
            title: const Text('RickRoll'),
            subtitle: const Text('1.0・com.rickastley.rickroll'),
            shape: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant, width: 1)),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0)
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset('assets/icons/${app['icon'] ?? 'icon0.png'}'),
            ),
            onTap: () async {
              final uninstall = await showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) {
                  return SizedBox(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: const Text('RickRoll'),
                          subtitle: const Text('1.0・com.rickastley.rickroll'),
                          leading: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0)
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset('assets/icons/${app['icon'] ?? 'icon0.png'}'),
                          )
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.open_in_new_outlined),
                          title: const Text('Open'),
                          onTap: () async {
                            Navigator.pop(context);
                            await launchUrlString('https://youtu.be/dQw4w9WgXcQ', mode: LaunchMode.externalApplication);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_outline),
                          title: const Text('Uninstall App'),
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.cancel_outlined),
                          title: const Text('Cancel'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                }
              );
              await Future.delayed(const Duration(milliseconds: 500));

              if (context.mounted && uninstall == true) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm Uninstallation'),
                      content: const Text('Uninstalling the app \'RickRoll\' will delete the app and all data associated to it.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ref.read(installedAppsNotifierProvider.notifier).remove(index);
                          },
                          child: const Text(
                            'Uninstall',
                            style: TextStyle(
                              color: Colors.red
                            ),
                          )
                        )
                      ],
                    );
                  }
                );
              }
            },
          );
        },
      ),
    );
  }
}