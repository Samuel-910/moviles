import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:asistencia_upeu/repository/file_service.dart';

class FilePreviewScreen extends StatelessWidget {
  final String fileName;
  final FileService _fileService = FileService();

  FilePreviewScreen({required this.fileName});

  Future<Uint8List?> loadFileContent() async {
    return await _fileService.downloadFile(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista Previa: $fileName'),
      ),
      body: FutureBuilder<Uint8List?>(
        future: loadFileContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar el archivo'));
          } else if (snapshot.data == null) {
            return Center(child: Text('No se pudo cargar el archivo'));
          } else {
            final fileBytes = snapshot.data!;

            if (fileName.endsWith('.png') || fileName.endsWith('.jpg')) {
              // Mostrar imágenes
              return Center(
                child: Image.memory(fileBytes),
              );
            } else if (fileName.endsWith('.txt')) {
              // Mostrar archivos de texto
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(String.fromCharCodes(fileBytes)),
                ),
              );
            } else {
              // Tipo de archivo no compatible
              return Center(child: Text('Vista previa no disponible para este tipo de archivo'));
            }
          }
        },
      ),
    );
  }
}
