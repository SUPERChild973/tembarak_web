import 'package:cloud_firestore/cloud_firestore.dart';

class PengaturanService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String collectionName = 'pengaturan';
  static const String documentName = 'website';

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
    required String namaDesa,
    required String kecamatan,
    required String kabupaten,

    // LOGO
    required String logoUrl,

    // VIDEO
    required String videoJudul,
    required String videoUrl,

    // STATISTIK
    required String jumlahPenduduk,
    required String jumlahKeluarga,
    required String jumlahDusun,
    required String jumlahRtRw,

    // FOOTER
    required String footerDeskripsi,
    required String footerAlamat,
    required String footerTelepon,
    required String footerEmail,
    required String footerJamOperasional,
    required String footerCopyright,
  }) async {
    try {
      final Map<String, dynamic> data = {
        // ======================================================
        // INFORMASI DESA
        // ======================================================

        'namaDesa': namaDesa,
        'kecamatan': kecamatan,
        'kabupaten': kabupaten,

        // ======================================================
        // LOGO
        // ======================================================

        'logoUrl': logoUrl,

        // ======================================================
        // VIDEO
        // ======================================================

        'videoJudul': videoJudul,
        'videoUrl': videoUrl,

        // ======================================================
        // STATISTIK
        // ======================================================

        'jumlahPenduduk': jumlahPenduduk,
        'jumlahKeluarga': jumlahKeluarga,
        'jumlahDusun': jumlahDusun,
        'jumlahRtRw': jumlahRtRw,

        // ======================================================
        // FOOTER
        // ======================================================

        'footerDeskripsi': footerDeskripsi,
        'footerAlamat': footerAlamat,
        'footerTelepon': footerTelepon,
        'footerEmail': footerEmail,
        'footerJamOperasional': footerJamOperasional,
        'footerCopyright': footerCopyright,

        // ======================================================
        // UPDATE
        // ======================================================

        'updatedAt': FieldValue.serverTimestamp(),
      };

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
  // MENGAMBIL SATU DATA
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