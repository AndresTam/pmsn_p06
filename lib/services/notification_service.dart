import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pmsn_06/services/firestore_alquiler_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final firestoreService = FirestoreAlquilerService();

Future<void> initNotifications() async{
  //Constante de inicialización para Android
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('rentamesas');
  //Constante de inicialización para IOS
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
  //Contante de inicialización para los sistemas
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> mostrarNotificacion() async {
  final alquileres = await firestoreService.getAlquiler();
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channelId', 'channelName');
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails
  );

  for(final alquiler in alquileres){
    String idCliente = alquiler['idCliente'];
    String fechaAlquiler = alquiler['fechaAlquiler'];
    DateTime fechaActual = DateTime.now();
    DateTime fechaAlquilerDT = DateFormat('yyyy-MM-dd').parse(fechaAlquiler);
    DateTime dosDiasAntes = fechaAlquilerDT.subtract(const Duration(days:2));
    fechaActual = DateTime(fechaActual.year, fechaActual.month, fechaActual.day);
    if(fechaActual.isAtSameMomentAs(dosDiasAntes)){
      await flutterLocalNotificationsPlugin.show(
        1,
        'Tu renta de acerca',
        'Tu renta con id: $idCliente será en 2 días. Recuerda que tu fecha es: $fechaAlquiler',
        notificationDetails
      );
    }
  }
}