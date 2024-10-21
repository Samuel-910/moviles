// Archivo: operacion_abstracta.dart
void main() {
  final calculadora = Calculadora();
  print('Suma: ${calculadora.suma(5, 3)}');
  print('Resta: ${calculadora.resta(5, 3)}');
  print('Multiplicación: ${calculadora.multiplicacion(5, 3)}');
}

abstract class Operacion {
  double suma(double a, double b);
  double resta(double a, double b);
  double multiplicacion(double a, double b);
}

class Calculadora implements Operacion {
  double suma(double a, double b) {
    return a + b;
  }

  double resta(double a, double b) {
    return a - b;
  }

  double multiplicacion(double a, double b) {
    return a * b;
  }
}
