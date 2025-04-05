// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:collaborative_todo/config/routes.dart';
import 'package:collaborative_todo/config/theme.dart';
import 'package:collaborative_todo/viewmodels/auth_viewmodel.dart';
import 'package:collaborative_todo/viewmodels/task_list_viewmodel.dart';
import 'package:collaborative_todo/viewmodels/sharing_viewmodel.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:collaborative_todo/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TaskListViewModel()),
        ChangeNotifierProvider(create: (_) => SharingViewModel()),
      ],
      child: MaterialApp(
        title: 'Collaborative TODO',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: ClampingScrollWrapper.builder(context, child!),
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}