import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
@Entity(tableName: 'cliente')
class ClienteModelo {
  @primaryKey
  late int id;
  late String correo;
  late String direccion;
  late String nombre;
  late String telefono;

  ClienteModelo({
    required this.id,
    required this.correo,
    required this.direccion,
    required this.nombre,
    required this.telefono,
  });

  // Constructor vacío
  ClienteModelo.unlaunched();

  // Constructor desde JSON
  ClienteModelo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    correo = json['correo'] ?? '';
    direccion = json['direccion'] ?? '';
    nombre = json['nombre'] ?? '';
    telefono = json['telefono'] ?? '';
  }

  // Método factory para crear desde JSON usando json_serializable
  factory ClienteModelo.fromJsonModelo(Map<String, dynamic> json) {
    return ClienteModelo(
      id: json['id'] ?? 0,
      correo: json['correo'] ?? '',
      direccion: json['direccion'] ?? '',
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }

  // Constructor desde JSON local (por compatibilidad con formatos alternativos)
  ClienteModelo.fromJsonLocal(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    correo = json['correo'] ?? '';
    direccion = json['direccion'] ?? '';
    nombre = json['nombre'] ?? '';
    telefono = json['telefono'] ?? '';
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['correo'] = correo;
    data['direccion'] = direccion;
    data['nombre'] = nombre;
    data['telefono'] = telefono;
    return data;
  }
}
