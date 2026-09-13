import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/perangkat.dart';

class PerangkatService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String _collection = 'perangkat';

  Stream<List<Perangkat>> getPerangkat() {
    return _firestore
        .collection(_collection)
        .orderBy('urutan')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Perangkat.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  Future<void> tambahPerangkat({
    required String nama,
    required String jabatan,
    required String fotoUrl,
    required String keterangan,
    required int urutan,
  }) async {
    try {
      await _firestore.collection(_collection).add({
        'nama': nama,
        'jabatan': jabatan,
        'fotoUrl': fotoUrl,
        'keterangan': keterangan,
        'urutan': urutan,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(
        'Gagal menambahkan perangkat desa: $e',
      );
    }
  }

  Future<void> updatePerangkat({
    required String id,
    required String nama,
    required String jabatan,
    required String fotoUrl,
    required String keterangan,
    required int urutan,
  }) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update({
        'nama': nama,
        'jabatan': jabatan,
        'fotoUrl': fotoUrl,
        'keterangan': keterangan,
        'urutan': urutan,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(
        'Gagal mengubah perangkat desa: $e',
      );
    }
  }

  Future<void> hapusPerangkat(String id) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception(
        'Gagal menghapus perangkat desa: $e',
      );
    }
  }
}