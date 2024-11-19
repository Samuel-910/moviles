import 'package:floor/floor.dart';
import 'package:asistencia_upeu/modelo/TransaccionModelo.dart';

@dao
abstract class TransaccionDao {
  @Query('SELECT * FROM transaccion')
  Future<List<TransaccionModelo>> getAllTransacciones();

  @Query('SELECT * FROM transaccion WHERE id = :id')
  Future<TransaccionModelo?> getTransaccionById(int id);

  @insert
  Future<void> insertTransaccion(TransaccionModelo transaccion);

  @update
  Future<void> updateTransaccion(TransaccionModelo transaccion);

  @delete
  Future<void> deleteTransaccion(TransaccionModelo transaccion);
}
