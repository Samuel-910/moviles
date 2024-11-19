import 'package:floor/floor.dart';
import 'package:asistencia_upeu/modelo/PagoModelo.dart';

@dao
abstract class PagoDao {
  @Query('SELECT * FROM pago')
  Future<List<PagoModelo>> getAllPagos();

  @Query('SELECT * FROM pago WHERE id = :id')
  Future<PagoModelo?> getPagoById(int id);

  @insert
  Future<void> insertPago(PagoModelo pago);

  @update
  Future<void> updatePago(PagoModelo pago);

  @delete
  Future<void> deletePago(PagoModelo pago);
}
