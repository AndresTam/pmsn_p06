import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAlquilerService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('alquiler');

  //Funcion para insertar un alquiler
  Future<void> createAlquiler(String idCliente, String fechaAlquiler,
      String fechaDevolucion, double total) async {
    try {
      await _usersCollection.add({
        'idCliente': idCliente,
        'fechaAlquiler': fechaAlquiler,
        'fechaDevolucion': fechaDevolucion,
        'total': total
      });
      print('Alquiler created succesfully');
    } catch (e) {
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
  Future<void> updateAlquiler(String idAlquiler, String idCliente,
      String fechaAlquiler, String fechaDevolucion, double total) async {
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

  Future<String?> getDocumentId(String IdCliente) async {
    try {
      // Realizar una consulta para buscar documentos que coincidan con el nombre
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('alquiler')
          .where('idCliente', isEqualTo: IdCliente)
          .where(FieldPath.documentId)
          .limit(1) // Limitar la consulta a un solo resultado
          .get();

      // Verificar si hay resultados
      if (querySnapshot.docs.isNotEmpty) {
        // Obtener el Documento ID del primer documento que coincide
        String documentId = querySnapshot.docs.first.id;
        return documentId;
      } else {
        print('No se encontraron documentos con el nombre $IdCliente');
        return null;
      }
    } catch (error) {
      print('Error al buscar el Documento ID: $error');
      return null;
    }
  }
}
