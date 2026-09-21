import 'package:cloud_firestore/cloud_firestore.dart';

class PengaturanService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // Nama collection khusus untuk pengaturan website
  final String _collection = 'pengaturan';

  // Nama dokumen pengaturan utama
  final String _document = 'website';

  /// Mengambil seluruh pengaturan website
  Future<Map<String, dynamic>?> getPengaturan() async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc(_document)
          .get();

      if (!doc.exists) {
        return null;
      }

      return doc.data();
    } catch (e) {
      throw Exception(
        'Gagal mengambil data pengaturan: $e',
      );
    }
  }

  /// Menyimpan pengaturan website
  Future<void> savePengaturan({
    // =========================
    // INFORMASI DESA
    // =========================
    required String namaDesa,
    required String kecamatan,
    required String kabupaten,

    // =========================
    // VIDEO PROFIL DESA
    // =========================
    required String videoJudul,
    required String videoUrl,

    // =========================
    // STATISTIK DESA
    // =========================
    required String jumlahPenduduk,
    required String jumlahKeluarga,
    required String jumlahDusun,
    required String jumlahRtRw,

    // =========================
    // FOOTER / INFORMASI BAWAH
    // =========================
    required String footerDeskripsi,
    required String footerAlamat,
    required String footerTelepon,
    required String footerEmail,
    required String footerJamOperasional,
    required String footerCopyright,
  }) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(_document)
          .set(
        {
          // Informasi Desa
          'namaDesa': namaDesa,
          'kecamatan': kecamatan,
          'kabupaten': kabupaten,

          // Video Profil
          'videoJudul': videoJudul,
          'videoUrl': videoUrl,

          // Statistik Desa
          'jumlahPenduduk': jumlahPenduduk,
          'jumlahKeluarga': jumlahKeluarga,
          'jumlahDusun': jumlahDusun,
          'jumlahRtRw': jumlahRtRw,

          // Footer
          'footerDeskripsi': footerDeskripsi,
          'footerAlamat': footerAlamat,
          'footerTelepon': footerTelepon,
          'footerEmail': footerEmail,
          'footerJamOperasional': footerJamOperasional,
          'footerCopyright': footerCopyright,

          // Waktu perubahan
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception(
        'Gagal menyimpan pengaturan: $e',
      );
    }
  }

  /// Update satu atau beberapa pengaturan saja
  Future<void> updatePengaturan(
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(_document)
          .set(
        {
          ...data,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception(
        'Gagal memperbarui pengaturan: $e',
      );
    }
  }

  /// Mengambil satu nilai pengaturan berdasarkan nama field
  Future<dynamic> getValue(String field) async {
    try {
      final data = await getPengaturan();

      if (data == null) {
        return null;
      }

      return data[field];
    } catch (e) {
      throw Exception(
        'Gagal mengambil pengaturan $field: $e',
      );
    }
  }

  /// Menghapus seluruh pengaturan website
  Future<void> deletePengaturan() async {
    try {
      await _firestore
          .collection(_collection)
          .doc(_document)
          .delete();
    } catch (e) {
      throw Exception(
        'Gagal menghapus pengaturan: $e',
      );
    }
  }

  /// Stream pengaturan secara realtime
  Stream<Map<String, dynamic>?> streamPengaturan() {
    return _firestore
        .collection(_collection)
        .doc(_document)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      return snapshot.data();
    });
  }
}