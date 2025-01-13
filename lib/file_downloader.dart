import 'dart:io';
import 'package:http/http.dart' as http;

class FileDownloader {
  Future<void> downloadFile({
    required String url,
    required String savePath,
    Function(double progress)? onProgress,
  }) async {
    final response = await http.Client().send(http.Request('GET', Uri.parse(url)));

    if (response.statusCode != 200) {
      throw HttpException('Failed to download file', uri: Uri.parse(url));
    }

    final file = File(savePath);
    final fileSink = file.openWrite();
    final totalBytes = response.contentLength ?? 0;
    int downloadedBytes = 0;

    await response.stream.listen((chunk) {
      downloadedBytes += chunk.length;
      fileSink.add(chunk);
      if (onProgress != null && totalBytes > 0) {
        onProgress(downloadedBytes / totalBytes);
      }
    }).asFuture();

    await fileSink.close();
  }
}
