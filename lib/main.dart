import 'package:flutter/material.dart';
import 'package:notification_test/home_screen.dart';
import 'package:notification_test/util/push_notification_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationUtil.init();
  await PushNotificationUtil.requestNotificationPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
