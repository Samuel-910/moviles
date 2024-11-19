
import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
@Entity(tableName: 'pago')
class PagoModelo {
  @primaryKey
  late int id;
  late String metodoPago;
  late double montoCambio;
  late double montoPagado;

  late String fecha;

  PagoModelo({
    required this.id,
    required this.metodoPago,
    required this.montoCambio,
    required this.montoPagado,
    required this.fecha,
  });

  // Constructor desde JSON
  PagoModelo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    metodoPago = json['metodoPago'] ?? '';
    montoCambio = (json['montoCambio'] ?? 0).toDouble();
    montoPagado = (json['montoPagado'] ?? 0).toDouble();
    fecha = json['fecha'] ?? '';
  }

  // Método factory para crear desde JSON usando json_serializable
  factory PagoModelo.fromJsonModelo(Map<String, dynamic> json) {
    return PagoModelo(
      id: json['id'] ?? 0,
      metodoPago: json['metodoPago'] ?? '',
      montoCambio: (json['montoCambio'] ?? 0).toDouble(),
      montoPagado: (json['montoPagado'] ?? 0).toDouble(),
      fecha: json['fecha'] ?? '',
    );
  }
  // Constructor desde JSON local (por compatibilidad con formatos alternativos)
  PagoModelo.fromJsonLocal(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    metodoPago = json['metodoPago'] ?? '';
    montoCambio = (json['montoCambio'] ?? 0).toDouble();
    montoPagado = (json['montoPagado'] ?? 0).toDouble();
    fecha = json['fecha'] ?? '';
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['metodoPago'] = metodoPago;
    data['montoCambio'] = montoCambio;
    data['montoPagado'] = montoPagado;
    data['fecha'] = fecha;
    return data;
  }
}
