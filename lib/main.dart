import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tzData;
import 'package:permission_handler/permission_handler.dart';

import 'Screens/HomeScreen.dart';
import 'Screens/SplashScreen.dart';
import 'models/task_model.dart';
import 'services/notification_service.dart';

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    await Permission.notification.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tzData.initializeTimeZones();
  await NotificationService.initialize();
  await requestNotificationPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Todo List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const Splashscreen(),
      ),
    );
  }
}
