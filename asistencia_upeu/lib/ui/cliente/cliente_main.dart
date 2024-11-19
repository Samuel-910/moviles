import 'package:asistencia_upeu/apis/cliente_api.dart';
import 'package:asistencia_upeu/ui/cliente/cliente_edit.dart';
import 'package:asistencia_upeu/ui/cliente/cliente_form.dart';
import 'package:flutter/material.dart';
import 'package:asistencia_upeu/modelo/ClienteModelo.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:asistencia_upeu/theme/AppTheme.dart';

class MainCliente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ClienteApi>(create: (_) => ClienteApi.create(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
        theme: AppTheme.themeDataLight,
        darkTheme: AppTheme.themeDataDark,
        home: ClienteUI(),
      ),
    );
  }
}

class ClienteUI extends StatefulWidget {
  @override
  _ClienteUIState createState() => _ClienteUIState();
}

class _ClienteUIState extends State<ClienteUI> {
  late ClienteApi apiService;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  late List<ClienteModelo> clienteList = [];
  late List<ClienteModelo> clienteFilteredList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
      apiService = ClienteApi.create();
      clienteFilteredList.clear();
      Provider.of<ClienteApi>(context, listen: false)
          .getAllClientes()
          .then((data) {
        clienteFilteredList = List.from(data);

        // Imprimir cada cliente en la consola
        for (var cliente in clienteFilteredList) {
          print("ID: ${cliente.id}");
          print("Nombre: ${cliente.nombre}");
          print("Correo: ${cliente.correo}");
          print("Dirección: ${cliente.direccion}");
          print("Teléfono: ${cliente.telefono}");
          print("----------");
        }
      });
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      clienteList = List.from(clienteFilteredList);
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
      clienteList = clienteFilteredList
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
          'Lista de Clientes',
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                print("Agregar cliente");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClienteForm()),
                ).then(onGoBack);
              },
              child: Icon(Icons.person_add),
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
                  hintText: "Buscar Cliente...",
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
                  itemCount: clienteList.length,
                  itemBuilder: (context, index) {
                    ClienteModelo cliente = clienteList[index];

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
                                  cliente.nombre,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                subtitle: Text(
                                  "Correo: ${cliente.correo}\nTeléfono: ${cliente.telefono}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage("assets/imagen/man-icon.png"),
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
                                                builder: (context) => ClienteFormEdit(model: cliente)
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
                                                content: Text("¿Desea eliminar este cliente?"),
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
                                                      final api = Provider.of<ClienteApi>(context, listen: false);

                                                      api.deleteCliente(cliente.id).then((_) {
                                                        print("Cliente eliminado exitosamente");
                                                        _loadData(); // Recargar la lista de clientes
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Cliente eliminado exitosamente')),
                                                        );
                                                      }).catchError((error) {
                                                        print("Error al eliminar cliente: $error");
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Error al eliminar cliente')),
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
