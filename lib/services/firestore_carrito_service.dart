import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCarritoService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('carrito');

  // //Funcion para crear la coleccion
  // Future<void> crearNuevaColeccion(String nombreColeccion) async {
  //   try {
  //     // Obtener una instancia de Firestore
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     // Llamar al método collection para crear la nueva colección
  //     await firestore.collection(nombreColeccion).doc();

  //     print('Nueva colección "$nombreColeccion" creada exitosamente.');
  //   } catch (error) {
  //     print('Error al crear la nueva colección: $error');
  //   }
  // }

  //Funcion para insertar un alquiler
  Future<void> createCarrito(String idProducto, String nombreProducto,
      double cantidad, double precioUnitario, double subtotal) async {
    try {
      await _usersCollection.add({
        'idProducto': idProducto,
        'nombreProducto': nombreProducto,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'subtotal': subtotal,
      });
      print('Carrito created succesfully');
    } catch (e) {
      print('Error creating Carrito: $e');
    }
  }

  //Funcion para obtener los alquilers
  Future<List<Map<String, dynamic>>> getcarrito() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      List<Map<String, dynamic>> carritoList = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        carritoList.add(userData);
      });
      //print(alquilersList);
      return carritoList;
    } catch (e) {
      print('Error getting Carrito: $e');
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
      print('Carrito updated successfully!');
    } catch (e) {
      print('Error updating Carrito: $e');
    }
  }

  //Función para eliminar un alquiler
  Future<void> deleteAlquilerDetail(String idAlquilerDetalle) async {
    try {
      await _usersCollection.doc(idAlquilerDetalle).delete();
      print('Carrito deleted successfully!');
    } catch (e) {
      print('Error deleting Carrito: $e');
    }
  }

  Future<void> copiarDatosSimilares(
      String origen, String destino, String idAlquiler) async {
    // Referencia a la colección de origen (carrito)
    CollectionReference<Map<String, dynamic>> origenRef =
        FirebaseFirestore.instance.collection(origen);

    // Referencia a la colección de destino (alquiler_detail)
    CollectionReference<Map<String, dynamic>> destinoRef =
        FirebaseFirestore.instance.collection(destino);

    // Obtiene los documentos de la colección de origen (carrito)
    QuerySnapshot<Map<String, dynamic>> snapshot = await origenRef.get();

    // Itera sobre cada documento
    snapshot.docs.forEach((doc) async {
      // Obtén los datos específicos del documento que deseas copiar
      Map<String, dynamic> data = {
        'idAlquiler': idAlquiler, // Campo común entre ambas colecciones
        'idProducto': doc['idProducto'],
        'cantidad': doc['cantidad'],
        'precioUnitario': doc['precioUnitario'],
        'subtotal': doc['subtotal'],
        // Agrega más campos según sea necesario
      };

      // Inserta los datos en la colección de destino (alquiler_detail)
      await destinoRef.add(data);
    });
  }
}
