import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pmsn_06/screens/prueba.dart';
import 'firebase_options.dart';
void main() async{
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
    return MaterialApp(
      title: 'Rent Aplication',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Renta de mesas'),
        ),
        body: Center(
          child: MyHomePage(),
        ),
      ),
    );
  }
}