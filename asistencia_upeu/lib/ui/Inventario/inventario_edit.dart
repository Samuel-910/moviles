import 'package:asistencia_upeu/apis/inventario_api.dart';
import 'package:asistencia_upeu/comp/DropDownFormField.dart';
import 'package:asistencia_upeu/modelo/InventarioModelo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventarioFormEdit extends StatefulWidget {
  final InventarioModelo model;

  InventarioFormEdit({required this.model}) : super();

  @override
  _InventarioFormEditState createState() => _InventarioFormEditState(model: model);
}

class _InventarioFormEditState extends State<InventarioFormEdit> {
  final InventarioModelo model;
  _InventarioFormEditState({required this.model}) : super();

  late String _nombre = model.nombre;
  late String _codigoDeBarras = model.codigoDeBarras;
  late int _cantidadEnStock = model.cantidadEnStock;
  late double _precio = model.precio;
  late String _descripcion = model.descripcion; // Nuevo campo de descripción
  late String _lote = model.lote; // Nuevo campo de lote

  TextEditingController _fechaDeCaducidad = TextEditingController();
  DateTime? selectedDate;

  late String _estado = model.estado;
  late String _categoria = model.categoria;
  late String _proveedor = model.proveedor;
  late String _ubicacion = model.ubicacion;

  List<Map<String, String>> listaEstado = [
    {'value': 'A', 'display': 'Activo'},
    {'value': 'D', 'display': 'Desactivo'}
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fechaDeCaducidad.text = model.fechaDeCaducidad;
  }

  void capturaNombre(valor) { this._nombre = valor; }
  void capturaCodigoDeBarras(valor) { this._codigoDeBarras = valor; }
  void capturaCantidadEnStock(valor) { this._cantidadEnStock = int.parse(valor); }
  void capturaPrecio(valor) { this._precio = double.parse(valor); }
  void capturaDescripcion(valor) { this._descripcion = valor; } // Captura de descripción
  void capturaLote(valor) { this._lote = valor; } // Captura de lote
  void capturaFechaDeCaducidad(valor) { this._fechaDeCaducidad.text = valor; }
  void capturaEstado(valor) { this._estado = valor; }
  void capturaCategoria(valor) { this._categoria = valor; }
  void capturaProveedor(valor) { this._proveedor = valor; }
  void capturaUbicacion(valor) { this._ubicacion = valor; }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Editar Inventario"),
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
                _buildDatoCadena(capturaNombre, _nombre, "Nombre del Producto:"),
                _buildDatoCadena(capturaCodigoDeBarras, _codigoDeBarras, "Código de Barras:"),
                _buildDatoEntero(capturaCantidadEnStock, _cantidadEnStock.toString(), "Cantidad en Stock:"),
                _buildDatoDecimal(capturaPrecio, _precio.toString(), "Precio:"),
                _buildDatoFecha(capturaFechaDeCaducidad, "Fecha de Caducidad"),
                _buildDatoCadena(capturaCategoria, _categoria, "Categoría:"),
                _buildDatoCadena(capturaProveedor, _proveedor, "Proveedor:"),
                _buildDatoCadena(capturaUbicacion, _ubicacion, "Ubicación:"),
                _buildDatoCadena(capturaDescripcion, _descripcion, "Descripción:"), // Campo de descripción
                _buildDatoCadena(capturaLote, _lote, "Lote:"), // Campo de lote
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
                              id: model.id,
                              nombre: _nombre,
                              codigoDeBarras: _codigoDeBarras,
                              cantidadEnStock: _cantidadEnStock,
                              precio: _precio,
                              fechaDeCaducidad: _fechaDeCaducidad.text,
                              categoria: _categoria,
                              proveedor: _proveedor,
                              ubicacion: _ubicacion,
                              estado: _estado,
                              descripcion: _descripcion, // Incluye descripción
                              lote: _lote, // Incluye lote
                            );

                            var api = await Provider.of<InventarioApi>(
                                context, listen: false)
                                .updateInventario(model.id, inventario);
                            print("Inventario actualizado: ${api.toJson()}");

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
