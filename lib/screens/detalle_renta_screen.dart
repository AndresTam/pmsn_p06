import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pmsn_06/funcion/carrito_badges.dart';
import 'package:pmsn_06/screens/Registro_datos.dart';
import 'package:pmsn_06/services/firestore_alquiler_detail_service.dart';
import 'package:pmsn_06/services/firestore_alquiler_service.dart';
import 'package:pmsn_06/services/firestore_carrito_service.dart';
import 'package:pmsn_06/services/firestore_client_service.dart';
import 'package:pmsn_06/services/firestore_products_service.dart';

class DetalleRentaScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const DetalleRentaScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<DetalleRentaScreen> createState() => _DetalleRentaScreenState();
}

class _DetalleRentaScreenState extends State<DetalleRentaScreen> {
  final FirestoreProductService _firestoreProductsService =
      FirestoreProductService();
  final FirestoreClientService _firestoreService = FirestoreClientService();
  final FirestoreAlquilerService _firestoreAlquilerService =
      FirestoreAlquilerService();
  final FirestoreAlquilerDetailService _firestoreAlquilerDetailService =
      FirestoreAlquilerDetailService();
  final FirestoreCarritoService _firestoreCarritoService =
      FirestoreCarritoService();

  late Map<String, dynamic>
      product; // Cambié la inicialización para hacerla tardía (late)

  final EspacioVertical = const SizedBox(
    height: 25,
  );
  bool _numberInputIsValid = true;
  int valueIndexColor = 0;
  int valueIndexSize = 0;

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  double? _precio;
  double? _total; // Agrega una variable para almacenar el total
  String? IDCliente;
  String? IDProducto;
  String? NombreProdcuto;
  String? IDAlquiler;
  double? cantidad;

  @override
  void initState() {
    super.initState();
    product = widget
        .product; // Inicializa el producto con el valor pasado desde el widget
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

      setState(() {
        _total = total;
        _totalController.text = total.toStringAsFixed(2);
      });
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
                if (precioValue is String) {
                  if (precioValue.contains('.')) {
                    _precio = double.parse(precioValue);
                  } else {
                    _precio = int.parse(precioValue).toDouble();
                  }
                } else if (precioValue is double || precioValue is int) {
                  _precio = precioValue.toDouble();
                } else {
                  _precio =
                      0.0; // Valor predeterminado si no es String, double o int
                }
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      EspacioVertical,
                      Text(
                        productData['nombre'] ?? 'Sin nombre',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
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
                              productData['imagen'],
                            ),
                          ),
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
                            const SizedBox(width: 30),
                            Expanded(
                              child: TextFormField(
                                controller: _totalController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.attach_money),
                                  labelText: 'Total de renta',
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
                            onPressed: () {
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
                              // Obtener la cantidad del producto del controlador
                              final String quantityText =
                                  _quantityController.text.trim();
                              cantidad = double.tryParse(quantityText) ?? 0.0;

                              if (cantidad! <= 0) {
                                // Validar que la cantidad sea mayor que cero
                                ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                    type: ArtSweetAlertType.warning,
                                    title: "Error",
                                    text: "Ingrese una cantidad válida.",
                                  ),
                                );
                                return;
                              }

                              IDProducto = await _firestoreProductsService
                                  .getDocumentIdFromName(productData['nombre']);
                              // Crear el registro en el carrito
                              await _firestoreCarritoService.createCarrito(
                                IDProducto!,
                                productData['nombre'],
                                cantidad!,
                                _precio!,
                                _total!,
                              );

                              // Actualizar el estado para reflejar el cambio en la UI
                              setState(() {});

                              // Mostrar la alerta de éxito
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Producto añadido a carrito",
                                  text: "",
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
