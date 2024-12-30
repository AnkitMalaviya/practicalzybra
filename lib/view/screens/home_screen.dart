import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zybrapracticaltask/core/responsive/responsive.dart';
import 'package:zybrapracticaltask/view/screens/add_update_task_screen.dart';
import 'package:zybrapracticaltask/view/screens/view_task_screen.dart';

import '../../providers/task_provider.dart';
import '../../view_models/sort_viewmodel.dart';
import '../../view_models/theme_viewmodel.dart';
import '../widgets/taskLIst_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    final isDarkMode = themeMode == ThemeMode.dark;

    print("gfsdgsgd");
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Management App'),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                ref.read(preferencesProvider.notifier).updateSortOrder(value);
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'date',
                    child: Text('Sort by Date'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'priority',
                    child: Text('Sort by Priority'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Responsive.isMobile(context)
            ? Column(
          children: [
            searchBarWidget(ref, context),
            Expanded(child: TaskListView()),
          ],
        )
            : Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  searchBarWidget(ref, context),
                  Expanded(child: TaskListView()),
                ],
              ),
            ),
            const Expanded(
              flex: 3,
              child: ViewTaskScreen(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddUpdateTaskScreen();
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Padding searchBarWidget(WidgetRef ref, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                labelText: 'Search Tasks',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              if (Responsive.isMobile(context)) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return FilterWidget(ref, context);
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: FilterWidget(ref, context),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Padding FilterWidget(WidgetRef ref, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width:
        Responsive.isMobile(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Apply Filter'),
            SizedBox(
              height: 20,
            ),
            ListTile(
              title: const Text('All'),
              onTap: () {
                // Set filter to 'All'
                ref.read(filterPriorityProvider.notifier).state = null;
                Navigator.pop(context); // Close the BottomSheet
              },
            ),
            ListTile(
              title: const Text('Low Priority'),
              onTap: () {
                // Set filter to 'Low'
                ref.read(filterPriorityProvider.notifier).state = 'Low';
                Navigator.pop(context); // Close the BottomSheet
              },
            ),
            ListTile(
              title: const Text('Medium Priority'),
              onTap: () {
                // Set filter to 'Medium'
                ref.read(filterPriorityProvider.notifier).state = 'Medium';
                Navigator.pop(context); // Close the BottomSheet
              },
            ),
            ListTile(
              title: const Text('High Priority'),
              onTap: () {
                // Set filter to 'High'
                ref.read(filterPriorityProvider.notifier).state = 'High';
                Navigator.pop(context); // Close the BottomSheet
              },
            ),
          ],
        ),
      ),
    );
  }
}
