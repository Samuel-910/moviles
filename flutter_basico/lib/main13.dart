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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Página Principal')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push( context,
              MaterialPageRoute(
                builder: (context) => SecondPage(message: '¡Hola desde la página principal!'),
              ),
            );
          },
          child: Text('Ir a la Segunda Página'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final String message;
  SecondPage({required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Segunda Página')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar a la Página Principal'),
            ),
          ],
        ),
      ),
    );
  }
}

