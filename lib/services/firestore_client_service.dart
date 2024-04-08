import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreClientService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('clientes');

  //Funcion para insertar un cliente
  Future<void> createClient(String nombre, String apellido, String direccion,
      String telefono, String correo, String imagen) async {
    try {
      await _usersCollection.add({
        'nombre': nombre,
        'apellido': apellido,
        'direccion': direccion,
        'telefono': telefono,
        'correo': correo,
        'imagen': imagen
      });
      print('Client created succesfully');
    } catch (e) {
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
  Future<void> updateClient(String idCliente, String nombre, String apellido,
      String direccion, String telefono, String correo, String imagen) async {
    try {
      await _usersCollection.doc(idCliente).update({
        'nombre': nombre,
        'apellido': apellido,
        'direccion': direccion,
        'telefono': telefono,
        'correo': correo,
        'imagen': imagen
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

  Future<String?> getDocumentIdFromName(String nombre, String apellidos) async {
    try {
      // Realizar una consulta para buscar documentos que coincidan con el nombre
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('clientes')
          .where('nombre', isEqualTo: nombre)
          .where('apellido', isEqualTo: apellidos)
          .where(FieldPath.documentId)
          .limit(1) // Limitar la consulta a un solo resultado
          .get();

      // Verificar si hay resultados
      if (querySnapshot.docs.isNotEmpty) {
        // Obtener el Documento ID del primer documento que coincide
        String documentId = querySnapshot.docs.first.id;
        return documentId;
      } else {
        print('No se encontraron documentos con el nombre $nombre');
        return null;
      }
    } catch (error) {
      print('Error al buscar el Documento ID: $error');
      return null;
    }
  }
}
