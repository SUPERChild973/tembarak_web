import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/berita.dart';

class BeritaService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String _collection = 'berita';

  // ============================================================
  // AMBIL SEMUA BERITA
  // ============================================================

  Stream<List<Berita>> getBerita() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Berita.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  // ============================================================
  // AMBIL BERITA TERBARU
  // ============================================================

  Stream<List<Berita>> getBeritaTerbaru({
    int limit = 3,
  }) {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Berita.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  // ============================================================
  // AMBIL BERITA BERDASARKAN ID
  // ============================================================

  Future<Berita?> getBeritaById(
    String id,
  ) async {
    final doc = await _firestore
        .collection(_collection)
        .doc(id)
        .get();

    if (!doc.exists) {
      return null;
    }

    return Berita.fromMap(
      doc.id,
      doc.data()!,
    );
  }

  // ============================================================
  // TAMBAH BERITA
  // ============================================================

  Future<void> tambahBerita({
    required String judul,
    required String kategori,
    required String fotoUrl,
    required String ringkasan,
    required String isi,
  }) async {
    await _firestore
        .collection(_collection)
        .add({
      'judul': judul,
      'kategori': kategori,
      'fotoUrl': fotoUrl,
      'ringkasan': ringkasan,
      'isi': isi,
      'createdAt':
          FieldValue.serverTimestamp(),
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // UPDATE BERITA
  // ============================================================

  Future<void> updateBerita({
    required String id,
    required String judul,
    required String kategori,
    required String fotoUrl,
    required String ringkasan,
    required String isi,
  }) async {
    await _firestore
        .collection(_collection)
        .doc(id)
        .update({
      'judul': judul,
      'kategori': kategori,
      'fotoUrl': fotoUrl,
      'ringkasan': ringkasan,
      'isi': isi,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // HAPUS BERITA
  // ============================================================

  Future<void> hapusBerita(
    String id,
  ) async {
    await _firestore
        .collection(_collection)
        .doc(id)
        .delete();
  }
}