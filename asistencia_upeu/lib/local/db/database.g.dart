// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  InventarioDao? _inventarioDaoInstance;

  ClienteDao? _clienteDaoInstance;

  PagoDao? _pagoDaoInstance;

  TransaccionDao? _transaccionDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 6,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `inventario` (`id` INTEGER NOT NULL, `cantidadEnStock` INTEGER NOT NULL, `categoria` TEXT NOT NULL, `codigoDeBarras` TEXT NOT NULL, `descripcion` TEXT NOT NULL, `estado` TEXT NOT NULL, `fechaDeCaducidad` TEXT NOT NULL, `lote` TEXT NOT NULL, `nombre` TEXT NOT NULL, `precio` REAL NOT NULL, `proveedor` TEXT NOT NULL, `ubicacion` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `cliente` (`id` INTEGER NOT NULL, `correo` TEXT NOT NULL, `direccion` TEXT NOT NULL, `nombre` TEXT NOT NULL, `telefono` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `pago` (`id` INTEGER NOT NULL, `metodoPago` TEXT NOT NULL, `montoCambio` REAL NOT NULL, `montoPagado` REAL NOT NULL, `fecha` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `transaccion` (`id` INTEGER NOT NULL, `fechaTransaccion` TEXT NOT NULL, `montoTotal` REAL NOT NULL, `cliente_id` INTEGER NOT NULL, `pago_id` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  InventarioDao get inventarioDao {
    return _inventarioDaoInstance ??= _$InventarioDao(database, changeListener);
  }

  @override
  ClienteDao get clienteDao {
    return _clienteDaoInstance ??= _$ClienteDao(database, changeListener);
  }

  @override
  PagoDao get pagoDao {
    return _pagoDaoInstance ??= _$PagoDao(database, changeListener);
  }

  @override
  TransaccionDao get transaccionDao {
    return _transaccionDaoInstance ??=
        _$TransaccionDao(database, changeListener);
  }
}

class _$InventarioDao extends InventarioDao {
  _$InventarioDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _inventarioModeloInsertionAdapter = InsertionAdapter(
            database,
            'inventario',
            (InventarioModelo item) => <String, Object?>{
                  'id': item.id,
                  'cantidadEnStock': item.cantidadEnStock,
                  'categoria': item.categoria,
                  'codigoDeBarras': item.codigoDeBarras,
                  'descripcion': item.descripcion,
                  'estado': item.estado,
                  'fechaDeCaducidad': item.fechaDeCaducidad,
                  'lote': item.lote,
                  'nombre': item.nombre,
                  'precio': item.precio,
                  'proveedor': item.proveedor,
                  'ubicacion': item.ubicacion
                },
            changeListener),
        _inventarioModeloUpdateAdapter = UpdateAdapter(
            database,
            'inventario',
            ['id'],
            (InventarioModelo item) => <String, Object?>{
                  'id': item.id,
                  'cantidadEnStock': item.cantidadEnStock,
                  'categoria': item.categoria,
                  'codigoDeBarras': item.codigoDeBarras,
                  'descripcion': item.descripcion,
                  'estado': item.estado,
                  'fechaDeCaducidad': item.fechaDeCaducidad,
                  'lote': item.lote,
                  'nombre': item.nombre,
                  'precio': item.precio,
                  'proveedor': item.proveedor,
                  'ubicacion': item.ubicacion
                },
            changeListener),
        _inventarioModeloDeletionAdapter = DeletionAdapter(
            database,
            'inventario',
            ['id'],
            (InventarioModelo item) => <String, Object?>{
                  'id': item.id,
                  'cantidadEnStock': item.cantidadEnStock,
                  'categoria': item.categoria,
                  'codigoDeBarras': item.codigoDeBarras,
                  'descripcion': item.descripcion,
                  'estado': item.estado,
                  'fechaDeCaducidad': item.fechaDeCaducidad,
                  'lote': item.lote,
                  'nombre': item.nombre,
                  'precio': item.precio,
                  'proveedor': item.proveedor,
                  'ubicacion': item.ubicacion
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<InventarioModelo> _inventarioModeloInsertionAdapter;

  final UpdateAdapter<InventarioModelo> _inventarioModeloUpdateAdapter;

  final DeletionAdapter<InventarioModelo> _inventarioModeloDeletionAdapter;

  @override
  Future<List<InventarioModelo>> findAllInventario() async {
    return _queryAdapter.queryList('SELECT * FROM inventario',
        mapper: (Map<String, Object?> row) => InventarioModelo(
            id: row['id'] as int,
            cantidadEnStock: row['cantidadEnStock'] as int,
            categoria: row['categoria'] as String,
            codigoDeBarras: row['codigoDeBarras'] as String,
            descripcion: row['descripcion'] as String,
            estado: row['estado'] as String,
            fechaDeCaducidad: row['fechaDeCaducidad'] as String,
            lote: row['lote'] as String,
            nombre: row['nombre'] as String,
            precio: row['precio'] as double,
            proveedor: row['proveedor'] as String,
            ubicacion: row['ubicacion'] as String));
  }

  @override
  Stream<List<String>> findAllInventarioName() {
    return _queryAdapter.queryListStream('SELECT nombre FROM inventario',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'inventario',
        isView: false);
  }

  @override
  Stream<InventarioModelo?> findInventarioById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM inventario WHERE id = ?1',
        mapper: (Map<String, Object?> row) => InventarioModelo(
            id: row['id'] as int,
            cantidadEnStock: row['cantidadEnStock'] as int,
            categoria: row['categoria'] as String,
            codigoDeBarras: row['codigoDeBarras'] as String,
            descripcion: row['descripcion'] as String,
            estado: row['estado'] as String,
            fechaDeCaducidad: row['fechaDeCaducidad'] as String,
            lote: row['lote'] as String,
            nombre: row['nombre'] as String,
            precio: row['precio'] as double,
            proveedor: row['proveedor'] as String,
            ubicacion: row['ubicacion'] as String),
        arguments: [id],
        queryableName: 'inventario',
        isView: false);
  }

  @override
  Future<void> deleteInventario(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM inventario WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int?> getMaxId() async {
    return _queryAdapter.query('SELECT MAX(id) FROM inventario',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> insertInventario(InventarioModelo inventario) async {
    await _inventarioModeloInsertionAdapter.insert(
        inventario, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertAllInventario(List<InventarioModelo> inventarios) async {
    await _inventarioModeloInsertionAdapter.insertList(
        inventarios, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateInventario(InventarioModelo inventario) async {
    await _inventarioModeloUpdateAdapter.update(
        inventario, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAllInventarios(List<InventarioModelo> inventarios) async {
    await _inventarioModeloDeletionAdapter.deleteList(inventarios);
  }
}

class _$ClienteDao extends ClienteDao {
  _$ClienteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _clienteModeloInsertionAdapter = InsertionAdapter(
            database,
            'cliente',
            (ClienteModelo item) => <String, Object?>{
                  'id': item.id,
                  'correo': item.correo,
                  'direccion': item.direccion,
                  'nombre': item.nombre,
                  'telefono': item.telefono
                }),
        _clienteModeloUpdateAdapter = UpdateAdapter(
            database,
            'cliente',
            ['id'],
            (ClienteModelo item) => <String, Object?>{
                  'id': item.id,
                  'correo': item.correo,
                  'direccion': item.direccion,
                  'nombre': item.nombre,
                  'telefono': item.telefono
                }),
        _clienteModeloDeletionAdapter = DeletionAdapter(
            database,
            'cliente',
            ['id'],
            (ClienteModelo item) => <String, Object?>{
                  'id': item.id,
                  'correo': item.correo,
                  'direccion': item.direccion,
                  'nombre': item.nombre,
                  'telefono': item.telefono
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ClienteModelo> _clienteModeloInsertionAdapter;

  final UpdateAdapter<ClienteModelo> _clienteModeloUpdateAdapter;

  final DeletionAdapter<ClienteModelo> _clienteModeloDeletionAdapter;

  @override
  Future<List<ClienteModelo>> getAllClientes() async {
    return _queryAdapter.queryList('SELECT * FROM cliente',
        mapper: (Map<String, Object?> row) => ClienteModelo(
            id: row['id'] as int,
            correo: row['correo'] as String,
            direccion: row['direccion'] as String,
            nombre: row['nombre'] as String,
            telefono: row['telefono'] as String));
  }

  @override
  Future<ClienteModelo?> getClienteById(int id) async {
    return _queryAdapter.query('SELECT * FROM cliente WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ClienteModelo(
            id: row['id'] as int,
            correo: row['correo'] as String,
            direccion: row['direccion'] as String,
            nombre: row['nombre'] as String,
            telefono: row['telefono'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertCliente(ClienteModelo cliente) async {
    await _clienteModeloInsertionAdapter.insert(
        cliente, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCliente(ClienteModelo cliente) async {
    await _clienteModeloUpdateAdapter.update(cliente, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCliente(ClienteModelo cliente) async {
    await _clienteModeloDeletionAdapter.delete(cliente);
  }
}

class _$PagoDao extends PagoDao {
  _$PagoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _pagoModeloInsertionAdapter = InsertionAdapter(
            database,
            'pago',
            (PagoModelo item) => <String, Object?>{
                  'id': item.id,
                  'metodoPago': item.metodoPago,
                  'montoCambio': item.montoCambio,
                  'montoPagado': item.montoPagado,
                  'fecha': item.fecha
                }),
        _pagoModeloUpdateAdapter = UpdateAdapter(
            database,
            'pago',
            ['id'],
            (PagoModelo item) => <String, Object?>{
                  'id': item.id,
                  'metodoPago': item.metodoPago,
                  'montoCambio': item.montoCambio,
                  'montoPagado': item.montoPagado,
                  'fecha': item.fecha
                }),
        _pagoModeloDeletionAdapter = DeletionAdapter(
            database,
            'pago',
            ['id'],
            (PagoModelo item) => <String, Object?>{
                  'id': item.id,
                  'metodoPago': item.metodoPago,
                  'montoCambio': item.montoCambio,
                  'montoPagado': item.montoPagado,
                  'fecha': item.fecha
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PagoModelo> _pagoModeloInsertionAdapter;

  final UpdateAdapter<PagoModelo> _pagoModeloUpdateAdapter;

  final DeletionAdapter<PagoModelo> _pagoModeloDeletionAdapter;

  @override
  Future<List<PagoModelo>> getAllPagos() async {
    return _queryAdapter.queryList('SELECT * FROM pago',
        mapper: (Map<String, Object?> row) => PagoModelo(
            id: row['id'] as int,
            metodoPago: row['metodoPago'] as String,
            montoCambio: row['montoCambio'] as double,
            montoPagado: row['montoPagado'] as double,
            fecha: row['fecha'] as String));
  }

  @override
  Future<PagoModelo?> getPagoById(int id) async {
    return _queryAdapter.query('SELECT * FROM pago WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PagoModelo(
            id: row['id'] as int,
            metodoPago: row['metodoPago'] as String,
            montoCambio: row['montoCambio'] as double,
            montoPagado: row['montoPagado'] as double,
            fecha: row['fecha'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertPago(PagoModelo pago) async {
    await _pagoModeloInsertionAdapter.insert(pago, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePago(PagoModelo pago) async {
    await _pagoModeloUpdateAdapter.update(pago, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePago(PagoModelo pago) async {
    await _pagoModeloDeletionAdapter.delete(pago);
  }
}

class _$TransaccionDao extends TransaccionDao {
  _$TransaccionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _transaccionModeloInsertionAdapter = InsertionAdapter(
            database,
            'transaccion',
            (TransaccionModelo item) => <String, Object?>{
                  'id': item.id,
                  'fechaTransaccion': item.fechaTransaccion,
                  'montoTotal': item.montoTotal,
                  'cliente_id': item.clienteId,
                  'pago_id': item.pagoId
                }),
        _transaccionModeloUpdateAdapter = UpdateAdapter(
            database,
            'transaccion',
            ['id'],
            (TransaccionModelo item) => <String, Object?>{
                  'id': item.id,
                  'fechaTransaccion': item.fechaTransaccion,
                  'montoTotal': item.montoTotal,
                  'cliente_id': item.clienteId,
                  'pago_id': item.pagoId
                }),
        _transaccionModeloDeletionAdapter = DeletionAdapter(
            database,
            'transaccion',
            ['id'],
            (TransaccionModelo item) => <String, Object?>{
                  'id': item.id,
                  'fechaTransaccion': item.fechaTransaccion,
                  'montoTotal': item.montoTotal,
                  'cliente_id': item.clienteId,
                  'pago_id': item.pagoId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransaccionModelo> _transaccionModeloInsertionAdapter;

  final UpdateAdapter<TransaccionModelo> _transaccionModeloUpdateAdapter;

  final DeletionAdapter<TransaccionModelo> _transaccionModeloDeletionAdapter;

  @override
  Future<List<TransaccionModelo>> getAllTransacciones() async {
    return _queryAdapter.queryList('SELECT * FROM transaccion',
        mapper: (Map<String, Object?> row) => TransaccionModelo(
            id: row['id'] as int,
            fechaTransaccion: row['fechaTransaccion'] as String,
            montoTotal: row['montoTotal'] as double,
            clienteId: row['cliente_id'] as int,
            pagoId: row['pago_id'] as int));
  }

  @override
  Future<TransaccionModelo?> getTransaccionById(int id) async {
    return _queryAdapter.query('SELECT * FROM transaccion WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TransaccionModelo(
            id: row['id'] as int,
            fechaTransaccion: row['fechaTransaccion'] as String,
            montoTotal: row['montoTotal'] as double,
            clienteId: row['cliente_id'] as int,
            pagoId: row['pago_id'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertTransaccion(TransaccionModelo transaccion) async {
    await _transaccionModeloInsertionAdapter.insert(
        transaccion, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTransaccion(TransaccionModelo transaccion) async {
    await _transaccionModeloUpdateAdapter.update(
        transaccion, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTransaccion(TransaccionModelo transaccion) async {
    await _transaccionModeloDeletionAdapter.delete(transaccion);
  }
}
