import 'package:asistencia_upeu/apis/pago_api.dart';
import 'package:asistencia_upeu/modelo/PagoModelo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PagoForm extends StatefulWidget {
  @override
  _PagoFormState createState() => _PagoFormState();
}

class _PagoFormState extends State<PagoForm> {
  late String _metodoPago = "";
  late double _montoCambio = 0.0;
  late double _montoPagado = 0.0;
  late String _fecha = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fechaController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void capturaMetodoPago(String valor) {
    _metodoPago = valor;
  }

  void capturaMontoCambio(String valor) {
    _montoCambio = double.tryParse(valor) ?? 0.0;
  }

  void capturaMontoPagado(String valor) {
    _montoPagado = double.tryParse(valor) ?? 0.0;
  }

  void capturaFecha(String valor) {
    _fecha = valor;
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
        _fecha = DateFormat('yyyy-MM-dd').format(picked);
        _fechaController.text = _fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Formulario de Pago"),
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
                _buildDatoCadena(capturaMetodoPago, "Método de Pago:"),
                _buildDatoDecimal(capturaMontoCambio, "Monto de Cambio:"),
                _buildDatoDecimal(capturaMontoPagado, "Monto Pagado:"),
                _buildDatoFecha(capturaFecha, "Fecha:", _fechaController),

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

                            PagoModelo pago = PagoModelo(
                              id: 0, // Se establecerá automáticamente en el backend
                              metodoPago: _metodoPago,
                              montoCambio: _montoCambio,
                              montoPagado: _montoPagado,
                              fecha: _fecha,
                            );

                            var api = await Provider.of<PagoApi>(
                              context,
                              listen: false,
                            ).createPago(pago);
                            print("Pago creado: ${api.toJson()}");

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

  Widget _buildDatoDecimal(Function obtValor, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
