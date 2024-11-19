import 'package:floor/floor.dart';
import 'package:asistencia_upeu/modelo/ClienteModelo.dart';

@dao
abstract class ClienteDao {
  @Query('SELECT * FROM cliente')
  Future<List<ClienteModelo>> getAllClientes();

  @Query('SELECT * FROM cliente WHERE id = :id')
  Future<ClienteModelo?> getClienteById(int id);

  @insert
  Future<void> insertCliente(ClienteModelo cliente);

  @update
  Future<void> updateCliente(ClienteModelo cliente);

  @delete
  Future<void> deleteCliente(ClienteModelo cliente);
}
