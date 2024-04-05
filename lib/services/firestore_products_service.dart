import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProductService{
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('productos');

  //Funcion para insertar un producto
  Future<void> createProduct(String nombre, String descripcion, double precio, String imagen, String categoria) async {
    try{
      await _usersCollection.add({
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'imagen': imagen,
        'categoria': categoria
      });
      print('Product created succesfully');
    } catch(e){
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
      return productsList;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  //Funcion para actualizar un producto
  Future<void> updateProduct(String idProducto, String nombre, String descripcion, double precio, String imagen, String categoria) async {
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
}