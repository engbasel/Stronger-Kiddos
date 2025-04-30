// lib/core/utils/network_helper.dart
import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/network/network_info.dart';

import '../services/injection_container.dart';

class NetworkHelper {
  static Future<bool> hasConnection() async {
    return await sl<NetworkInfo>().isConnected();
  }

  static void showNoConnectionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection. Using cached data.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  static Future<bool> checkConnectionWithFeedback(BuildContext context) async {
    final connectionStatus = await hasConnection();
    if (!connectionStatus) {
      if (!context.mounted) return connectionStatus;
      showNoConnectionSnackBar(context);
    }
    return connectionStatus;
  }
}
