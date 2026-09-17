import 'package:flutter/material.dart';

import '../../config/app_theme.dart';

class PengaturanAdminPage extends StatefulWidget {
  const PengaturanAdminPage({super.key});

  @override
  State<PengaturanAdminPage> createState() =>
      _PengaturanAdminPageState();
}

class _PengaturanAdminPageState
    extends State<PengaturanAdminPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaDesaController =
      TextEditingController(
    text: 'Desa Tembarak',
  );

  final _kecamatanController =
      TextEditingController(
    text: 'Kecamatan Tembarak',
  );

  final _kabupatenController =
      TextEditingController(
    text: 'Kabupaten Temanggung',
  );

  final _alamatController =
      TextEditingController(
    text: 'Desa Tembarak',
  );

  final _teleponController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  @override
  void dispose() {
    _namaDesaController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void _simpanPengaturan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pengaturan berhasil disimpan.',
        ),
      ),
    );
  }

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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 850),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
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

                  _field(
                    controller:
                        _namaDesaController,
                    label: 'Nama Desa',
                    icon: Icons.home_work_outlined,
                  ),

                  const SizedBox(height: 18),

                  _field(
                    controller:
                        _kecamatanController,
                    label: 'Kecamatan',
                    icon: Icons.location_city,
                  ),

                  const SizedBox(height: 18),

                  _field(
                    controller:
                        _kabupatenController,
                    label: 'Kabupaten',
                    icon: Icons.map_outlined,
                  ),

                  const SizedBox(height: 18),

                  _field(
                    controller:
                        _alamatController,
                    label: 'Alamat Kantor Desa',
                    icon: Icons.location_on_outlined,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 18),

                  _field(
                    controller:
                        _teleponController,
                    label: 'Nomor Telepon',
                    icon: Icons.phone_outlined,
                    keyboardType:
                        TextInputType.phone,
                  ),

                  const SizedBox(height: 18),

                  _field(
                    controller:
                        _emailController,
                    label: 'Email Desa',
                    icon: Icons.email_outlined,
                    keyboardType:
                        TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          _simpanPengaturan,
                      icon: const Icon(Icons.save),
                      label: const Padding(
                        padding:
                            EdgeInsets.symmetric(
                          vertical: 13,
                        ),
                        child: Text(
                          'Simpan Pengaturan',
                          style: TextStyle(
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
          borderRadius: BorderRadius.circular(14),
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