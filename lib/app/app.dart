import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zybrapracticaltask/view/screens/home_screen.dart';

import '../core/theme/app_theme.dart';
import '../view_models/theme_viewmodel.dart';


class TaskManagementApp extends ConsumerWidget {
  const TaskManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return
     MaterialApp(
        title: 'Task Management',
       theme: AppTheme.lightTheme,
       darkTheme: AppTheme.darkTheme,
       themeMode: themeMode,
     home: HomeScreen(),
      );
  }
}
