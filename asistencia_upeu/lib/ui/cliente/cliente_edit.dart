import 'package:asistencia_upeu/apis/cliente_api.dart';
import 'package:asistencia_upeu/modelo/ClienteModelo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClienteFormEdit extends StatefulWidget {
  final ClienteModelo model;

  ClienteFormEdit({required this.model}) : super();

  @override
  _ClienteFormEditState createState() => _ClienteFormEditState(model: model);
}

class _ClienteFormEditState extends State<ClienteFormEdit> {
  final ClienteModelo model;
  _ClienteFormEditState({required this.model}) : super();

  late String _nombre = model.nombre;
  late String _correo = model.correo;
  late String _direccion = model.direccion;
  late String _telefono = model.telefono;

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
        title: const Text("Editar Cliente"),
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
                _buildDatoCadena(capturaNombre, _nombre, "Nombre del Cliente:"),
                _buildDatoCadena(capturaCorreo, _correo, "Correo Electrónico:"),
                _buildDatoCadena(capturaDireccion, _direccion, "Dirección:"),
                _buildDatoCadena(capturaTelefono, _telefono, "Teléfono:"),

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
                              id: model.id,
                              nombre: _nombre,
                              correo: _correo,
                              direccion: _direccion,
                              telefono: _telefono,
                            );

                            var api = await Provider.of<ClienteApi>(
                                context, listen: false)
                                .updateCliente(model.id, cliente);
                            print("Cliente actualizado: ${api.toJson()}");

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

  Widget _buildDatoCadena(Function obtValor, String _dato, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: _dato,
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
