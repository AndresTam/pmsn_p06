import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pmsn_06/screens/detalle_renta_screen.dart';
import 'package:splash_view/source/presentation/pages/splash_view.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashView(
      backgroundColor: const Color.fromRGBO(246, 176, 13, 1.0),
      loadingIndicator: const RefreshProgressIndicator(),
      logo: Lottie.network(
        'https://lottie.host/1b117059-adf0-40de-99fa-1a652430c81f/qSK5dDq5ro.json',
        height: 130,
        width: 130,
      ),
      done: Done(
        const DetalleRentaScreen(),
        animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
