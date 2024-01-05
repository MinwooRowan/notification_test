import 'package:flutter/material.dart';
import 'package:notification_test/util/push_notification_util.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await PushNotificationUtil.selectedTimePushAlarm(
                  hour: 11,
                  minute: 18,
                );
              },
              child: Text(
                'SUBSCRIBE TIME ZONE NOTIFICATION',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
