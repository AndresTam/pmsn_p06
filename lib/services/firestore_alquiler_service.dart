import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAlquilerService{
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('alquiler');

  //Funcion para insertar un alquiler
  Future<void> createAlquiler(String idCliente, String fechaAlquiler, String fechaDevolucion, double total) async {
    try{
      await _usersCollection.add({
        'idCliente': idCliente,
        'fechaAlquiler': fechaAlquiler,
        'fechaDevolucion': fechaDevolucion,
        'total': total
      });
      print('Alquiler created succesfully');
    } catch(e){
      print('Error creating alquiler: $e');
    }
  }

  //Funcion para obtener los alquilers
  Future<List<Map<String, dynamic>>> getAlquiler() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      List<Map<String, dynamic>> alquilersList = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        alquilersList.add(userData);
      });
      //print(alquilersList);
      return alquilersList;
    } catch (e) {
      print('Error getting alquilers: $e');
      return [];
    }
  }

  //Funcion para actualizar un alquiler
  Future<void> updateAlquiler(String idAlquiler, String idCliente, String fechaAlquiler, String fechaDevolucion, double total) async {
    try {
      await _usersCollection.doc(idAlquiler).update({
        'idCliente': idCliente,
        'fechaAlquiler': fechaAlquiler,
        'fechaDevolucion': fechaDevolucion,
        'total': total
      });
      print('Alquiler updated successfully!');
    } catch (e) {
      print('Error updating alquiler: $e');
    }
  }

  //Función para eliminar un alquiler
  Future<void> deleteAlquiler(String idAlquiler) async {
    try {
      await _usersCollection.doc(idAlquiler).delete();
      print('Alquiler deleted successfully!');
    } catch (e) {
      print('Error deleting alquiler: $e');
    }
  }
}