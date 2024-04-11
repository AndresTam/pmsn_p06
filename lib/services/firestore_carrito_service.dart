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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> copiarDatosSimilares(String sourceCollection,
      String destinationCollection, String idAlquiler) async {
    // Consulta los documentos en la colección de carrito
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection(sourceCollection).get();

    // Itera sobre los documentos y copia los datos similares a la colección de detalle de alquiler
    querySnapshot.docs.forEach((doc) async {
      // Obtén los datos del documento
      Map<String, dynamic> data = doc.data();

      // Crea un nuevo documento en la colección de detalle de alquiler
      await _firestore.collection(destinationCollection).add({
        'idAlquiler': idAlquiler,
        'idProducto': data['idProducto'].toString(),
        'cantidad': int.parse(data['cantidad']),
        'precioUnitario': double.parse(data['precioUnitario']),
        'subtotal': double.parse(data['subtotal']),
      });
    });
  }

  Future<double> sumarCantidadesCarrito() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      double totalCantidades = 0;
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        final cantidad = userData['cantidad'] as double;
        totalCantidades += cantidad;
      });
      return totalCantidades;
    } catch (e) {
      print('Error sumando las cantidades del carrito: $e');
      return 0;
    }
  }

  Future<void> borrarTodoElCarrito() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      querySnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
      print('Todos los datos del carrito han sido borrados exitosamente');
    } catch (e) {
      print('Error borrando todos los datos del carrito: $e');
    }
  }
}
