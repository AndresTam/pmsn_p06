import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAlquilerDetailService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('alquiler-detail');

  //Funcion para insertar un alquiler
  Future<void> createAlquilerDetail(String idAlquiler, String idProducto,
      double cantidad, int precioUnitario, double subtotal) async {
    try {
      await _usersCollection.add({
        'idAlquiler': idAlquiler,
        'idProducto': idProducto,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'subtotal': subtotal,
      });
      print('Alquiler detail created succesfully');
    } catch (e) {
      print('Error creating alquiler detail: $e');
    }
  }

  //Funcion para obtener los alquilers
  Future<List<Map<String, dynamic>>> getAlquilerDetail() async {
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
      print('Error getting alquilers details: $e');
      return [];
    }
  }

  //Funcion para actualizar un alquiler
  Future<void> updateAlquilerDetail(
      String idAlquilerDetalle,
      String idAlquiler,
      String idProducto,
      int cantidad,
      double precioUnitario,
      double subtotal) async {
    try {
      await _usersCollection.doc(idAlquilerDetalle).update({
        'idAlquiler': idAlquiler,
        'idProducto': idProducto,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'subtotal': subtotal,
      });
      print('Alquiler detail updated successfully!');
    } catch (e) {
      print('Error updating alquiler detail: $e');
    }
  }

  //Función para eliminar un alquiler
  Future<void> deleteAlquilerDetail(String idAlquilerDetalle) async {
    try {
      await _usersCollection.doc(idAlquilerDetalle).delete();
      print('Alquiler detail deleted successfully!');
    } catch (e) {
      print('Error deleting alquiler detail: $e');
    }
  }
}
