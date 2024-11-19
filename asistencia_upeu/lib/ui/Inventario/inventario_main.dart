
import 'package:asistencia_upeu/apis/inventario_api.dart';
import 'package:asistencia_upeu/ui/Inventario/inventario_edit.dart';
import 'package:asistencia_upeu/ui/Inventario/inventario_form.dart';
import 'package:flutter/material.dart';
import 'package:asistencia_upeu/modelo/InventarioModelo.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:asistencia_upeu/theme/AppTheme.dart';

class MainInventario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<InventarioApi>(create: (_) => InventarioApi.create(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
        theme: AppTheme.themeDataLight,
        darkTheme: AppTheme.themeDataDark,
        home: InventarioUI(),
      ),
    );
  }
}

class InventarioUI extends StatefulWidget {
  @override
  _InventarioUIState createState() => _InventarioUIState();
}

class _InventarioUIState extends State<InventarioUI> {
  late InventarioApi apiService;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late List<InventarioModelo> inventarioList = [];
  late List<InventarioModelo> inventarioFilteredList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
      apiService = InventarioApi.create();
      inventarioFilteredList.clear();
      Provider.of<InventarioApi>(context, listen: false)
          .getAllInventario()
          .then((data) {
        inventarioFilteredList = List.from(data);

        // Imprimir cada inventario en la consola
        for (var inventario in inventarioFilteredList) {
          print("ID: ${inventario.id}");
          print("Nombre: ${inventario.nombre}");
          print("Descripción: ${inventario.descripcion}");
          print("Categoría: ${inventario.categoria}");
          print("Cantidad en Stock: ${inventario.cantidadEnStock}");
          print("Precio: ${inventario.precio}");
          print("Fecha de Caducidad: ${inventario.fechaDeCaducidad}");
          print("Proveedor: ${inventario.proveedor}");
          print("Ubicación: ${inventario.ubicacion}");
          print("Código de Barras: ${inventario.codigoDeBarras}");
          print("Lote: ${inventario.lote}");
          print("Estado: ${inventario.estado}");
          print("----------");
        }
      });
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      inventarioList = List.from(inventarioFilteredList);
      _isLoading = false;
    });
    print("Data loaded");
  }

  String text = 'Inventario';
  String subject = '';
  List<String> fileNames = [];
  List<String> filePaths = [];

  Future onGoBack(dynamic value) async {
    setState(() {
      _loadData();
      print(value);
    });
  }

  final _controller = TextEditingController();

  void updateList(String value) {
    setState(() {
      inventarioList = inventarioFilteredList
          .where(
            (element) => element.nombre.toLowerCase().contains(
          value.toLowerCase(),
        ),
      )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Inventario',
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                print("Buscar inventario");
              },
              child: Icon(
                Icons.store,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                print("Agregar inventario");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventarioForm()),
                ).then(onGoBack);
              },
              child: Icon(Icons.add_box_sharp),
            ),
          )
        ],
      ),
      backgroundColor: AppTheme.nearlyWhite,
      body: _isLoading ? Center(child: CircularProgressIndicator()) : _buildListView(context),
    );
  }

  Widget _buildListView(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                onChanged: (value) => updateList(value),
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Buscar Inventario...",
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear_sharp,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _controller.clear();
                        updateList(_controller.value.text);
                      }
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: inventarioList.length,
                  itemBuilder: (context, index) {
                    InventarioModelo inventario = inventarioList[index];

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Card(
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  inventario.nombre,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      "Stock: ${inventario.cantidadEnStock}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "Precio: ${inventario.precio}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage("assets/imagen/logo.png"),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => InventarioFormEdit(model: inventario)
                                            ),
                                          ).then(onGoBack);
                                        }
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Confirmación"),
                                                  content: Text("¿Desea eliminar este inventario?"),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Cancelar'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                        child: Text('Aceptar'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                          final api = Provider.of<InventarioApi>(context, listen: false);
                                                          api.deleteInventario(inventario.id).then((_) {
                                                            _loadData();
                                                          });
                                                        }
                                                    )
                                                  ],
                                                );
                                              }
                                          );
                                        }
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
          ]),
        ),
      ],
    );
  }
}