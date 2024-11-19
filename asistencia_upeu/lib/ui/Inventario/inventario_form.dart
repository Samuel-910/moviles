import 'package:asistencia_upeu/apis/inventario_api.dart';
import 'package:asistencia_upeu/comp/DropDownFormField.dart';
import 'package:asistencia_upeu/modelo/InventarioModelo.dart';
import 'package:asistencia_upeu/util/TokenUtil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventarioForm extends StatefulWidget {
  @override
  _InventarioFormState createState() => _InventarioFormState();
}

class _InventarioFormState extends State<InventarioForm> {

  late String _nombre = "";
  late String _codigoDeBarras = "";
  late int _cantidadEnStock = 0;
  late double _precio = 0.0;
  late String _lote = "";
  late String _descripcion = "";

  TextEditingController _fechaDeCaducidad = TextEditingController();
  DateTime? selectedDate;

  late String _estado = "D";
  late String _categoria = "";
  late String _proveedor = "";
  late String _ubicacion = "";

  List<Map<String, String>> listaEstado = [
    {'value': 'A', 'display': 'Activo'},
    {'value': 'D', 'display': 'Desactivo'}
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _controllerCantidadEnStock = TextEditingController();
  final TextEditingController _controllerPrecio = TextEditingController();
  final TextEditingController _loteController = TextEditingController();

  void capturaNombre(valor) { this._nombre = valor; }
  void capturaCodigoDeBarras(valor) { this._codigoDeBarras = valor; }
  void capturaCantidadEnStock(valor) { this._cantidadEnStock = int.parse(valor); }
  void capturaPrecio(valor) { this._precio = double.parse(valor); }
  void capturaFechaDeCaducidad(valor) { this._fechaDeCaducidad.text = valor; }
  void capturaEstado(valor) { this._estado = valor; }
  void capturaCategoria(valor) { this._categoria = valor; }
  void capturaProveedor(valor) { this._proveedor = valor; }
  void capturaUbicacion(valor) { this._ubicacion = valor; }
  void capturaLote(valor) { this._lote = valor; }
  void capturaDescripcion(valor) { this._descripcion = valor; }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Formulario de Inventario"),
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
                _buildDatoCadena(capturaNombre, "Nombre del Producto:"),
                _buildDatoCadena(capturaCodigoDeBarras, "Código de Barras:"),
                _buildDatoEntero(capturaCantidadEnStock, "Cantidad en Stock:"),
                _buildDatoDecimal(capturaPrecio, "Precio:"),
                _buildDatoFecha(capturaFechaDeCaducidad, "Fecha de Caducidad"),
                _buildDatoCadena(capturaCategoria, "Categoría:"),
                _buildDatoCadena(capturaProveedor, "Proveedor:"),
                _buildDatoCadena(capturaUbicacion, "Ubicación:"),
                _buildDatoCadena(capturaLote, "Lote:"),
                _buildDatoCadena(capturaDescripcion, "Descripción:"),
                _buildDatoLista(capturaEstado, _estado, "Estado:", listaEstado),

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

                            InventarioModelo inventario = InventarioModelo(
                              id: 0, // Se establecerá automáticamente en el backend
                              nombre: _nombre,
                              codigoDeBarras: _codigoDeBarras,
                              cantidadEnStock: _cantidadEnStock,
                              precio: _precio,
                              fechaDeCaducidad: _fechaDeCaducidad.text,
                              categoria: _categoria,
                              proveedor: _proveedor,
                              ubicacion: _ubicacion,
                              estado: _estado,
                              descripcion: _descripcion,
                              lote: _lote, // Añadir lote aquí
                            );

                            var api = await Provider.of<InventarioApi>(
                                context, listen: false)
                                .createInventario(inventario);
                            print("Inventario creado: ${api.toJson()}");

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
      controller: _controllerCantidadEnStock,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
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
      controller: _controllerPrecio,
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

  Widget _buildDatoLista(Function obtValor, _dato, String label, List<dynamic> listaDato) {
    return DropDownFormField(
      titleText: label,
      hintText: 'Seleccione',
      value: _dato,
      onSaved: (value) {
        setState(() {
          obtValor(value);
        });
      },
      onChanged: (value) {
        setState(() {
          obtValor(value);
        });
      },
      dataSource: listaDato,
      textField: 'display',
      valueField: 'value',
    );
  }

  Future<void> _selectDate(BuildContext context, Function obtValor) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        obtValor(selectedDate.toString());
      });
    }
  }

  Widget _buildDatoFecha(Function obtValor, String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: _fechaDeCaducidad,
      keyboardType: TextInputType.datetime,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Este campo es requerido';
        }
        return null;
      },
      onTap: () {
        _selectDate(context, obtValor);
      },
      onSaved: (String? value) {
        obtValor(value!);
      },
    );
  }
}
