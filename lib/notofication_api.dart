import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'main.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel Id', "channel Name",
            channelDescription: "aa", icon: "@mipmap/ic_launcher"),
        iOS: IOSNotificationDetails());
  }

  static Future showNotification(
          {int id = 0, String title, String body, String payload}) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  static Future showNotif(
          {int id = 0, String title, String body, String payload}) async =>
      _notifications
          .periodicallyShow(
            id,
            title,
            body,
            RepeatInterval.everyMinute,
            await _notificationDetails(),
          )
          .whenComplete(() => () {
                print("sent scheduled 2x");
                //print("iso name " + isolateName);
                //prefs.reload();
                // print("user id being sent is" + id);
                IO.Socket socket;
                //socket.disconnect(
/*    NotificationApi.showNotification(
      title: "Socket Checking",
      body: "TEST Alarm Manager",
      payload: "TEST",
    );*/
                socket = IO.io(
                    'https://notification.strykepay.co.uk',
                    IO.OptionBuilder()
                        .setTransports(['websocket'])
                        .disableAutoConnect()
                        .setQuery({"_id": prefs.getString("id")})
                        .build());
                //TODO took this out to experiment
                socket.connect();
                socket.onConnect((_) async {
                  print('connect');
                  NotificationApi.showNotification(
                    title: "StrykePay",
                    body: "Welcome to StrykePay",
                    payload: "",
                  );
                });
                socket.on('notification', (data) {
                  print("notification");
                  NotificationApi.showNotification(
                    title: "Payment",
                    body: data,
                    payload: "TEST",
                  );
                  /*socket.onDisconnect((data) => NotificationApi.showNotification(
            title: "Please Open Your StrykePay App to Recieve Notifications",
            body: "TEST",
            payload: "TEST",
          ));*/
                  //lastNotification(data["payerId"]);;
                  print(data);
                });
              });
  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings("@mipmap/ic_launcher");
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final settings = InitializationSettings(
        android: android, iOS: initializationSettingsIOS);
    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {});
  }
}
