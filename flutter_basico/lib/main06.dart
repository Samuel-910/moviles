import 'package:flutter/material.dart';
void main() {
  runApp( MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isChecked = false;
  bool _switchValue = false;
  int _selectedValue = 1;
  double _sliderValue = 20.0;
  final List<Map<String, String>> _dropdownItems = [
  {'label': 'Opción A', 'value': '1'},
  {'label': 'Opción B', 'value': '2'},
  {'label': 'Opción C', 'value': '3'},
  ];
  String? _selectedValuea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkbox')),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                Text('Acepto los términos y condiciones'),
              ],
            ),
            Switch(
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                    });
                    print('Switch: $_switchValue');
                  },
                ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text('Opción 1'),
                  leading: Radio<int>(
                    value: 1,
                    groupValue: _selectedValue,
                    onChanged: (int? value) {
                      setState(() { _selectedValue = value!; });
                      print("Seleccionado: $_selectedValue");
                    },
                  ),
                ),
                ListTile(
                  title: Text('Opción 2'),
                  leading: Radio<int>(
                    value: 2,
                    groupValue: _selectedValue,
                    onChanged: (int? value) {
                      setState(() {_selectedValue = value!; });
                      print("Seleccionado: $_selectedValue");
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Slider(
                  value: _sliderValue,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: _sliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {_sliderValue = value;});
                    print("Valor: $_sliderValue");
                  },
                ),
                Text('Valor seleccionado: ${_sliderValue.round()}'),
              ],
            ),
            DropdownButton<String>(
              value: _selectedValuea, // El valor seleccionado
              hint: Text('Seleccione una opción'), // Texto inicial
              items: _dropdownItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'], // Asigna el valor del Map
                  child: Text(item['label']!), // Muestra la etiqueta
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValuea = newValue!;
                });
                print('Valor seleccionado: $_selectedValue'); // Imprime el valor
              },
            ),
          ],
        ),
      ),
    );
  }

}