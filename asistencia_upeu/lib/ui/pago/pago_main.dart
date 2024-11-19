import 'package:asistencia_upeu/apis/pago_api.dart';
import 'package:asistencia_upeu/ui/pago/pago_edit.dart';
import 'package:asistencia_upeu/ui/pago/pago_form.dart';
import 'package:flutter/material.dart';
import 'package:asistencia_upeu/modelo/PagoModelo.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:asistencia_upeu/theme/AppTheme.dart';

class MainPago extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PagoApi>(create: (_) => PagoApi.create(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
        theme: AppTheme.themeDataLight,
        darkTheme: AppTheme.themeDataDark,
        home: PagoUI(),
      ),
    );
  }
}

class PagoUI extends StatefulWidget {
  @override
  _PagoUIState createState() => _PagoUIState();
}

class _PagoUIState extends State<PagoUI> {
  late PagoApi apiService;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late List<PagoModelo> pagoList = [];
  late List<PagoModelo> pagoFilteredList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
      apiService = PagoApi.create();
      pagoFilteredList.clear();
      Provider.of<PagoApi>(context, listen: false)
          .getAllPagos()
          .then((data) {
        pagoFilteredList = List.from(data);

        // Imprimir cada pago en la consola
        for (var pago in pagoFilteredList) {
          print("ID: ${pago.id}");
          print("Método de Pago: ${pago.metodoPago}");
          print("Monto de Cambio: ${pago.montoCambio}");
          print("Monto Pagado: ${pago.montoPagado}");
          print("Fecha: ${pago.fecha}");
          print("----------");
        }
      });
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      pagoList = List.from(pagoFilteredList);
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
      pagoList = pagoFilteredList
          .where(
            (element) => element.metodoPago.toLowerCase().contains(
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
          'Lista de Pagos',
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                print("Agregar pago");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PagoForm()),
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
                  hintText: "Buscar Pago...",
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
                  itemCount: pagoList.length,
                  itemBuilder: (context, index) {
                    PagoModelo pago = pagoList[index];

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
                                  "Método: ${pago.metodoPago}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Text(
                                  "Monto Pagado: ${pago.montoPagado}\nFecha: ${pago.fecha}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage("assets/imagen/money-icon.png"),
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
                                                builder: (context) => PagoFormEdit(model: pago)
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
                                                content: Text("¿Desea eliminar este pago?"),
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
                                                      final api = Provider.of<PagoApi>(context, listen: false);

                                                      api.deletePago(pago.id).then((_) {
                                                        print("Pago eliminado exitosamente");
                                                        _loadData(); // Recargar la lista de pagos
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Pago eliminado exitosamente')),
                                                        );
                                                      }).catchError((error) {
                                                        print("Error al eliminar pago: $error");
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Error al eliminar pago')),
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
          ]),
        ),
      ],
    );
  }
}
