import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
@Entity(tableName: 'inventario')
class InventarioModelo {
  @primaryKey
  late int id;
  late int cantidadEnStock;
  late String categoria;
  late String codigoDeBarras;
  late String descripcion;
  late String estado;
  late String fechaDeCaducidad;
  late String lote;
  late String nombre;
  late double precio;
  late String proveedor;
  late String ubicacion;

  InventarioModelo({
    required this.id,
    required this.cantidadEnStock,
    required this.categoria,
    required this.codigoDeBarras,
    required this.descripcion,
    required this.estado,
    required this.fechaDeCaducidad,
    required this.lote,
    required this.nombre,
    required this.precio,
    required this.proveedor,
    required this.ubicacion,
  });

  // Constructor vacío
  InventarioModelo.unlaunched();

  // Constructor desde JSON
  InventarioModelo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    cantidadEnStock = json['cantidadEnStock'] ?? 0;
    categoria = json['categoria'] ?? '';
    codigoDeBarras = json['codigoDeBarras'] ?? '';
    descripcion = json['descripcion'] ?? '';
    estado = json['estado'] ?? '';
    fechaDeCaducidad = json['fechaDeCaducidad'] ?? '';
    lote = json['lote'] ?? '';
    nombre = json['nombre'] ?? '';
    precio = (json['precio'] ?? 0).toDouble();
    proveedor = json['proveedor'] ?? '';
    ubicacion = json['ubicacion'] ?? '';
  }

  // Método factory para crear desde JSON usando json_serializable
  factory InventarioModelo.fromJsonModelo(Map<String, dynamic> json) {
    return InventarioModelo(
      id: json['id'] ?? 0,
      cantidadEnStock: json['cantidadEnStock'] ?? 0,
      categoria: json['categoria'] ?? '',
      codigoDeBarras: json['codigoDeBarras'] ?? '',
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? '',
      fechaDeCaducidad: json['fechaDeCaducidad'] ?? '',
      lote: json['lote'] ?? '',
      nombre: json['nombre'] ?? '',
      precio: (json['precio'] ?? 0).toDouble(),
      proveedor: json['proveedor'] ?? '',
      ubicacion: json['ubicacion'] ?? '',
    );
  }

  // Constructor desde JSON local (por compatibilidad con formatos alternativos)
  InventarioModelo.fromJsonLocal(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    cantidadEnStock = json['cantidadEnStock'] ?? 0;
    categoria = json['categoria'] ?? '';
    codigoDeBarras = json['codigoDeBarras'] ?? '';
    descripcion = json['descripcion'] ?? '';
    estado = json['estado'] ?? '';
    fechaDeCaducidad = json['fechaDeCaducidad'] ?? '';
    lote = json['lote'] ?? '';
    nombre = json['nombre'] ?? '';
    precio = (json['precio'] ?? 0).toDouble();
    proveedor = json['proveedor'] ?? '';
    ubicacion = json['ubicacion'] ?? '';
  }

  // Método para convertir a JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['cantidadEnStock'] = cantidadEnStock;
    data['categoria'] = categoria;
    data['codigoDeBarras'] = codigoDeBarras;
    data['descripcion'] = descripcion;
    data['estado'] = estado;
    data['fechaDeCaducidad'] = fechaDeCaducidad;
    data['lote'] = lote;
    data['nombre'] = nombre;
    data['precio'] = precio;
    data['proveedor'] = proveedor;
    data['ubicacion'] = ubicacion;
    return data;
  }
}
