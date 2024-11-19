import 'dart:io';
import 'package:asistencia_upeu/repository/file_service.dart';
import 'package:asistencia_upeu/ui/file/file_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final FileService _fileService = FileService();
  List<dynamic> files = [];

  // Cargar archivos desde el servidor
  Future<void> loadFiles() async {
    files = await _fileService.listFiles();
    setState(() {});
  }
  // Subir archivo
  Future<void> selectAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String response = await _fileService.uploadFile(file);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Archivos'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: selectAndUploadFile,
            child: Text('Subir Archivo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text(file['fileName']), // Muestra el nombre del archivo
                  subtitle: Text('${file['fileSize']} bytes'), // Tamaño del archivo
                  trailing: IconButton(
                    icon: Icon(Icons.visibility), // Cambia el ícono a "visibilidad"
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilePreviewScreen(
                            fileName: file['fileName'], // Pasa el nombre del archivo
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadFiles(); // Cargar archivos al iniciar la pantalla
  }
}
