import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../services/pengaturan_service.dart';
import '../../services/storage_service.dart';

class PengaturanAdminPage extends StatefulWidget {
  const PengaturanAdminPage({super.key});

  @override
  State<PengaturanAdminPage> createState() =>
      _PengaturanAdminPageState();
}

class _PengaturanAdminPageState
    extends State<PengaturanAdminPage> {
  final _formKey = GlobalKey<FormState>();

  final PengaturanService _pengaturanService =
      PengaturanService();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isUploadingLogo = false;

  String _logoUrl = '';

  // ============================================================
  // INFORMASI DESA
  // ============================================================

  final _namaDesaController =
      TextEditingController();

  final _kecamatanController =
      TextEditingController();

  final _kabupatenController =
      TextEditingController();

  // ============================================================
  // STATISTIK DESA
  // ============================================================

  final _jumlahPendudukController =
      TextEditingController();

  final _jumlahKeluargaController =
      TextEditingController();

  final _jumlahDusunController =
      TextEditingController();

  final _jumlahRtRwController =
      TextEditingController();

  // ============================================================
  // VIDEO PROFIL
  // ============================================================

  final _videoJudulController =
      TextEditingController();

  final _videoUrlController =
      TextEditingController();

  // ============================================================
  // FOOTER / INFORMASI KONTAK
  // ============================================================

  final _footerDeskripsiController =
      TextEditingController();

  final _footerAlamatController =
      TextEditingController();

  final _footerTeleponController =
      TextEditingController();

  final _footerEmailController =
      TextEditingController();

  final _footerJamOperasionalController =
      TextEditingController();

  final _footerCopyrightController =
      TextEditingController();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadPengaturan();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _namaDesaController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();

    _jumlahPendudukController.dispose();
    _jumlahKeluargaController.dispose();
    _jumlahDusunController.dispose();
    _jumlahRtRwController.dispose();

    _videoJudulController.dispose();
    _videoUrlController.dispose();

    _footerDeskripsiController.dispose();
    _footerAlamatController.dispose();
    _footerTeleponController.dispose();
    _footerEmailController.dispose();
    _footerJamOperasionalController.dispose();
    _footerCopyrightController.dispose();

    super.dispose();
  }

  // ============================================================
  // LOAD DATA DARI FIRESTORE
  // ============================================================

  Future<void> _loadPengaturan() async {
    try {
      final data =
          await _pengaturanService.getPengaturan();

      if (data != null) {
        _logoUrl = data['logoUrl']?.toString() ?? '';

        // ======================================================
        // INFORMASI DESA
        // ======================================================

        _namaDesaController.text =
            data['namaDesa']?.toString() ?? '';

        _kecamatanController.text =
            data['kecamatan']?.toString() ?? '';

        _kabupatenController.text =
            data['kabupaten']?.toString() ?? '';

        // ======================================================
        // STATISTIK DESA
        // ======================================================

        _jumlahPendudukController.text =
            data['jumlahPenduduk']?.toString() ?? '';

        _jumlahKeluargaController.text =
            data['jumlahKeluarga']?.toString() ?? '';

        _jumlahDusunController.text =
            data['jumlahDusun']?.toString() ?? '';

        _jumlahRtRwController.text =
            data['jumlahRtRw']?.toString() ?? '';

        // ======================================================
        // VIDEO PROFIL
        // ======================================================

        _videoJudulController.text =
            data['videoJudul']?.toString() ?? '';

        _videoUrlController.text =
            data['videoUrl']?.toString() ?? '';

        // ======================================================
        // FOOTER / KONTAK
        // ======================================================

        _footerDeskripsiController.text =
            data['footerDeskripsi']?.toString() ?? '';

        _footerAlamatController.text =
            data['footerAlamat']?.toString() ?? '';

        _footerTeleponController.text =
            data['footerTelepon']?.toString() ?? '';

        _footerEmailController.text =
            data['footerEmail']?.toString() ?? '';

        _footerJamOperasionalController.text =
            data['footerJamOperasional']?.toString() ?? '';

        _footerCopyrightController.text =
            data['footerCopyright']?.toString() ?? '';
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memuat pengaturan: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // UPLOAD LOGO DESA
  // ============================================================

  Future<void> _pilihDanUploadLogo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['png', 'jpg', 'jpeg', 'webp'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final Uint8List? bytes = file.bytes;

      if (bytes == null || bytes.isEmpty) {
        throw Exception('File logo tidak dapat dibaca.');
      }

      setState(() => _isUploadingLogo = true);

      final url = await StorageService().uploadLogoDesa(
        bytes: bytes,
        fileName: file.name,
      );

      await _pengaturanService.updatePengaturan({
        'logoUrl': url,
      });

      if (!mounted) return;

      setState(() {
        _logoUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logo berhasil diupload dan disimpan.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengupload logo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingLogo = false);
      }
    }
  }

  // ============================================================
  // HAPUS LOGO DARI PENGATURAN
  // ============================================================

  Future<void> _hapusLogo() async {
    try {
      await _pengaturanService.updatePengaturan({
        'logoUrl': '',
      });

      if (!mounted) return;

      setState(() => _logoUrl = '');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logo berhasil dihapus dari pengaturan.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus logo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // WIDGET LOGO
  // ============================================================

  Widget _logoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.background,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _logoUrl.isEmpty
                ? const Icon(
                    Icons.account_balance,
                    size: 75,
                    color: AppTheme.primary,
                  )
                : ClipOval(
                    child: Image.network(
                      _logoUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image_outlined,
                          size: 65,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Logo Desa',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Logo ini digunakan pada Splash Screen, Navbar, dan halaman Home.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isUploadingLogo ? null : _pilihDanUploadLogo,
                icon: _isUploadingLogo
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_outlined),
                label: Text(
                  _isUploadingLogo ? 'Mengupload...' : 'Pilih & Upload Logo',
                ),
              ),
              if (_logoUrl.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: _isUploadingLogo ? null : _hapusLogo,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    'Hapus Logo',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Format: PNG, JPG, JPEG, atau WEBP',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIMPAN PENGATURAN
  // ============================================================

  Future<void> _simpanPengaturan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _pengaturanService.savePengaturan(
        // ======================================================
        // INFORMASI DESA
        // ======================================================

        namaDesa:
            _namaDesaController.text.trim(),

        kecamatan:
            _kecamatanController.text.trim(),

        kabupaten:
            _kabupatenController.text.trim(),

        logoUrl: _logoUrl,

        // ======================================================
        // STATISTIK DESA
        // ======================================================

        jumlahPenduduk:
            _jumlahPendudukController.text.trim(),

        jumlahKeluarga:
            _jumlahKeluargaController.text.trim(),

        jumlahDusun:
            _jumlahDusunController.text.trim(),

        jumlahRtRw:
            _jumlahRtRwController.text.trim(),

        // ======================================================
        // VIDEO PROFIL
        // ======================================================

        videoJudul:
            _videoJudulController.text.trim(),

        videoUrl:
            _videoUrlController.text.trim(),

        // ======================================================
        // FOOTER / KONTAK
        // ======================================================

        footerDeskripsi:
            _footerDeskripsiController.text.trim(),

        footerAlamat:
            _footerAlamatController.text.trim(),

        footerTelepon:
            _footerTeleponController.text.trim(),

        footerEmail:
            _footerEmailController.text.trim(),

        footerJamOperasional:
            _footerJamOperasionalController.text.trim(),

        footerCopyright:
            _footerCopyrightController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pengaturan berhasil disimpan.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan pengaturan: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 850,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        // ==================================================
                        // JUDUL
                        // ==================================================

                        const Text(
                          'Pengaturan Website',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Atur informasi utama website Desa Tembarak.',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ==================================================
                        // LOGO DESA
                        // ==================================================

                        _sectionTitle(
                          'Logo Website',
                          Icons.image_outlined,
                        ),

                        const SizedBox(height: 18),

                        _logoSection(),

                        const SizedBox(height: 35),

                        // ==================================================
                        // INFORMASI DESA
                        // ==================================================

                        _sectionTitle(
                          'Informasi Desa',
                          Icons.home_work_outlined,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _namaDesaController,
                          label: 'Nama Desa',
                          icon:
                              Icons.home_work_outlined,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _kecamatanController,
                          label: 'Kecamatan',
                          icon:
                              Icons.location_city,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _kabupatenController,
                          label: 'Kabupaten',
                          icon:
                              Icons.map_outlined,
                        ),

                        const SizedBox(height: 35),

                        // ==================================================
                        // STATISTIK DESA
                        // ==================================================

                        _sectionTitle(
                          'Statistik Desa',
                          Icons.bar_chart,
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Data berikut akan ditampilkan pada bagian '
                          '"Desa Tembarak dalam Angka" di halaman utama.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _jumlahPendudukController,
                          label: 'Jumlah Penduduk',
                          icon:
                              Icons.people_outline,
                          keyboardType:
                              TextInputType.number,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _jumlahKeluargaController,
                          label:
                              'Jumlah Kepala Keluarga',
                          icon:
                              Icons.home_outlined,
                          keyboardType:
                              TextInputType.number,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _jumlahDusunController,
                          label: 'Jumlah Dusun',
                          icon:
                              Icons.location_city_outlined,
                          keyboardType:
                              TextInputType.number,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _jumlahRtRwController,
                          label: 'Jumlah RT / RW',
                          icon:
                              Icons.groups_outlined,
                          keyboardType:
                              TextInputType.number,
                        ),

                        const SizedBox(height: 35),

                        // ==================================================
                        // VIDEO PROFIL
                        // ==================================================

                        _sectionTitle(
                          'Video Profil Desa',
                          Icons.video_library_outlined,
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Masukkan judul dan link video profil desa. '
                          'Link dapat berasal dari Google Drive atau '
                          'layanan penyimpanan video lainnya.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _videoJudulController,
                          label: 'Judul Video',
                          icon: Icons.title,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _videoUrlController,
                          label: 'Link Video',
                          icon: Icons.link,
                          keyboardType:
                              TextInputType.url,
                          maxLines: 2,
                        ),

                        const SizedBox(height: 35),

                        // ==================================================
                        // INFORMASI KONTAK / FOOTER
                        // ==================================================

                        _sectionTitle(
                          'Informasi Kontak',
                          Icons.contact_phone_outlined,
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Informasi berikut akan ditampilkan '
                          'pada bagian Kontak di halaman utama website.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _footerDeskripsiController,
                          label: 'Deskripsi Kontak',
                          icon:
                              Icons.description_outlined,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _footerAlamatController,
                          label: 'Alamat Kantor Desa',
                          icon:
                              Icons.location_on_outlined,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _footerTeleponController,
                          label: 'Nomor Telepon',
                          icon:
                              Icons.phone_outlined,
                          keyboardType:
                              TextInputType.phone,
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _footerEmailController,
                          label: 'Email Desa',
                          icon:
                              Icons.email_outlined,
                          keyboardType:
                              TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 18),

                        // ==================================================
                        // JAM OPERASIONAL
                        // ==================================================

                        _field(
                          controller:
                              _footerJamOperasionalController,
                          label: 'Jam Operasional',
                          icon:
                              Icons.access_time_outlined,
                          maxLines: 2,
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Contoh: Senin - Jumat: 08.00 - 15.00',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _field(
                          controller:
                              _footerCopyrightController,
                          label: 'Copyright',
                          icon:
                              Icons.copyright_outlined,
                        ),

                        const SizedBox(height: 35),

                        // ==================================================
                        // TOMBOL SIMPAN
                        // ==================================================

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isSaving
                                ? null
                                : _simpanPengaturan,

                            icon: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.save,
                                  ),

                            label: Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 13,
                              ),
                              child: Text(
                                _isSaving
                                    ? 'Menyimpan...'
                                    : 'Simpan Pengaturan',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // ============================================================
  // JUDUL SECTION
  // ============================================================

  Widget _sectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.lightGreen,
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.primary,
          ),
        ),

        const SizedBox(width: 12),

        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,

      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppTheme.primary,
            width: 2,
          ),
        ),
      ),

      validator: (value) {
        if (value == null ||
            value.trim().isEmpty) {
          return '$label wajib diisi.';
        }

        return null;
      },
    );
  }
}