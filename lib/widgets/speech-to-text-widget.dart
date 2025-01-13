import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
 import '../file_downloader.dart';
 import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

class SpeechToTextWidget extends StatefulWidget {
  const SpeechToTextWidget({Key? key}) : super(key: key);

  @override
  _SpeechToTextWidgetState createState() => _SpeechToTextWidgetState();
}

class _SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  final FileDownloader _downloader = FileDownloader();
  String _status = "Idle";
  double _progress = 0.0;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _downloadModel();
  }

  Future<void> _downloadModel() async {
    try {
      setState(() {
        _status = "Starting download...";
        _isDownloading = true;
      });

      final appDir = await getApplicationDocumentsDirectory();
      final modelPath = '${appDir.path}/vosk-model-el-gr-0.7';

      // Skip download if the model is already present
      if (Directory(modelPath).existsSync()) {
        setState(() {
          _status = "Model already exists.";
          _isDownloading = false;
        });
        return;
      }

      final modelZipPath = '${appDir.path}/vosk-model-el-gr-0.7.zip';
      const modelUrl =
          'https://example.com/path-to-vosk-model-el-gr-0.7.zip'; // Replace with your hosted model URL

      // Download the ZIP file
      await _downloader.downloadFile(
        url: modelUrl,
        savePath: modelZipPath,
        onProgress: (progress) {
          setState(() {
            _progress = progress;
            _status = "Downloading: ${(progress * 100).toStringAsFixed(1)}%";
          });
        },
      );

      // Extract the ZIP file
      setState(() {
        _status = "Extracting model...";
      });
      await _extractZip(modelZipPath, modelPath);

      // Clean up ZIP file
      File(modelZipPath).deleteSync();

      setState(() {
        _status = "Model ready at $modelPath";
        _isDownloading = false;
      });

      // Initialize Vosk with the extracted model
      // vosk.init(modelPath); // Uncomment after adding vosk initialization
    } catch (e) {
      setState(() {
        _status = "Error: $e";
        _isDownloading = false;
      });
    }
  }

  Future<void> _extractZip(String zipPath, String outputPath) async {
    // Use the archive package for ZIP extraction
    final bytes = File(zipPath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filePath = '$outputPath/${file.name}';
      if (file.isFile) {
        final outFile = File(filePath)..createSync(recursive: true);
        outFile.writeAsBytesSync(file.content as List<int>);
      } else {
        Directory(filePath).createSync(recursive: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_status),
        if (_isDownloading) LinearProgressIndicator(value: _progress),
        const SizedBox(height: 16),
      ],
    );
  }
}
