import 'package:flutter/material.dart';
import 'package:pmsn_06/funcion/carrito_badges.dart';
import 'package:pmsn_06/screens/Registro_datos.dart';
import 'package:pmsn_06/services/firestore_carrito_service.dart';
import 'package:pmsn_06/services/firestore_products_service.dart';

class DetalleRentaScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  final FirestoreProductService _firestoreProductsService =
      FirestoreProductService();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final FirestoreCarritoService _firestoreCarritoService =
      FirestoreCarritoService();

  DetalleRentaScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalla Producto"),
        backgroundColor: Colors.blue,
        actions: [
          buildCarritoIconButton(context),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _firestoreProductsService.getProductById(product['nombre']),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data != null) {
                Map<String, dynamic> productData = snapshot.data!;
                dynamic precioValue = productData['precio'];
                double? _precio;
                double? _total;
                double? cantidad;

                if (precioValue is String) {
                  if (precioValue.contains('.')) {
                    _precio = double.parse(precioValue);
                  } else {
                    _precio = int.parse(precioValue).toDouble();
                  }
                } else if (precioValue is double || precioValue is int) {
                  _precio = precioValue.toDouble();
                } else {
                  _precio = 0.0;
                }

                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        productData['nombre'] ?? 'Sin nombre',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Image(
                        height: MediaQuery.of(context).size.height * 0.3,
                        image: NetworkImage(
                          productData['imagen'],
                        ),
                      ),
                      Text(
                        'Precio: \$${_precio?.toStringAsFixed(2)}' ??
                            'Precio desconocido',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.format_list_numbered),
                                  labelText: 'Ingrese la cantidad:',
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Text(
                        productData['descripcion'] ?? 'Sin descripción',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              final String quantityText =
                                  _quantityController.text.trim();
                              final double quantity =
                                  double.tryParse(quantityText) ?? 0.0;
                              if (_precio != null) {
                                _total = _precio * quantity;
                                _totalController.text =
                                    _total!.toStringAsFixed(2);
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistroDatosScreen(
                                    product: productData,
                                    total: _total,
                                    longitud: 0,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Rentar ahora'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final String quantityText =
                                  _quantityController.text.trim();
                              cantidad = double.tryParse(quantityText) ?? 0.0;

                              if (cantidad! <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Ingrese una cantidad válida.'),
                                  ),
                                );
                                return;
                              }

                              String? IDProducto =
                                  await _firestoreProductsService
                                      .getDocumentIdFromName(
                                          productData['nombre']);
                              await _firestoreCarritoService.createCarrito(
                                IDProducto!,
                                productData['nombre'],
                                cantidad!,
                                _precio!,
                                _total!,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Producto añadido a carrito'),
                                ),
                              );
                            },
                            child: const Text('Agregar a carrito'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Text(
                    'No se encontró ningún producto con el nombre especificado');
              }
            }
          },
        ),
      ),
    );
  }
}
