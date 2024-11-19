import 'package:asistencia_upeu/apis/transaccion_api.dart';
import 'package:asistencia_upeu/modelo/TransaccionModelo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransaccionForm extends StatefulWidget {
  @override
  _TransaccionFormState createState() => _TransaccionFormState();
}

class _TransaccionFormState extends State<TransaccionForm> {
  late double _montoTotal = 0.0;
  late int _clienteId = 0;
  late int _pagoId = 0;
  late String _fechaTransaccion = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fechaController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
    _fechaTransaccion = valor;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _fechaTransaccion = DateFormat('yyyy-MM-dd').format(picked);
        _fechaController.text = _fechaTransaccion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Formulario de Transacción"),
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
                _buildDatoDecimal(capturaMontoTotal, "Monto Total:"),
                _buildDatoEntero(capturaClienteId, "ID Cliente:"),
                _buildDatoEntero(capturaPagoId, "ID Pago:"),
                _buildDatoFecha(capturaFechaTransaccion, "Fecha de Transacción:", _fechaController),

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
                              id: 0, // Se establecerá automáticamente en el backend
                              fechaTransaccion: _fechaTransaccion,
                              montoTotal: _montoTotal,
                              clienteId: _clienteId,
                              pagoId: _pagoId,
                            );

                            var api = await Provider.of<TransaccionApi>(
                              context,
                              listen: false,
                            ).createTransaccion(transaccion);
                            print("Transacción creada: ${api.toJson()}");

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

  Widget _buildDatoEntero(Function obtValor, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
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

  Widget _buildDatoDecimal(Function obtValor, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
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
