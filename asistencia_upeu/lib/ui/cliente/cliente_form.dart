import 'package:asistencia_upeu/apis/cliente_api.dart';
import 'package:asistencia_upeu/modelo/ClienteModelo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClienteForm extends StatefulWidget {
  @override
  _ClienteFormState createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {

  late String _nombre = "";
  late String _correo = "";
  late String _direccion = "";
  late String _telefono = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void capturaNombre(valor) { this._nombre = valor; }
  void capturaCorreo(valor) { this._correo = valor; }
  void capturaDireccion(valor) { this._direccion = valor; }
  void capturaTelefono(valor) { this._telefono = valor; }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Formulario de Cliente"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildDatoCadena(capturaNombre, "Nombre del Cliente:"),
                _buildDatoCadena(capturaCorreo, "Correo Electrónico:"),
                _buildDatoCadena(capturaDireccion, "Dirección:"),
                _buildDatoCadena(capturaTelefono, "Teléfono:"),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text('Cancelar')),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Procesando datos'),
                              ),
                            );
                            _formKey.currentState!.save();

                            ClienteModelo cliente = ClienteModelo(
                              id: 0, // Se establecerá automáticamente en el backend
                              nombre: _nombre,
                              correo: _correo,
                              direccion: _direccion,
                              telefono: _telefono,
                            );

                            var api = await Provider.of<ClienteApi>(
                                context, listen: false)
                                .createCliente(cliente);
                            print("Cliente creado: ${api.toJson()}");

                            if (api.toJson() != null) {
                              Navigator.pop(context, () {
                                setState(() {});
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Los datos del formulario no son válidos!'),
                              ),
                            );
                          }
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatoCadena(Function obtValor, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.text,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Este campo es requerido';
        }
        return null;
      },
      onSaved: (String? value) {
        obtValor(value!);
      },
    );
  }
}
