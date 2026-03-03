import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class UpdateService {
  Future<void> checkForUpdate(BuildContext context) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final snapshot = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('version')
          .get();

      if (!snapshot.exists) return;

      final latestVersion = snapshot['latest_version'];
      final apkUrl = snapshot['apk_url'];

      if (currentVersion != latestVersion) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Update Available"),
            content: const Text(
                "A new version is available. Please update."),
            actions: [
              TextButton(
                onPressed: () async {
                  final Uri url = Uri.parse(apkUrl);
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: const Text("Update Now"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint("Update check failed: $e");
    }
  }
}