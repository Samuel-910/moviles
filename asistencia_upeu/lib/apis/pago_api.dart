import 'package:asistencia_upeu/modelo/PagoModelo.dart';
import 'package:asistencia_upeu/util/UrlApi.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'pago_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class PagoApi {
  factory PagoApi(Dio dio, {String baseUrl}) = _PagoApi;

  static PagoApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return PagoApi(dio);
  }

  @GET("/pago")
  Future<List<PagoModelo>> getAllPagos();

  @GET("/pago/{id}")
  Future<PagoModelo> getPagoById(@Path("id") int id);

  @POST("/pago")
  Future<PagoModelo> createPago(@Body() PagoModelo pago);

  @PUT("/pago/{id}")
  Future<PagoModelo> updatePago(@Path("id") int id, @Body() PagoModelo pago);

  @DELETE("/pago/{id}")
  Future<void> deletePago(@Path("id") int id);
}
