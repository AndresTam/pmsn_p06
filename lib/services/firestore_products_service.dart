import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProductService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('productos');

  //Funcion para insertar un producto
  Future<void> createProduct(String nombre, String descripcion, double precio,
      String imagen, String categoria) async {
    try {
      await _usersCollection.add({
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'imagen': imagen,
        'categoria': categoria
      });
      print('Product created succesfully');
    } catch (e) {
      print('Error creating product: $e');
    }
  }

  //Funcion para obtener los productos
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      List<Map<String, dynamic>> productsList = [];
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        productsList.add(userData);
      });
      //print(productsList);
      print(productsList);
      return productsList;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  //Funcion para actualizar un producto
  Future<void> updateProduct(
      String idProducto,
      String nombre,
      String descripcion,
      double precio,
      String imagen,
      String categoria) async {
    try {
      await _usersCollection.doc(idProducto).update({
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'imagen': imagen,
        'categoria': categoria
      });
      print('Product updated successfully!');
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  //Función para eliminar un producto
  Future<void> deleteProduct(String idProducto) async {
    try {
      await _usersCollection.doc(idProducto).delete();
      print('Product deleted successfully!');
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  //Función para llamar a un producto
  Future<Map<String, dynamic>?> getProductById(String nombre) async {
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection.where('nombre', isEqualTo: nombre).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Devuelve los datos del primer documento encontrado (suponiendo que los nombres de los productos son únicos)
        print(querySnapshot.docs.first.data() as Map<String, dynamic>);
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        print('No se encontró ningún producto con el nombre especificado.');
        return null;
      }
    } catch (e) {
      print('Error obteniendo el producto: $e');
      return null;
    }
  }

  Future<String?> getDocumentIdFromName(String nombre) async {
    try {
      // Realizar una consulta para buscar documentos que coincidan con el nombre
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('productos')
          .where('nombre', isEqualTo: nombre)
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
