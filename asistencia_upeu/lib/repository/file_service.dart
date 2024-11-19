import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class FileService {
  final String baseUrl = 'http://192.168.69.78:8080/files';

  // Subir archivo
  Future<String> uploadFile(File file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        return 'Archivo subido exitosamente';
      } else {
        return 'Error al subir archivo';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Servicio para obtener la lista de archivos
  Future<List<dynamic>> listFiles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Devuelve la lista de archivos
      } else {
        throw Exception('Error al listar archivos');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<Uint8List?> downloadFile(String fileName) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$fileName'));

      if (response.statusCode == 200) {
        return response.bodyBytes; // Devolver el contenido como Uint8List
      } else {
        throw Exception('Error al descargar el archivo');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }




}
