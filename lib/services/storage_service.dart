import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class StorageService {
  // ============================================================
  // KONFIGURASI CLOUDINARY
  // ============================================================

  static const String cloudName = 'cpze3sx9';
  static const String uploadPreset = 'desa_tembarak';

  // ============================================================
  // UPLOAD FOTO UMUM
  // ============================================================

  Future<String> uploadFoto({
    required Uint8List bytes,
    required String fileName,
    String folder = 'desa-tembarak',
    void Function(double progress)? onProgress,
  }) async {
    try {
      onProgress?.call(0.1);

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

      onProgress?.call(0.4);

      final response = await request.send();

      onProgress?.call(0.8);

      final responseBody =
          await response.stream.bytesToString();

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'Upload Cloudinary gagal: '
          '${response.statusCode} - $responseBody',
        );
      }

      final data = jsonDecode(responseBody);

      final secureUrl =
          data['secure_url']?.toString();

      if (secureUrl == null || secureUrl.isEmpty) {
        throw Exception(
          'Cloudinary tidak mengembalikan URL gambar.',
        );
      }

      onProgress?.call(1.0);

      return secureUrl;
    } catch (e) {
      onProgress?.call(0);

      throw Exception(
        'Gagal mengupload foto: $e',
      );
    }
  }

  // ============================================================
  // LOGO DESA
  // ============================================================

  Future<String> uploadLogoDesa({
    required Uint8List bytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/logo',
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
  }) async {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/berita',
      onProgress: onProgress,
    );
  }

  // ============================================================
  // FOTO PRODUK
  // ============================================================

  Future<String> uploadProdukFoto({
    required Uint8List bytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/produk',
      onProgress: onProgress,
    );
  }

  // ============================================================
  // FOTO PERANGKAT / STRUKTUR
  // ============================================================

  Future<String> uploadPerangkatFoto({
    required Uint8List bytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/struktur',
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
  }) async {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/galeri',
      onProgress: onProgress,
    );
  }

  // ============================================================
  // FOTO KEGIATAN
  // ============================================================

  Future<String> uploadKegiatanFoto({
    required Uint8List bytes,
    required String fileName,
    void Function(double progress)? onProgress,
  }) async {
    return uploadFoto(
      bytes: bytes,
      fileName: fileName,
      folder: 'desa-tembarak/kegiatan',
      onProgress: onProgress,
    );
  }

  // ============================================================
  // HAPUS FOTO
  // ============================================================

  Future<void> hapusFoto(String fotoUrl) async {
    if (fotoUrl.trim().isEmpty) {
      return;
    }

    /*
     * Jangan menyimpan Cloudinary API Secret di Flutter Web.
     *
     * Penghapusan file fisik Cloudinary sebaiknya dilakukan
     * melalui backend / Cloud Function.
     *
     * Method ini tetap disediakan karena halaman admin lama
     * memanggil StorageService.hapusFoto().
     */

    return;
  }
}