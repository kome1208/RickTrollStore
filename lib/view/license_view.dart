import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LicenseView extends HookWidget {
  const LicenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return LicensePage(
      applicationName: 'RickTrollStore',
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset('assets/appicon.png', height: 64,),
      ),
      applicationLegalese: 'by kome1',
    );
  }
}