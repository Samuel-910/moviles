import 'package:asistencia_upeu/apis/transaccion_api.dart';
import 'package:asistencia_upeu/modelo/TransaccionModelo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransaccionFormEdit extends StatefulWidget {
  final TransaccionModelo model;

  TransaccionFormEdit({required this.model}) : super();

  @override
  _TransaccionFormEditState createState() => _TransaccionFormEditState(model: model);
}

class _TransaccionFormEditState extends State<TransaccionFormEdit> {
  final TransaccionModelo model;
  _TransaccionFormEditState({required this.model}) : super();

  late String _fechaTransaccion = model.fechaTransaccion;
  late double _montoTotal = model.montoTotal;
  late int _clienteId = model.clienteId;
  late int _pagoId = model.pagoId;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fechaController.text = _fechaTransaccion; // Setear el valor inicial de fecha como String
  }

  void capturaMontoTotal(String valor) {
    _montoTotal = double.tryParse(valor) ?? 0.0;
  }

  void capturaClienteId(String valor) {
    _clienteId = int.tryParse(valor) ?? 0;
  }

  void capturaPagoId(String valor) {
    _pagoId = int.tryParse(valor) ?? 0;
  }

  void capturaFechaTransaccion(String valor) {
    _fechaTransaccion = valor; // Guardar la fecha como String
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_fechaTransaccion) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _fechaTransaccion = DateFormat('yyyy-MM-dd').format(picked); // Convertir a String en formato 'yyyy-MM-dd'
        _fechaController.text = _fechaTransaccion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Editar Transacción"),
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
                _buildDatoDecimal(capturaMontoTotal, _montoTotal.toString(), "Monto Total:"),
                _buildDatoEntero(capturaClienteId, _clienteId.toString(), "ID Cliente:"),
                _buildDatoEntero(capturaPagoId, _pagoId.toString(), "ID Pago:"),
                _buildDatoFecha(capturaFechaTransaccion, "Fecha Transacción:", _fechaController),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Procesando datos'),
                              ),
                            );
                            _formKey.currentState!.save();

                            TransaccionModelo transaccion = TransaccionModelo(
                              id: model.id,
                              fechaTransaccion: _fechaTransaccion,
                              montoTotal: _montoTotal,
                              clienteId: _clienteId,
                              pagoId: _pagoId,
                            );

                            var api = await Provider.of<TransaccionApi>(
                              context,
                              listen: false,
                            ).updateTransaccion(model.id, transaccion);
                            print("Transacción actualizada: ${api.toJson()}");

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

  Widget _buildDatoEntero(Function obtValor, String _dato, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: _dato,
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Este campo es requerido';
        }
        if (int.tryParse(value) == null) {
          return 'Ingrese un número válido';
        }
        return null;
      },
      onSaved: (String? value) {
        obtValor(value!);
      },
    );
  }

  Widget _buildDatoDecimal(Function obtValor, String _dato, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: _dato,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Este campo es requerido';
        }
        if (double.tryParse(value) == null) {
          return 'Ingrese un número válido';
        }
        return null;
      },
      onSaved: (String? value) {
        obtValor(value!);
      },
    );
  }

  Widget _buildDatoFecha(Function obtValor, String label, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      keyboardType: TextInputType.datetime,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Este campo es requerido';
        }
        return null;
      },
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        await _selectDate(context);
      },
      onSaved: (String? value) {
        obtValor(value!);
      },
    );
  }
}
