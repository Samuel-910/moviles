// Archivo: operacion_clase_base.dart
void main() {
  final calculadoraAvanzada = CalculadoraAvanzada();
  print('Suma: ${calculadoraAvanzada.suma(8, 2)}');
  print('Resta: ${calculadoraAvanzada.resta(8, 2)}');
  print('Multiplicación: ${calculadoraAvanzada.multiplicacion(8, 2)}');
  print('División: ${calculadoraAvanzada.division(8, 2)}');
}

class Operacion {
  double suma(double a, double b) => a + b;
  double resta(double a, double b) => a - b;
  double multiplicacion(double a, double b) => a * b;
}

class CalculadoraAvanzada extends Operacion {
  double division(double a, double b) {
    if (b == 0) {
      throw Exception('No se puede dividir por cero');
    }
    return a / b;
  }
}
