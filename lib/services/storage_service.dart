import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  // ======================================================
  // UPLOAD FOTO PERANGKAT DESA
  // ======================================================

  Future<String> uploadPerangkatFoto({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final extension = fileName.contains('.')
          ? fileName.split('.').last
          : 'jpg';

      final filePath =
          'perangkat/${DateTime.now().millisecondsSinceEpoch}.$extension';

      final ref = _storage.ref().child(filePath);

      await ref.putData(
        bytes,
        SettableMetadata(
          contentType: _getContentType(extension),
        ),
      );

      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception(
        'Gagal mengupload foto perangkat desa: $e',
      );
    }
  }

  // ======================================================
  // UPLOAD FOTO PRODUK DESA
  // ======================================================

  Future<String> uploadProdukFoto({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final extension = fileName.contains('.')
          ? fileName.split('.').last
          : 'jpg';

      final filePath =
          'produk/${DateTime.now().millisecondsSinceEpoch}.$extension';

      final ref = _storage.ref().child(filePath);

      await ref.putData(
        bytes,
        SettableMetadata(
          contentType: _getContentType(extension),
        ),
      );

      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception(
        'Gagal mengupload foto produk: $e',
      );
    }
  }

  // ======================================================
  // HAPUS FOTO DARI FIREBASE STORAGE
  // ======================================================

  Future<void> hapusFoto(String fotoUrl) async {
    if (fotoUrl.trim().isEmpty) {
      return;
    }

    try {
      final ref = _storage.refFromURL(fotoUrl);

      await ref.delete();
    } catch (_) {
      // Jika foto sudah tidak ada,
      // proses tetap dilanjutkan.
    }
  }

  // ======================================================
  // CONTENT TYPE FOTO
  // ======================================================

  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      case 'gif':
        return 'image/gif';

      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }
}