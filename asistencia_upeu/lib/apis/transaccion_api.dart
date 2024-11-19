import 'package:asistencia_upeu/modelo/TransaccionModelo.dart';
import 'package:asistencia_upeu/util/UrlApi.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'transaccion_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class TransaccionApi {
  factory TransaccionApi(Dio dio, {String baseUrl}) = _TransaccionApi;

  static TransaccionApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return TransaccionApi(dio);
  }

  @GET("/transaccion")
  Future<List<TransaccionModelo>> getAllTransacciones();

  @GET("/transaccion/{id}")
  Future<TransaccionModelo> getTransaccionById(@Path("id") int id);

  @POST("/transaccion")
  Future<TransaccionModelo> createTransaccion(@Body() TransaccionModelo transaccion);

  @PUT("/transaccion/{id}")
  Future<TransaccionModelo> updateTransaccion(@Path("id") int id, @Body() TransaccionModelo transaccion);

  @DELETE("/transaccion/{id}")
  Future<void> deleteTransaccion(@Path("id") int id);
}
