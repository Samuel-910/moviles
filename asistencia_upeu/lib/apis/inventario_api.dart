import 'package:asistencia_upeu/modelo/InventarioModelo.dart';
import 'package:asistencia_upeu/util/UrlApi.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'inventario_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class InventarioApi {
  factory InventarioApi(Dio dio, {String baseUrl}) = _InventarioApi;

  static InventarioApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return InventarioApi(dio);
  }

  @GET("/inventario")
  Future<List<InventarioModelo>> getAllInventario();

  @GET("/inventario/{id}")
  Future<InventarioModelo> getInventarioById(@Path("id") int id);

  @POST("/inventario")
  Future<InventarioModelo> createInventario(@Body() InventarioModelo inventario);

  @PUT("/inventario/{id}")
  Future<InventarioModelo> updateInventario(@Path("id") int id, @Body() InventarioModelo inventario);

  @DELETE("/inventario/{id}")
  Future<void> deleteInventario(@Path("id") int id);
}
