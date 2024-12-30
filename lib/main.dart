import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app/app.dart';
import 'core/notification/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/permission/permission_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  tz.initializeTimeZones();
  await Hive.openBox('settings');
  final notificationService = NotificationService();
  await notificationService.init();
  await requestExactAlarmPermission();
if(kIsWeb){

  databaseFactory = databaseFactoryFfi;
}

  runApp(ProviderScope(child: const TaskManagementApp()));
}