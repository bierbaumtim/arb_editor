import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/search/intent.dart';
import 'features/search/provider.dart';
import 'home_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      shortcuts: {
        ...WidgetsApp.defaultShortcuts,
        const SingleActivator(
          LogicalKeyboardKey.keyF,
          control: true,
        ): SearchIntent(
          () => ref.read(showSearchProvider.notifier).state =
              !ref.read(showSearchProvider),
        ),
      },
      actions: {
        ...WidgetsApp.defaultActions,
        SearchIntent: SearchAction(),
      },
    );
  }
}
