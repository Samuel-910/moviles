import 'package:asistencia_upeu/apis/transaccion_api.dart';
import 'package:asistencia_upeu/ui/transaccion/transaccion_edit.dart';
import 'package:asistencia_upeu/ui/transaccion/transaccion_form.dart';
import 'package:flutter/material.dart';
import 'package:asistencia_upeu/modelo/TransaccionModelo.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:asistencia_upeu/theme/AppTheme.dart';

class MainTransaccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TransaccionApi>(create: (_) => TransaccionApi.create(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
        theme: AppTheme.themeDataLight,
        darkTheme: AppTheme.themeDataDark,
        home: TransaccionUI(),
      ),
    );
  }
}

class TransaccionUI extends StatefulWidget {
  @override
  _TransaccionUIState createState() => _TransaccionUIState();
}

class _TransaccionUIState extends State<TransaccionUI> {
  late TransaccionApi apiService;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late List<TransaccionModelo> transaccionList = [];
  late List<TransaccionModelo> transaccionFilteredList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
      apiService = TransaccionApi.create();
      transaccionFilteredList.clear();
      Provider.of<TransaccionApi>(context, listen: false)
          .getAllTransacciones()
          .then((data) {
        transaccionFilteredList = List.from(data);

        // Imprimir cada transacción en la consola
        for (var transaccion in transaccionFilteredList) {
          print("ID: ${transaccion.id}");
          print("Fecha de Transacción: ${transaccion.fechaTransaccion}");
          print("Monto Total: ${transaccion.montoTotal}");
          print("Cliente ID: ${transaccion.clienteId }");
          print("Pago ID: ${transaccion.pagoId}");
          print("----------");
        }
      });
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      transaccionList = List.from(transaccionFilteredList);
      _isLoading = false;
    });
    print("Data loaded");
  }

  Future onGoBack(dynamic value) async {
    setState(() {
      _loadData();
      print(value);
    });
  }

  final _controller = TextEditingController();

  void updateList(String value) {
    setState(() {
      transaccionList = transaccionFilteredList
          .where(
            (element) => element.fechaTransaccion.toLowerCase().contains(
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
          'Lista de Transacciones',
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                print("Agregar transacción");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransaccionForm()),
                ).then(onGoBack);
              },
              child: Icon(Icons.add_circle),
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
                  hintText: "Buscar Transacción...",
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
              child: SingleChildScrollView( // Añade el SingleChildScrollView aquí
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(), // Desactiva el desplazamiento del ListView
                    shrinkWrap: true,
                    itemCount: transaccionList.length,
                    itemBuilder: (context, index) {
                      TransaccionModelo transaccion = transaccionList[index];

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    "Fecha: ${transaccion.fechaTransaccion}",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  subtitle: Text(
                                    "Monto Total: ${transaccion.montoTotal}\nCliente ID: ${transaccion.clienteId}\nPago ID: ${transaccion.pagoId}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage("assets/imagen/transaction-icon.png"),
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
                                                  builder: (context) => TransaccionFormEdit(model: transaccion)
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
                                                  content: Text("¿Desea eliminar esta transacción?"),
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
                                                        final api = Provider.of<TransaccionApi>(context, listen: false);

                                                        api.deleteTransaccion(transaccion.id).then((_) {
                                                          print("Transacción eliminada exitosamente");
                                                          _loadData(); // Recargar la lista de transacciones
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text('Transacción eliminada exitosamente')),
                                                          );
                                                        }).catchError((error) {
                                                          print("Error al eliminar transacción: $error");
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text('Error al eliminar transacción')),
                                                          );
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                          );
                                        },
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
            ),
          ]),
        ),
      ],
    );
  }

}
