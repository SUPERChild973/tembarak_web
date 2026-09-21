import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class StorageService {
  // ============================================================
  // CLOUDINARY
  // ============================================================

  static const String cloudName = 'cpze3sx9';

  static const String uploadPreset = 'desa_tembarak';

  // ============================================================
  // UPLOAD FOTO UMUM
  // ============================================================

  Future<String> uploadFoto({
    required Uint8List bytes,
    required String fileName,
    required String folder,
    void Function(double progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0);

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
        ),
      );

      onProgress?.call(0.1);

      final streamedResponse = await request.send();

      onProgress?.call(0.8);

      final response = await http.Response.fromStream(
        streamedResponse,
      );

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'Upload Cloudinary gagal.\n'
          'Status: ${response.statusCode}\n'
          '${response.body}',
        );
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body);

      final dynamic secureUrl =
          data['secure_url'];

      if (secureUrl == null ||
          secureUrl.toString().trim().isEmpty) {
        throw Exception(
          'Cloudinary tidak mengembalikan URL foto.',
        );
      }

      onProgress?.call(1);

      return secureUrl.toString();
    } catch (e) {
      onProgress?.call(0);

      throw Exception(
        'Gagal mengupload foto: $e',
      );
    }
  }

  // ============================================================
  // UPLOAD LOGO DESA
  // ============================================================

  Future<String> uploadLogoDesa({
    required Uint8List bytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/logo',
      onProgress: onProgress,
    );
  }

  // ============================================================
  // FOTO PERANGKAT DESA
  // ============================================================

  Future<String> uploadPerangkatFoto({
    required Uint8List bytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/perangkat',
      onProgress: onProgress,
    );
  }

  // ============================================================
  // FOTO PRODUK DESA
  // ============================================================

  Future<String> uploadProdukFoto({
    required Uint8List bytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/produk',
      onProgress: onProgress,
    );
  }

  // ============================================================
  // FOTO BERITA
  // ============================================================

  Future<String> uploadBeritaFoto({
    required Uint8List bytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/berita',
      onProgress: onProgress,
    );
  }

  // ============================================================
  // FOTO GALERI
  // ============================================================

  Future<String> uploadGaleriFoto({
    required Uint8List bytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/galeri',
      onProgress: onProgress,
    );
  }

  // ============================================================
  // HAPUS FOTO
  // ============================================================

  Future<void> hapusFoto(
    String fotoUrl,
  ) async {
    if (fotoUrl.trim().isEmpty) {
      return;
    }

    // Penghapusan Cloudinary membutuhkan API Secret.
    // Jangan menyimpan API Secret di Flutter Web.
  }
}