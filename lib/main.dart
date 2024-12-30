import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app/app.dart';
import 'core/notification/notification_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('settings');
  NotificationService().initialize();
  NotificationService().requestPermission();
  NotificationService().listenToNotificationTaps();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfi;
  }

  runApp(ProviderScope(child: const TaskManagementApp()));
}
