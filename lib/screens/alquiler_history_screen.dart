import 'package:flutter/material.dart';
import 'package:pmsn_06/services/firestore_alquiler_service.dart';

class AlquilerHistoryScreen extends StatelessWidget {
  const AlquilerHistoryScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final FirestoreAlquilerService firestoreAlquilerService = FirestoreAlquilerService();
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Rentas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firestoreAlquilerService.getAlquiler(), // Obtener todas las rentas
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar las rentas'));
          }
          List<Map<String, dynamic>> rentasPendientes = snapshot.data!;

          // Ordenar las rentas por fecha de alquiler
          rentasPendientes.sort((a, b) {
            DateTime fechaAlquilerA = _parseDate(a['fechaAlquiler']);
            DateTime fechaAlquilerB = _parseDate(b['fechaAlquiler']);
            return fechaAlquilerA.compareTo(fechaAlquilerB);
          });

          return ListView.builder(
            itemCount: rentasPendientes.length,
            itemBuilder: (context, index) {
              var renta = rentasPendientes[index];
              DateTime fechaAlquiler = _parseDate(renta['fechaAlquiler']);

              Color color;
              if (_isSameDay(fechaAlquiler, now)) {
                color = Colors.orange; // Fecha actual
              } else if (fechaAlquiler.isBefore(now)) {
                color = Colors.red; // Fecha pasada
              } else {
                color = Colors.green; // Fecha futura
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Cliente: ${renta['idCliente']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Fecha de Alquiler: ${renta['fechaAlquiler']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Fecha de Devolucion: ${renta['fechaDevolucion']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Total: \$${renta['total']}'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  DateTime _parseDate(String dateString) {
    // Convertir la fecha a DateTime a las 00:00:00 horas para ignorar la hora
    DateTime parsedDate = DateTime.parse(dateString);
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
  }

  bool _isSameDay(DateTime dateA, DateTime dateB) {
    return dateA.year == dateB.year && dateA.month == dateB.month && dateA.day == dateB.day;
  }
}