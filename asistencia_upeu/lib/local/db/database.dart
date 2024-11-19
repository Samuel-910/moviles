import 'dart:async';
import 'package:asistencia_upeu/local/dao/ClienteDao.dart';
import 'package:asistencia_upeu/local/dao/InventarioDao.dart';
import 'package:asistencia_upeu/local/dao/PagoDao.dart';
import 'package:asistencia_upeu/local/dao/TransaccionDao.dart';
import 'package:asistencia_upeu/modelo/ClienteModelo.dart';
import 'package:asistencia_upeu/modelo/InventarioModelo.dart';
import 'package:asistencia_upeu/modelo/PagoModelo.dart';
import 'package:asistencia_upeu/modelo/TransaccionModelo.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart'; // the generated code will be there
//https://github.com/pinchbv/floor
//flutter packages pub run build_runner build
//flutter packages pub run build_runner watch
@Database(version: 6, entities: [ InventarioModelo, ClienteModelo, PagoModelo, TransaccionModelo])
abstract class AppDatabase extends FloorDatabase {
  InventarioDao get inventarioDao;
  ClienteDao get clienteDao;
  PagoDao get pagoDao;
  TransaccionDao get transaccionDao;
}
