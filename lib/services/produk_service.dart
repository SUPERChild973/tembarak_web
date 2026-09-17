import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/produk.dart';

class ProdukService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String _collection = 'produk';

  // =========================
  // AMBIL SEMUA PRODUK
  // =========================

  Stream<List<Produk>> getProduk() {
    return _firestore
        .collection(_collection)
        .orderBy('urutan')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Produk.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  // =========================
  // TAMBAH PRODUK
  // =========================

  Future<void> tambahProduk({
    required String nama,
    required String pemilik,
    required String alamat,
    required String telepon,
    required String fotoUrl,
    required String deskripsi,
    required int urutan,
  }) async {
    try {
      await _firestore
          .collection(_collection)
          .add({
        'nama': nama,
        'pemilik': pemilik,
        'alamat': alamat,
        'telepon': telepon,
        'fotoUrl': fotoUrl,
        'deskripsi': deskripsi,
        'urutan': urutan,
        'createdAt':
            FieldValue.serverTimestamp(),
        'updatedAt':
            FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(
        'Gagal menambahkan produk desa: $e',
      );
    }
  }

  // =========================
  // EDIT PRODUK
  // =========================

  Future<void> updateProduk({
    required String id,
    required String nama,
    required String pemilik,
    required String alamat,
    required String telepon,
    required String fotoUrl,
    required String deskripsi,
    required int urutan,
  }) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update({
        'nama': nama,
        'pemilik': pemilik,
        'alamat': alamat,
        'telepon': telepon,
        'fotoUrl': fotoUrl,
        'deskripsi': deskripsi,
        'urutan': urutan,
        'updatedAt':
            FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(
        'Gagal mengubah produk desa: $e',
      );
    }
  }

  // =========================
  // HAPUS PRODUK
  // =========================

  Future<void> hapusProduk(
    String id,
  ) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception(
        'Gagal menghapus produk desa: $e',
      );
    }
  }
}