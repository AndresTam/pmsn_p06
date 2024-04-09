import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pmsn_06/services/firestore_alquiler_detail_service.dart';
import 'package:pmsn_06/services/firestore_alquiler_service.dart';
import 'package:pmsn_06/services/firestore_carrito_service.dart';
import 'package:pmsn_06/services/firestore_client_service.dart';
import 'package:pmsn_06/services/firestore_products_service.dart';

class RegistroDatosScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final dynamic total;
  final dynamic longitud;

  const RegistroDatosScreen(
      {Key? key,
      required this.product,
      required this.total,
      required this.longitud})
      : super(key: key);

  @override
  State<RegistroDatosScreen> createState() => _RegistroDatosScreenState();
}

class _RegistroDatosScreenState extends State<RegistroDatosScreen> {
  final FirestoreClientService _firestoreService = FirestoreClientService();
  final FirestoreAlquilerService _firestoreAlquilerService =
      FirestoreAlquilerService();
  final FirestoreAlquilerDetailService _firestoreAlquilerDetailService =
      FirestoreAlquilerDetailService();
  final FirestoreProductService _firestoreProductService =
      FirestoreProductService();
  final FirestoreCarritoService _firestoreCarritoService =
      FirestoreCarritoService();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  // TextEditingController
  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();
  final direccionController = TextEditingController();
  final conFechaAlquiler = TextEditingController();
  final conFechaDevolucion = TextEditingController();
  final conDescripcion = TextEditingController();

  List<Widget> generatedWidgets = [];

  String? _name;
  String? _apellidos;
  String? _address;
  String? _phoneNumber;
  String? _email;
  String? _password;
  String? IDCliente;
  String? IDProducto;
  String? NombreProdcuto;
  String? IDAlquiler;
  double? cantidad;

  String? _validateName(String? value) {
    if (value?.isEmpty ?? false) {
      return 'Name is required.';
    }
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value!)) {
      return 'Please enter only alphabetical characters.';
    }
    return null;
  }

  String? _btn2SelectedVal;
  bool _numberInputIsValid = true;

  final SeparacionVertical = const SizedBox(height: 24.0);

  String? _validateDates(String? alquiler, String? devolucion) {
    if (alquiler == null || devolucion == null) return null;

    final alquilerDate = DateTime.tryParse(alquiler);
    final devolucionDate = DateTime.tryParse(devolucion);

    if (alquilerDate != null && devolucionDate != null) {
      if (devolucionDate.isBefore(alquilerDate)) {
        return 'La fecha de devolución no puede ser anterior a la fecha de alquiler';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Datos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Cliente',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SeparacionVertical,
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: nombreController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.person),
                  labelText: 'Nombres',
                ),
                validator: _validateName,
              ),
              SeparacionVertical,
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: apellidosController, // Agregar el controlador aquí
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.person_add_alt_1),
                  labelText: 'Apellidos',
                ),
                validator: _validateName,
              ),
              SeparacionVertical,
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: direccionController, // Agregar el controlador aquí
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.house),
                  labelText: 'Direccion',
                ),
                validator: _validateName,
              ),
              SeparacionVertical,
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: telefonoController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.phone),
                  labelText: 'Número de Teléfono',
                  prefixText: '+52 ',
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SeparacionVertical,
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.email),
                  hintText: 'ejemplo@dominio.com',
                  labelText: 'E-mail',
                ),
                onSaved: (String? value) {
                  this._email = value;
                  print('email=$_email');
                },
              ),
              SeparacionVertical,
              const Text(
                'Producto(s)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SeparacionVertical,
              Text(
                widget.longitud == 0
                    ? "${widget.product['nombre']}"
                    : "Cantidad de Productos: ${widget.longitud}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SeparacionVertical,
              Text(
                "Precio: \$ ${widget.total}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SeparacionVertical,
              TextFormField(
                controller: conFechaAlquiler,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha de alquiler',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      conFechaAlquiler.text = formattedDate;
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
              SeparacionVertical,
              TextFormField(
                controller: conFechaDevolucion,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha de devolución',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                  print(widget.product.length);

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      conFechaDevolucion.text = formattedDate;
                      print("fecha: ${conFechaDevolucion}");
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                validator: (value) => _validateDates(
                    conFechaAlquiler.text, value), // Validación de fechas
              ),
              SeparacionVertical,
              TextFormField(
                controller: conDescripcion,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  helperText: 'Agrega una pequeña descripción de la renta',
                  labelText: 'Descripción',
                ),
                maxLines: 3,
                maxLength: 300, // Limitar a 300 caracteres
              ),
              SeparacionVertical,
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Crear cliente
                    _firestoreService.createClient(
                      nombreController.text,
                      apellidosController.text,
                      direccionController.text,
                      telefonoController.text,
                      emailController.text,
                      '',
                    );

                    // Obtener ID del cliente
                    IDCliente = await _firestoreService.getDocumentIdFromName(
                      nombreController.text,
                      apellidosController.text,
                      direccionController.text,
                      telefonoController.text,
                      emailController.text,
                      '',
                    );

                    print(IDCliente);

                    // Crear alquiler
                    await _firestoreAlquilerService.createAlquiler(
                      IDCliente!,
                      conFechaAlquiler.text,
                      conFechaDevolucion.text,
                      widget.total,
                    );

                    // Obtener ID del alquiler
                    IDAlquiler = await _firestoreAlquilerService
                        .getDocumentId(IDCliente!);
                    print(IDAlquiler);
                    cantidad = widget.product['precio'] / widget.total;

                    // Crear detalle de alquiler
                    if (widget.longitud == 0) {
                      // Obtener ID del producto
                      NombreProdcuto = widget.product['nombre'].toString();
                      print(NombreProdcuto);
                      IDProducto = await _firestoreProductService
                          .getDocumentIdFromName(NombreProdcuto!);
                      print(IDProducto);
                      _firestoreAlquilerDetailService.createAlquilerDetail(
                        IDAlquiler!,
                        IDProducto!,
                        cantidad!, // Cantidad
                        widget.product['precio'], // Precio unitario
                        widget.total, // Subtotal
                      );
                    } else {
                      _firestoreCarritoService.copiarDatosSimilares(
                        "carrito",
                        "alquiler-detail",
                        IDAlquiler!,
                      );
                    }

                    ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                          type: ArtSweetAlertType.success,
                          title: "Renta Creada",
                          text: ""),
                    );
                  } catch (e) {
                    print('no se pudo crear');
                    ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                          type: ArtSweetAlertType.danger,
                          title: "Renta No Creada",
                          text: ""),
                    );
                  }
                },
                child: const Text('Rentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
