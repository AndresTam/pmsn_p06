import 'package:flutter/material.dart';
import 'package:pmsn_06/screens/Registro_datos.dart';
import 'package:pmsn_06/services/firestore_carrito_service.dart';

class CarritoScreen extends StatelessWidget {
  final FirestoreCarritoService _firestoreCarritoService =
      FirestoreCarritoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: Container(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _firestoreCarritoService.getcarrito(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error al cargar los productos'),
              );
            }
            List<Map<String, dynamic>> carrito = snapshot.data!;
            double total = 0;
            for (var item in carrito) {
              total += item['precioUnitario'] * item['cantidad'];
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: carrito.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var carritoo = carrito[index];
                          return ListTile(
                            title: Text(carritoo['nombreProducto'].toString()),
                            subtitle: Text(
                                "Cantidad: ${carritoo['cantidad'].toString()} \nTotal: ${carritoo['subtotal']}"),
                            trailing: Text(
                                "Precio por Unidad: ${carritoo['precioUnitario'].toString()}"),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistroDatosScreen(
                              product: {
                                'carrito': carrito, // Pasar todo el carrito
                                'total': total,
                              },
                              total: total,
                              longitud: carrito.length,
                            ),
                          ),
                        );
                      },
                      child: const Text('Rentar ahora'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
