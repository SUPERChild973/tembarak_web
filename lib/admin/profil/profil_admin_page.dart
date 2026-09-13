import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../services/profil_service.dart';

class ProfilAdminPage extends StatefulWidget {
  const ProfilAdminPage({super.key});

  @override
  State<ProfilAdminPage> createState() => _ProfilAdminPageState();
}

class _ProfilAdminPageState extends State<ProfilAdminPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaDesaController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kabupatenController = TextEditingController();
  final _provinsiController = TextEditingController();
  final _sejarahController = TextEditingController();
  final _visiController = TextEditingController();
  final _misiController = TextEditingController();
  final _kondisiController = TextEditingController();
  final _potensiController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  final _emailController = TextEditingController();

  final ProfilService _profilService = ProfilService();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    try {
      final data = await _profilService.getProfil();

      if (data != null) {
        _namaDesaController.text = data['namaDesa'] ?? '';
        _kecamatanController.text = data['kecamatan'] ?? '';
        _kabupatenController.text = data['kabupaten'] ?? '';
        _provinsiController.text = data['provinsi'] ?? '';
        _sejarahController.text = data['sejarah'] ?? '';
        _visiController.text = data['visi'] ?? '';
        _misiController.text = data['misi'] ?? '';
        _kondisiController.text = data['kondisi'] ?? '';
        _potensiController.text = data['potensi'] ?? '';
        _alamatController.text = data['alamat'] ?? '';
        _teleponController.text = data['telepon'] ?? '';
        _emailController.text = data['email'] ?? '';
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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

  Future<void> _saveProfil() async {
    if (!_formKey.currentState!.validate()) {
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
        kondisi: _kondisiController.text.trim(),
        potensi: _potensiController.text.trim(),
        alamat: _alamatController.text.trim(),
        telepon: _teleponController.text.trim(),
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profil desa berhasil disimpan.',
          ),
          backgroundColor: AppTheme.primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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

  @override
  void dispose() {
    _namaDesaController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _provinsiController.dispose();
    _sejarahController.dispose();
    _visiController.dispose();
    _misiController.dispose();
    _kondisiController.dispose();
    _potensiController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppTheme.primary,
            width: 2,
          ),
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return '$label wajib diisi.';
              }
              return null;
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Profil Desa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Dasar Desa',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 18),

                        _textField(
                          label: 'Nama Desa',
                          hint: 'Masukkan nama desa',
                          controller: _namaDesaController,
                          required: true,
                        ),
                        const SizedBox(height: 15),

                        _textField(
                          label: 'Kecamatan',
                          hint: 'Masukkan nama kecamatan',
                          controller: _kecamatanController,
                        ),
                        const SizedBox(height: 15),

                        _textField(
                          label: 'Kabupaten',
                          hint: 'Masukkan nama kabupaten',
                          controller: _kabupatenController,
                        ),
                        const SizedBox(height: 15),

                        _textField(
                          label: 'Provinsi',
                          hint: 'Masukkan nama provinsi',
                          controller: _provinsiController,
                        ),

                        const SizedBox(height: 35),

                        const Text(
                          'Sejarah Desa',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 18),

                        _textField(
                          label: 'Sejarah',
                          hint: 'Tuliskan sejarah desa...',
                          controller: _sejarahController,
                          maxLines: 7,
                        ),

                        const SizedBox(height: 35),

                        const Text(
                          'Visi & Misi',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 18),

                        _textField(
                          label: 'Visi',
                          hint: 'Tuliskan visi desa...',
                          controller: _visiController,
                          maxLines: 5,
                        ),
                        const SizedBox(height: 15),

                        _textField(
                          label: 'Misi',
                          hint: 'Tuliskan misi desa...',
                          controller: _misiController,
                          maxLines: 7,
                        ),

                        const SizedBox(height: 35),

                        const Text(
                          'Kondisi & Potensi Desa',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 18),

                        _textField(
                          label: 'Kondisi Desa',
                          hint: 'Tuliskan kondisi desa...',
                          controller: _kondisiController,
                          maxLines: 7,
                        ),
                        const SizedBox(height: 15),

                        _textField(
                          label: 'Potensi Desa',
                          hint: 'Tuliskan potensi desa...',
                          controller: _potensiController,
                          maxLines: 7,
                        ),

                        const SizedBox(height: 35),

                        const Text(
                          'Kontak Desa',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 18),

                        _textField(
                          label: 'Alamat Kantor Desa',
                          hint: 'Masukkan alamat kantor desa',
                          controller: _alamatController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 15),

                        _textField(
                          label: 'Nomor Telepon',
                          hint: 'Masukkan nomor telepon desa',
                          controller: _teleponController,
                        ),
                        const SizedBox(height: 15),

                        _textField(
                          label: 'Email Desa',
                          hint: 'Masukkan email desa',
                          controller: _emailController,
                        ),

                        const SizedBox(height: 35),

                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGreen,
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: const Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppTheme.primary,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Data yang disimpan di sini akan '
                                  'digunakan untuk menampilkan '
                                  'informasi desa pada website publik.',
                                  style: TextStyle(
                                    color: AppTheme.primary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                _isSaving ? null : _saveProfil,
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<
                                              Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.save_outlined),
                            label: Text(
                              _isSaving
                                  ? 'Menyimpan...'
                                  : 'Simpan Profil Desa',
                            ),
                            style:
                                ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 18,
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
}