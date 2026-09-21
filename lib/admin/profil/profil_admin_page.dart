import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../services/profil_service.dart';
import '../../services/storage_service.dart';

class ProfilAdminPage extends StatefulWidget {
  const ProfilAdminPage({super.key});

  @override
  State<ProfilAdminPage> createState() => _ProfilAdminPageState();
}

class _ProfilAdminPageState extends State<ProfilAdminPage> {
  final ProfilService _profilService = ProfilService();
  final StorageService _storageService = StorageService();

  // =========================
  // CONTROLLERS
  // =========================

  final _namaDesaController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kabupatenController = TextEditingController();
  final _provinsiController = TextEditingController();

  final _sejarahController = TextEditingController();
  final _visiController = TextEditingController();
  final _misiController = TextEditingController();

  // FILOSOFI LOGO
  final _filosofiLogoController = TextEditingController();

  // URL LOGO
  String _logoUrl = '';

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isUploadingLogo = false;

  // =========================
  // INIT
  // =========================

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    _namaDesaController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _provinsiController.dispose();

    _sejarahController.dispose();
    _visiController.dispose();
    _misiController.dispose();

    _filosofiLogoController.dispose();

    super.dispose();
  }

  // =========================
  // LOAD PROFIL
  // =========================

  Future<void> _loadProfil() async {
    try {
      final data = await _profilService.getProfil();

      if (!mounted) return;

      if (data != null) {
        _namaDesaController.text =
            data['namaDesa']?.toString() ?? '';

        _kecamatanController.text =
            data['kecamatan']?.toString() ?? '';

        _kabupatenController.text =
            data['kabupaten']?.toString() ?? '';

        _provinsiController.text =
            data['provinsi']?.toString() ?? '';

        _sejarahController.text =
            data['sejarah']?.toString() ?? '';

        _visiController.text =
            data['visi']?.toString() ?? '';

        _misiController.text =
            data['misi']?.toString() ?? '';

        _logoUrl =
            data['logoUrl']?.toString() ?? '';

        _filosofiLogoController.text =
            data['filosofiLogo']?.toString() ?? '';
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memuat profil desa: $e',
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

  // =========================
  // UPLOAD LOGO DESA
  // =========================

  Future<void> _uploadLogoDesa() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null) {
        return;
      }

      final file = result.files.single;

      if (file.bytes == null) {
        _showMessage(
          'File logo tidak dapat dibaca.',
          isError: true,
        );
        return;
      }

      setState(() {
        _isUploadingLogo = true;
      });

      final url = await _storageService.uploadFoto(
        bytes: file.bytes!,
        fileName: file.name,
        folder: 'desa-tembarak/logo',
      );

      if (!mounted) return;

      setState(() {
        _logoUrl = url;
      });

      _showMessage(
        'Logo desa berhasil diupload. Jangan lupa klik Simpan Profil Desa.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Gagal mengupload logo desa: $e',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingLogo = false;
        });
      }
    }
  }

  // =========================
  // HAPUS LOGO DARI FORM
  // =========================

  void _removeLogo() {
    setState(() {
      _logoUrl = '';
    });

    _showMessage(
      'Logo dihapus dari form. Klik Simpan Profil Desa untuk menyimpan perubahan.',
    );
  }

  // =========================
  // SAVE PROFIL
  // =========================

  Future<void> _saveProfil() async {
    if (_namaDesaController.text.trim().isEmpty) {
      _showMessage(
        'Nama desa wajib diisi.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _profilService.saveProfil(
        namaDesa: _namaDesaController.text.trim(),
        kecamatan: _kecamatanController.text.trim(),
        kabupaten: _kabupatenController.text.trim(),
        provinsi: _provinsiController.text.trim(),
        sejarah: _sejarahController.text.trim(),
        visi: _visiController.text.trim(),
        misi: _misiController.text.trim(),
        logoUrl: _logoUrl.trim(),
        filosofiLogo:
            _filosofiLogoController.text.trim(),
      );

      if (!mounted) return;

      _showMessage(
        'Profil desa berhasil disimpan.',
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Gagal menyimpan profil desa: $e',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // =========================
  // MESSAGE
  // =========================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red : AppTheme.primary,
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // =========================
      // APP BAR
      // =========================

      appBar: AppBar(
        title: const Text(
          'Profil Desa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // BODY
      // =========================

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      // =========================
                      // HEADER
                      // =========================

                      const Text(
                        'Profil Desa',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Kelola informasi profil dan gambaran umum desa.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // =========================
                      // INFORMASI DASAR
                      // =========================

                      _sectionCard(
                        title: 'Informasi Dasar Desa',
                        icon: Icons.account_balance_outlined,
                        child: Column(
                          children: [
                            _textField(
                              controller:
                                  _namaDesaController,
                              label: 'Nama Desa',
                              hint:
                                  'Masukkan nama desa',
                              icon:
                                  Icons.home_outlined,
                            ),

                            const SizedBox(height: 18),

                            _textField(
                              controller:
                                  _kecamatanController,
                              label: 'Kecamatan',
                              hint:
                                  'Masukkan nama kecamatan',
                              icon:
                                  Icons.location_city_outlined,
                            ),

                            const SizedBox(height: 18),

                            _textField(
                              controller:
                                  _kabupatenController,
                              label: 'Kabupaten',
                              hint:
                                  'Masukkan nama kabupaten',
                              icon:
                                  Icons.map_outlined,
                            ),

                            const SizedBox(height: 18),

                            _textField(
                              controller:
                                  _provinsiController,
                              label: 'Provinsi',
                              hint:
                                  'Masukkan nama provinsi',
                              icon:
                                  Icons.public_outlined,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // =========================
                      // SEJARAH
                      // =========================

                      _sectionCard(
                        title: 'Sejarah Desa',
                        icon:
                            Icons.history_edu_outlined,
                        child: _textField(
                          controller:
                              _sejarahController,
                          label: 'Sejarah Desa',
                          hint:
                              'Tuliskan sejarah Desa...',
                          maxLines: 8,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // =========================
                      // VISI & MISI
                      // =========================

                      _sectionCard(
                        title: 'Visi & Misi',
                        icon:
                            Icons.visibility_outlined,
                        child: Column(
                          children: [
                            _textField(
                              controller:
                                  _visiController,
                              label: 'Visi Desa',
                              hint:
                                  'Tuliskan visi desa...',
                              maxLines: 5,
                            ),

                            const SizedBox(height: 18),

                            _textField(
                              controller:
                                  _misiController,
                              label: 'Misi Desa',
                              hint:
                                  'Tuliskan misi desa...',
                              maxLines: 8,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // =========================
                      // LOGO & FILOSOFI LOGO
                      // =========================

                      _sectionCard(
                        title:
                            'Logo & Filosofi Logo Desa',
                        icon:
                            Icons.shield_outlined,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            const Text(
                              'Logo Desa',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // =========================
                            // PREVIEW LOGO
                            // =========================

                            Container(
                              width: double.infinity,
                              height: 240,
                              decoration:
                                  BoxDecoration(
                                color:
                                    AppTheme.lightGreen,
                                borderRadius:
                                    BorderRadius
                                        .circular(16),
                                border: Border.all(
                                  color:
                                      Colors.black12,
                                ),
                              ),
                              child: _logoUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  16),
                                      child:
                                          Image.network(
                                        _logoUrl,
                                        fit:
                                            BoxFit.contain,
                                        errorBuilder:
                                            (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const Center(
                                            child: Icon(
                                              Icons
                                                  .broken_image_outlined,
                                              size: 60,
                                              color: Colors
                                                  .black38,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                        children: [
                                          Icon(
                                            Icons
                                                .shield_outlined,
                                            size: 65,
                                            color: AppTheme
                                                .primary,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Belum ada logo desa',
                                            style:
                                                TextStyle(
                                              color: Colors
                                                  .black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),

                            const SizedBox(height: 15),

                            // =========================
                            // BUTTON LOGO
                            // =========================

                            Row(
                              children: [

                                OutlinedButton.icon(
                                  onPressed:
                                      _isUploadingLogo
                                          ? null
                                          : _uploadLogoDesa,
                                  icon: _isUploadingLogo
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons
                                              .upload_outlined,
                                        ),
                                  label: Text(
                                    _isUploadingLogo
                                        ? 'Mengupload...'
                                        : 'Upload Logo Desa',
                                  ),
                                ),

                                if (_logoUrl
                                    .isNotEmpty) ...[
                                  const SizedBox(width: 10),

                                  OutlinedButton.icon(
                                    onPressed:
                                        _isUploadingLogo
                                            ? null
                                            : _removeLogo,
                                    icon: const Icon(
                                      Icons
                                          .delete_outline,
                                      color: Colors.red,
                                    ),
                                    label:
                                        const Text(
                                      'Hapus',
                                      style:
                                          TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            const SizedBox(height: 25),

                            // =========================
                            // FILOSOFI LOGO
                            // =========================

                            _textField(
                              controller:
                                  _filosofiLogoController,
                              label:
                                  'Filosofi Logo Desa',
                              hint:
                                  'Jelaskan makna dan filosofi setiap unsur pada logo desa...',
                              maxLines: 10,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // =========================
                      // INFO KONTAK
                      // =========================

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightGreen,
                          borderRadius:
                              BorderRadius.circular(
                                  18),
                        ),
                        child: const Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color:
                                  AppTheme.primary,
                            ),

                            SizedBox(width: 15),

                            Expanded(
                              child: Text(
                                'Informasi alamat kantor desa, nomor telepon, '
                                'dan email dikelola melalui menu Pengaturan.',
                                style: TextStyle(
                                  color:
                                      AppTheme.primary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // =========================
                      // BUTTON SIMPAN
                      // =========================

                      SizedBox(
                        width: double.infinity,
                        child:
                            ElevatedButton.icon(
                          onPressed: _isSaving
                              ? null
                              : _saveProfil,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color:
                                        Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons
                                      .save_outlined,
                                ),
                          label: Text(
                            _isSaving
                                ? 'Menyimpan...'
                                : 'Simpan Profil Desa',
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // =========================
  // SECTION CARD
  // =========================

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightGreen,
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color:
                      AppTheme.primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          child,
        ],
      ),
    );
  }

  // =========================
  // TEXT FIELD
  // =========================

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon:
            maxLines == 1 && icon != null
                ? Icon(icon)
                : null,

        alignLabelWithHint:
            maxLines > 1,

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide:
              const BorderSide(
            color: Colors.black12,
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide:
              const BorderSide(
            color: AppTheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}