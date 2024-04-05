import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClientService{
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('clientes');

  //Funcion para insertar un cliente
  Future<void> createClient(String nombre, String apellido, String direccion, String telefono, String correo) async {
    try{
      await _usersCollection.add({
        'nombre': nombre,
        'apellido': apellido,
        'direccion': direccion,
        'telefono': telefono,
        'correo': correo
      });
      print('Client created succesfully');
    } catch(e){
      print('Error creating client: $e');
    }
  }

  //Funcion para obtener los cliente
  Future<List<Map<String, dynamic>>> getClients() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      List<Map<String, dynamic>> clientsList = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        clientsList.add(userData);
      });
      print(clientsList);
      return clientsList;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  //Funcion para actualizar un cliente
  Future<void> updateClient(String idCliente, String nombre, String apellido, String direccion, String telefono, String correo) async {
    try {
      await _usersCollection.doc(idCliente).update({
        'nombre': nombre,
        'apellido': apellido,
        'direccion': direccion,
        'telefono': telefono,
        'correo': correo
      });
      print('Client updated successfully!');
    } catch (e) {
      print('Error updating client: $e');
    }
  }

  //Función para eliminar un cliente
  Future<void> deleteClient(String idCliente) async {
    try {
      await _usersCollection.doc(idCliente).delete();
      print('Client deleted successfully!');
    } catch (e) {
      print('Error deleting client: $e');
    }
  }
}