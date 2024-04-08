import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pmsn_06/screens/Registro_datos.dart';
import 'package:pmsn_06/screens/dashboard_screen.dart';
import 'package:pmsn_06/screens/detalle_renta_screen.dart';
import 'package:pmsn_06/screens/splash_screen.dart';
import 'package:pmsn_06/settings/app_value_notifier.dart';
import 'package:pmsn_06/settings/theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppValueNotifier.banTheme,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: value
              ? ThemeApp.darkTheme(context)
              : ThemeApp.lightTheme(context),
          home: const SplashScreen(),
          routes: {
            "/dash": (BuildContext context) => const DashboardScreen(),
            "/dRenta": (context) => const DetalleRentaScreen(
                  product: {},
                ),
            "/Rdatos": (context) =>
                const RegistroDatosScreen(product: {}, total: {}),
          },
          onUnknownRoute: (settings) {
            // Maneja rutas desconocidas
            print('ruta desconocida');
          },
        );
      },
    );
  }
}
