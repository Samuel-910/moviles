import 'package:asistencia_upeu/modelo/InventarioModelo.dart';
import 'package:floor/floor.dart';


@dao
abstract class InventarioDao {
  // Obtener todos los productos del inventario
  @Query('SELECT * FROM inventario')
  Future<List<InventarioModelo>> findAllInventario();

  // Obtener el nombre de todos los productos del inventario
  @Query('SELECT nombre FROM inventario')
  Stream<List<String>> findAllInventarioName();

  // Obtener un producto del inventario por id
  @Query('SELECT * FROM inventario WHERE id = :id')
  Stream<InventarioModelo?> findInventarioById(int id);

  // Insertar un producto en el inventario
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertInventario(InventarioModelo inventario);

  // Insertar múltiples productos en el inventario
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllInventario(List<InventarioModelo> inventarios);

  // Actualizar un producto del inventario
  @update
  Future<void> updateInventario(InventarioModelo inventario);

  // Eliminar un producto del inventario por id
  @Query("DELETE FROM inventario WHERE id = :id")
  Future<void> deleteInventario(int id);

  // Eliminar múltiples productos del inventario
  @delete
  Future<void> deleteAllInventarios(List<InventarioModelo> inventarios);

  // Obtener el id máximo de los productos
  @Query("SELECT MAX(id) FROM inventario")
  Future<int?> getMaxId();
}
