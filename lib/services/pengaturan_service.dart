import 'package:cloud_firestore/cloud_firestore.dart';

class PengaturanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  // COLLECTION & DOCUMENT
  // ============================================================

  static const String collectionName = 'pengaturan';
  static const String documentName = 'website';

  // ============================================================
  // REFERENCE
  // ============================================================

  DocumentReference<Map<String, dynamic>> get _websiteRef {
    return _firestore
        .collection(collectionName)
        .doc(documentName);
  }

  // ============================================================
  // MENGAMBIL SEMUA PENGATURAN
  // ============================================================

  Future<Map<String, dynamic>?> getPengaturan() async {
    try {
      final snapshot = await _websiteRef.get();

      if (!snapshot.exists) {
        return null;
      }

      return snapshot.data();
    } catch (e) {
      throw Exception(
        'Gagal mengambil data pengaturan: $e',
      );
    }
  }

  // ============================================================
  // MENYIMPAN SEMUA PENGATURAN
  // ============================================================

  Future<void> savePengaturan({
    // ----------------------------------------------------------
    // INFORMASI DESA
    // ----------------------------------------------------------
    required String namaDesa,
    required String kecamatan,
    required String kabupaten,

    // ----------------------------------------------------------
    // VIDEO PROFIL
    // ----------------------------------------------------------
    required String videoJudul,
    required String videoUrl,

    // ----------------------------------------------------------
    // STATISTIK DESA
    // ----------------------------------------------------------
    required String jumlahPenduduk,
    required String jumlahKeluarga,
    required String jumlahDusun,
    required String jumlahRtRw,

    // ----------------------------------------------------------
    // INFORMASI KONTAK / FOOTER
    // ----------------------------------------------------------
    required String footerDeskripsi,
    required String footerAlamat,
    required String footerTelepon,
    required String footerEmail,
    required String footerJamOperasional,
    required String footerCopyright,
  }) async {
    try {
      // Data yang akan disimpan
      final Map<String, dynamic> data = {
        // ======================================================
        // INFORMASI DESA
        // ======================================================

        'namaDesa': namaDesa,
        'kecamatan': kecamatan,
        'kabupaten': kabupaten,

        // ======================================================
        // VIDEO PROFIL
        // ======================================================

        'videoJudul': videoJudul,
        'videoUrl': videoUrl,

        // ======================================================
        // STATISTIK DESA
        // ======================================================

        'jumlahPenduduk': jumlahPenduduk,
        'jumlahKeluarga': jumlahKeluarga,
        'jumlahDusun': jumlahDusun,
        'jumlahRtRw': jumlahRtRw,

        // ======================================================
        // FOOTER / KONTAK
        // ======================================================

        'footerDeskripsi': footerDeskripsi,
        'footerAlamat': footerAlamat,
        'footerTelepon': footerTelepon,
        'footerEmail': footerEmail,

        // JAM OPERASIONAL
        'footerJamOperasional': footerJamOperasional,

        // COPYRIGHT
        'footerCopyright': footerCopyright,

        // ======================================================
        // WAKTU UPDATE
        // ======================================================

        'updatedAt': FieldValue.serverTimestamp(),
      };

      // ========================================================
      // SIMPAN KE:
      // pengaturan
      //    └── website
      // ========================================================

      await _websiteRef.set(
        data,
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception(
        'Gagal menyimpan pengaturan: $e',
      );
    }
  }

  // ============================================================
  // UPDATE PENGATURAN TERTENTU
  // ============================================================

  Future<void> updatePengaturan(
    Map<String, dynamic> data,
  ) async {
    try {
      await _websiteRef.set(
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

  // ============================================================
  // MENGAMBIL SATU FIELD
  // ============================================================

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

  // ============================================================
  // MENGHAPUS PENGATURAN
  // ============================================================

  Future<void> deletePengaturan() async {
    try {
      await _websiteRef.delete();
    } catch (e) {
      throw Exception(
        'Gagal menghapus pengaturan: $e',
      );
    }
  }

  // ============================================================
  // STREAM REALTIME
  // ============================================================

  Stream<Map<String, dynamic>?> streamPengaturan() {
    return _websiteRef.snapshots().map(
      (snapshot) {
        if (!snapshot.exists) {
          return null;
        }

        return snapshot.data();
      },
    );
  }
}