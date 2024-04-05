import 'package:flutter/material.dart';
import 'package:pmsn_06/services/firestore_products_service.dart';

class DetalleRentaScreen extends StatefulWidget {
  const DetalleRentaScreen({super.key});

  @override
  State<DetalleRentaScreen> createState() => _DetalleRentaScreenState();
}

class _DetalleRentaScreenState extends State<DetalleRentaScreen> {
  final FirestoreProductService _firestoreProductsService =
      FirestoreProductService();
  final EspacioVertical = const SizedBox(
    height: 25,
  );
  bool _numberInputIsValid = true;
  int valueIndexColor = 0;
  int valueIndexSize = 0;

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  double? _precio;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_updateTotal);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _updateTotal() {
    final String quantityText = _quantityController.text.trim();
    final double quantity = double.tryParse(quantityText) ?? 0.0;

    // Si _precio no es nulo y la cantidad es válida, calculamos el total
    if (_precio != null && quantity != null) {
      final double total = _precio! * quantity;

      // Actualizamos el valor del segundo TextField con el total
      _totalController.text =
          total.toStringAsFixed(2); // Formateamos el total a dos decimales
    }
  }

  double sizeDD(int index, Size size) {
    switch (index) {
      default:
        return (size.height * 0.04);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.store),
      //   onPressed: () => showModal(context),
      // ),
      appBar: AppBar(
        title: const Text("Detalla Producto"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _firestoreProductsService
              .getProductById('Manteles redondos de tela blanca'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data != null) {
                Map<String, dynamic> productData = snapshot.data!;
                _precio = productData['precio'];
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      EspacioVertical,
                      Text(
                        productData['nombre'] ?? 'Sin nombre',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                        ),
                      ),
                      EspacioVertical,
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        top: size.height * 0.05,
                        right: sizeDD(valueIndexSize, size),
                        left: sizeDD(valueIndexSize, size),
                        child: Hero(
                          tag: productData['nombre'],
                          child: Image(
                            height: size.height * 0.3,
                            image: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/4642/4642411.png',
                              // productData['imagen'],
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Precio: \$${productData['precio'].toString()}' ??
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
                            const SizedBox(width: 30),
                            Expanded(
                              child: TextFormField(
                                controller: _totalController,
                                readOnly:
                                    true, // Hace que el TextField sea de solo lectura
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.attach_money),
                                  labelText:
                                      'Total de renta (multiplicado por 3)',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      EspacioVertical,
                      const Divider(),
                      EspacioVertical,
                      Text(
                        productData['descripcion'] ?? 'Sin descripción',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      EspacioVertical,
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              child: const Text('Rentar ahora')),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Agregar a carrito'),
                          )
                        ],
                      )
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
