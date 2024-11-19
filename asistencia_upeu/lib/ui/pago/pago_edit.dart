import 'package:asistencia_upeu/apis/pago_api.dart';
import 'package:asistencia_upeu/modelo/PagoModelo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PagoFormEdit extends StatefulWidget {
  final PagoModelo model;

  PagoFormEdit({required this.model}) : super();

  @override
  _PagoFormEditState createState() => _PagoFormEditState(model: model);
}

class _PagoFormEditState extends State<PagoFormEdit> {
  final PagoModelo model;
  _PagoFormEditState({required this.model}) : super();

  late String _metodoPago = model.metodoPago;
  late double _montoCambio = model.montoCambio;
  late double _montoPagado = model.montoPagado;
  late String _fecha = model.fecha;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fechaController.text = _fecha; // Setear el valor inicial de fecha como String
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
    _fecha = valor; // Guardar la fecha como String
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_fecha) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _fecha = DateFormat('yyyy-MM-dd').format(picked); // Convertir a String en formato 'yyyy-MM-dd'
        _fechaController.text = _fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Editar Pago"),
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
                _buildDatoCadena(capturaMetodoPago, _metodoPago, "Método de Pago:"),
                _buildDatoDecimal(capturaMontoCambio, _montoCambio.toString(), "Monto de Cambio:"),
                _buildDatoDecimal(capturaMontoPagado, _montoPagado.toString(), "Monto Pagado:"),
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
                              id: model.id,
                              metodoPago: _metodoPago,
                              montoCambio: _montoCambio,
                              montoPagado: _montoPagado,
                              fecha: _fecha, // Guardar como String
                            );

                            var api = await Provider.of<PagoApi>(
                              context,
                              listen: false,
                            ).updatePago(model.id, pago);
                            print("Pago actualizado: ${api.toJson()}");

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

  Widget _buildDatoDecimal(Function obtValor, String _dato, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: _dato,
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
