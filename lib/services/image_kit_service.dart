import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageKitService {
  static const String _uploadUrl =
      "https://upload.imagekit.io/api/v1/files/upload";
  static const String _apiKey = "private_54sywIDgv2WQFF01+kWU5HIRkpc=";

  Future<String?> uploadImage(File file, String fileName) async {
    try {
      final request = http.MultipartRequest("POST", Uri.parse(_uploadUrl));
      request.fields['fileName'] = fileName;
      request.fields['folder'] = "/uploads";
      request.fields['useUniqueFileName'] = "true";
      request.headers['Authorization'] =
          'Basic ${base64Encode(utf8.encode("$_apiKey:"))}';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = json.decode(responseBody);
        return decoded['url'];
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
