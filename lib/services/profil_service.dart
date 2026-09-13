import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String _collection = 'profil';

  /// Mengambil data profil desa
  Future<Map<String, dynamic>?> getProfil() async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc('desa')
          .get();

      if (!doc.exists) {
        return null;
      }

      return doc.data();
    } catch (e) {
      throw Exception(
        'Gagal mengambil data profil desa: $e',
      );
    }
  }

  /// Menyimpan / memperbarui data profil desa
  Future<void> saveProfil({
    required String namaDesa,
    required String kecamatan,
    required String kabupaten,
    required String provinsi,
    required String sejarah,
    required String visi,
    required String misi,
    required String kondisi,
    required String potensi,
    required String alamat,
    required String telepon,
    required String email,
  }) async {
    try {
      await _firestore
          .collection(_collection)
          .doc('desa')
          .set({
        'namaDesa': namaDesa,
        'kecamatan': kecamatan,
        'kabupaten': kabupaten,
        'provinsi': provinsi,
        'sejarah': sejarah,
        'visi': visi,
        'misi': misi,
        'kondisi': kondisi,
        'potensi': potensi,
        'alamat': alamat,
        'telepon': telepon,
        'email': email,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(
        'Gagal menyimpan data profil desa: $e',
      );
    }
  }
}