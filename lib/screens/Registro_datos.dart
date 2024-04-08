import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pmsn_06/services/firestore_alquiler_detail_service.dart';
import 'package:pmsn_06/services/firestore_alquiler_service.dart';
import 'package:pmsn_06/services/firestore_client_service.dart';
import 'package:pmsn_06/services/firestore_products_service.dart';

class RegistroDatosScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final dynamic total;

  const RegistroDatosScreen(
      {Key? key, required this.product, required this.total})
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
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

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
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.person),
                  labelText: 'Nombres',
                ),
                onSaved: (String? value) {
                  this._name = value;
                  print('name=$_name');
                },
                validator: _validateName,
              ),
              SeparacionVertical,
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.person_add_alt_1),
                  labelText: 'Apellidos',
                ),
                onSaved: (String? value) {
                  this._apellidos = value;
                  print('name=$_apellidos');
                },
                validator: _validateName,
              ),
              SeparacionVertical,
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.phone),
                  labelText: 'Número de Teléfono',
                  prefixText: '+52 ',
                ),
                keyboardType: TextInputType.phone,
                onSaved: (String? value) {
                  this._phoneNumber = value;
                  print('phoneNumber=$_phoneNumber');
                },
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SeparacionVertical,
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  icon: Icon(Icons.email),
                  hintText: 'ejemplo@dominio.com',
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
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
                "${widget.product['nombre']}",
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

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      conFechaDevolucion.text = formattedDate;
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
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Crear cliente
                    _firestoreService.createClient(
                      _name!,
                      _apellidos!,
                      _address ?? '',
                      _phoneNumber!,
                      _email!,
                      '',
                    );

                    // Obtener ID del cliente
                    IDCliente = await _firestoreService.getDocumentIdFromName(
                      _name!,
                      _apellidos!,
                    );

                    print(IDCliente);

                    // Obtener ID del producto
                    NombreProdcuto = widget.product['nombre'].toString();
                    print(NombreProdcuto);

                    IDProducto = await _firestoreProductService
                        .getDocumentIdFromName(NombreProdcuto!);
                    print(IDProducto);
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
                    int cantidad = widget.product['precio'] / widget.total;
                    // Crear detalle de alquiler
                    _firestoreAlquilerDetailService.createAlquilerDetail(
                      IDAlquiler!,
                      IDProducto!,
                      cantidad, // Cantidad
                      widget.total, // Precio unitario
                      widget.total, // Subtotal
                    );
                    ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                          type: ArtSweetAlertType.danger,
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
                  // // Navegar a la pantalla de éxito
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => RentaExitoScreen(),
                  // ));
                },
                child: const Text('Rentar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  NombreProdcuto = widget.product['nombre'].toString();
                  double cantidad = widget.total / widget.product['precio'];
                  print(NombreProdcuto);
                  print(cantidad);
                  IDProducto = await _firestoreProductService
                      .getDocumentIdFromName(NombreProdcuto!);
                  print('dasdsa ${IDProducto}');
                },
                child: const Text('Rentar2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
