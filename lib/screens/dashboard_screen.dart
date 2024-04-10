import 'package:flutter/material.dart';
import 'package:pmsn_06/screens/alquiler_screen.dart';
import 'package:pmsn_06/screens/detalle_renta_screen.dart';
import 'package:pmsn_06/services/firestore_products_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final FirestoreProductService firestoreProductService =
        FirestoreProductService();
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Productos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today), // Icono de calendario
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlquilerScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: firestoreProductService.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error al cargar los productos'),
              );
            }
            List<Map<String, dynamic>> products = snapshot.data!;
            List<Map<String, dynamic>> sillasProducts = products
                .where((product) => product['categoria'] == 'sillas')
                .toList();
            List<Map<String, dynamic>> mesasProducts = products
                .where((product) => product['categoria'] == 'mesas')
                .toList();
            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20.0),
                    _buildSection('Sillas', sillasProducts, context),
                    const SizedBox(height: 20.0),
                    _buildSection('Mesas', mesasProducts, context),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _buildSection(
  String title, List<Map<String, dynamic>> products, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      Container(
        height: 500,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            var product = products[index];
            return _productCard(
              product['nombre'],
              product['precio'].toString(),
              product['imagen'],
              context,
              product, // Pasar el producto completo al widget del producto
            );
          },
        ),
      ),
    ],
  );
}

Widget _productCard(String nombreProducto, String precio, String imagePath,
    BuildContext context, Map<String, dynamic> product) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalleRentaScreen(product: product),
        ),
      );
    },
    child: Container(
      width: 300,
      margin:
          const EdgeInsets.only(top: 20.0, left: 20.0, bottom: 20.0, right: 5),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 102,
                    width: 300,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 241, 241, 241),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            nombreProducto,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '\$$precio por unidad',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// class ProductDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> product;

//   const ProductDetailScreen({Key? key, required this.product})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product['nombre']),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(product['nombre']),
//             Text(product['precio'].toString()),
//             // Aquí puedes mostrar más detalles del producto si lo necesitas
//           ],
//         ),
//       ),
//     );
//   }
// }