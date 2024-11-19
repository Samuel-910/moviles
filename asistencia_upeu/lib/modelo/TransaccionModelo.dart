import 'package:floor/floor.dart';

@Entity(tableName: 'transaccion')
class TransaccionModelo {
  @primaryKey
  late int id;
  late String fechaTransaccion;
  late double montoTotal;

  @ColumnInfo(name: 'cliente_id')
  late int clienteId;

  @ColumnInfo(name: 'pago_id')
  late int pagoId;

  TransaccionModelo({
    required this.id,
    required this.fechaTransaccion,
    required this.montoTotal,
    required this.clienteId,
    required this.pagoId,
  });

  // Método para convertir de JSON a TransaccionModelo
  factory TransaccionModelo.fromJson(Map<String, dynamic> json) {
    return TransaccionModelo(
      id: json['id'] ?? 0,
      fechaTransaccion: json['fechaTransaccion'] ?? '',
      montoTotal: (json['montoTotal'] ?? 0).toDouble(),
      clienteId: json['cliente']['id'] ?? 0, // Acceso al id de cliente en el JSON anidado
      pagoId: json['pago']['id'] ?? 0,       // Acceso al id de pago en el JSON anidado
    );
  }

  // Método para convertir la instancia a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaTransaccion': fechaTransaccion,
      'montoTotal': montoTotal,
      'clienteId': clienteId,
      'pagoId': pagoId,
    };
  }
}
