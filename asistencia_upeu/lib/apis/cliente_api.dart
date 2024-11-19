import 'package:asistencia_upeu/modelo/ClienteModelo.dart';
import 'package:asistencia_upeu/util/UrlApi.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'cliente_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class ClienteApi {
  factory ClienteApi(Dio dio, {String baseUrl}) = _ClienteApi;

  static ClienteApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return ClienteApi(dio);
  }

  @GET("/cliente")
  Future<List<ClienteModelo>> getAllClientes();

  @GET("/cliente/{id}")
  Future<ClienteModelo> getClienteById(@Path("id") int id);

  @POST("/cliente")
  Future<ClienteModelo> createCliente(@Body() ClienteModelo cliente);

  @PUT("/cliente/{id}")
  Future<ClienteModelo> updateCliente(@Path("id") int id, @Body() ClienteModelo cliente);

  @DELETE("/cliente/{id}")
  Future<void> deleteCliente(@Path("id") int id);
}
