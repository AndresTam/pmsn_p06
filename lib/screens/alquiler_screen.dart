import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmsn_06/screens/alquiler_history_screen.dart';
import 'package:pmsn_06/screens/calendar_screen.dart';
import 'package:pmsn_06/services/firestore_alquiler_service.dart';

class AlquilerScreen extends StatelessWidget {
  const AlquilerScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final FirestoreAlquilerService firestoreAlquilerService = FirestoreAlquilerService();
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proximas Rentas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firestoreAlquilerService.getAlquiler(), // Obtener rentas pendientes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar las rentas'));
          }
          List<Map<String, dynamic>> rentasPendientes = snapshot.data!;
          List<Map<String, dynamic>> rentasFuturas = rentasPendientes.where((renta) {
            String fechaAlquilerString = renta['fechaAlquiler'];
            if (fechaAlquilerString.isNotEmpty) {
              DateTime fechaAlquiler = DateFormat('yyyy-MM-dd').parse(fechaAlquilerString);
              return !fechaAlquiler.isBefore(now); // Retorna true si la fecha de alquiler es hoy o en el futuro
            }
            return false;
          }).toList();

          return ListView.builder(
            itemCount: rentasFuturas.length,
            itemBuilder: (context, index) {
              var renta = rentasFuturas[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 241, 241),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarScreen()), // Navega a la pantalla de calendario
              );
            },
            child: const Icon(Icons.calendar_month),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlquilerHistoryScreen()), // Navega a la pantalla de calendario
              );
            },
            child: const Icon(Icons.history),
          ),
        ],
      ),
    );
  }
}