import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/galeri.dart';

class GaleriService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String collectionName = 'galeri';

  // ============================================================
  // AMBIL SEMUA GALERI
  // ============================================================

  Stream<List<Galeri>> getGaleri() {
    return _firestore
        .collection(collectionName)
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Galeri.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  // ============================================================
  // TAMBAH GALERI
  // ============================================================

  Future<void> tambahGaleri({
    required String judul,
    required String deskripsi,
    required String fotoUrl,
  }) async {
    await _firestore
        .collection(collectionName)
        .add({
      'judul': judul,
      'deskripsi': deskripsi,
      'fotoUrl': fotoUrl,
      'createdAt':
          FieldValue.serverTimestamp(),
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // UPDATE GALERI
  // ============================================================

  Future<void> updateGaleri({
    required String id,
    required String judul,
    required String deskripsi,
    required String fotoUrl,
  }) async {
    await _firestore
        .collection(collectionName)
        .doc(id)
        .update({
      'judul': judul,
      'deskripsi': deskripsi,
      'fotoUrl': fotoUrl,
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // HAPUS GALERI
  // ============================================================

  Future<void> hapusGaleri(
    String id,
  ) async {
    await _firestore
        .collection(collectionName)
        .doc(id)
        .delete();
  }
}