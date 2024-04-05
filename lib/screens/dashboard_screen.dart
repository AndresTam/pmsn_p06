import 'package:flutter/material.dart';
import 'package:pmsn_06/services/firestore_products_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen ({super.key});

  @override
  Widget build(BuildContext context) {
  final FirestoreProductService firestoreProductService = FirestoreProductService();
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15), // Redondea los bordes inferiores
          ),
        ),
        centerTitle: true, // Centra el título
        title: const Text(
          'Productos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
                  _buildSection('Sillas', sillasProducts),
                  const SizedBox(height: 20.0),
                  _buildSection('Mesas', mesasProducts),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _buildSection(String title, List<Map<String, dynamic>> products) {
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
        SizedBox(
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
              );
            },
          ),
        ),
      ],
    );
  }


Widget _productCard(String nombreProducto, String precio, String imagePath){
  return Container(
    width: 300,
    margin: const EdgeInsets.only(top: 20.0, left: 20.0, bottom: 20.0, right: 5),
    child: Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // adds rounded corners
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
                fit: BoxFit.contain
              )
            ),
          ),
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
                      fontSize: 25
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '\$$precio por unidad',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20
                    )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}