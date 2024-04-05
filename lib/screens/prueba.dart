import 'package:flutter/material.dart';
import 'package:pmsn_06/services/firestore_client_service.dart';


class MyHomePage extends StatelessWidget {
  final FirestoreClientService _firestoreService = FirestoreClientService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore CRUD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Llama a la función para crear un usuario
                _firestoreService.createClient('John', 'Travolta', 'Carretera a Morelia #1400', '4611225516', 'correo@gmail.com', 'http://google.com');
              },
              child: Text('Create User'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Llama a la función para obtener todos los usuarios
                List<Map<String, dynamic>> users = await _firestoreService.getClients();
                // Haz algo con la lista de usuarios, como mostrarla en un ListView
              },
              child: Text('Read Users'),
            ),
            // Agrega botones para Update y Delete según sea necesario
          ],
        ),
      ),
    );
  }
}