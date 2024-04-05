import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistroDatosScreen extends StatefulWidget {
  const RegistroDatosScreen({Key? key}) : super(key: key);

  @override
  State<RegistroDatosScreen> createState() => _RegistroDatosScreenState();
}

class _RegistroDatosScreenState extends State<RegistroDatosScreen> {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  static const menuItems = <String>[
    'One',
    'Two',
    'Three',
    'Four',
  ];
  final List<DropdownMenuItem<String>> _dropDownMenuItems = menuItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();
  final conFechaAlquiler = TextEditingController();
  final conFechaDevolucion = TextEditingController();
  List<Widget> generatedWidgets = [];
  String? _name;
  String? _phoneNumber;
  String? _email;
  String? _password;

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                this._name = value;
                print('name=$_name');
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: generatedWidgets.length,
              itemBuilder: (context, index) {
                return generatedWidgets[index];
              },
            ),
            SeparacionVertical,
            ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    generatedWidgets.add(
                      Column(
                        children: [
                          SeparacionVertical,
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton(
                              value: _btn2SelectedVal,
                              hint: const Row(
                                children: [
                                  Icon(Icons.shopping_cart),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Producto',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() => _btn2SelectedVal = newValue);
                                }
                              },
                              items: _dropDownMenuItems,
                              icon: const Icon(Icons.arrow_drop_down),
                              underline: const SizedBox(),
                            ),
                          ),
                          SeparacionVertical,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.format_list_numbered),
                                      labelText: 'Ingrese la cantidad:',
                                      errorText: _numberInputIsValid
                                          ? null
                                          : 'Ingrese un número entero!',
                                      border: UnderlineInputBorder(),
                                      filled: true,
                                    ),
                                    onChanged: (String val) {
                                      final v = int.tryParse(val);
                                      debugPrint('parsed value = $v');
                                      if (v == null) {
                                        setState(
                                            () => _numberInputIsValid = false);
                                      } else {
                                        setState(
                                            () => _numberInputIsValid = true);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Expanded(
                                  child: TextFormField(
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
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text('Agregar Producto'),
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
                // ...
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
                // ...
              },
            ),
            SeparacionVertical,
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                helperText: 'Agrega una pequeña descripción de la renta',
                labelText: 'Descripción',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
