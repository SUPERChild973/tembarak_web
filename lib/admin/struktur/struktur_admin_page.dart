import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/perangkat.dart';
import '../../services/perangkat_service.dart';
import '../../services/storage_service.dart';

class StrukturAdminPage extends StatefulWidget {
  const StrukturAdminPage({super.key});

  @override
  State<StrukturAdminPage> createState() =>
      _StrukturAdminPageState();
}

class _StrukturAdminPageState
    extends State<StrukturAdminPage> {
  final PerangkatService _perangkatService =
      PerangkatService();

  final StorageService _storageService =
      StorageService();

  // ============================================================
  // TAMBAH
  // ============================================================

  Future<void> _tambah() async {
    await showDialog(
      context: context,
      builder: (_) => _FormPerangkat(
        perangkatService: _perangkatService,
        storageService: _storageService,
      ),
    );
  }

  // ============================================================
  // EDIT
  // ============================================================

  Future<void> _edit(
    Perangkat perangkat,
  ) async {
    await showDialog(
      context: context,
      builder: (_) => _FormPerangkat(
        perangkat: perangkat,
        perangkatService: _perangkatService,
        storageService: _storageService,
      ),
    );
  }

  // ============================================================
  // HAPUS
  // ============================================================

  Future<void> _hapus(
    Perangkat perangkat,
  ) async {
    final yakin =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${perangkat.nama}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (yakin != true) return;

    try {
      await _perangkatService
          .hapusPerangkat(
        perangkat.id,
      );

      if (perangkat.fotoUrl.isNotEmpty) {
        await _storageService.hapusFoto(
          perangkat.fotoUrl,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Data berhasil dihapus.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menghapus data: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Struktur Desa',
        ),
      ),
      body: StreamBuilder<List<Perangkat>>(
        stream:
            _perangkatService.getPerangkat(),
        builder:
            (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan:\n'
                '${snapshot.error}',
                textAlign:
                    TextAlign.center,
              ),
            );
          }

          final data =
              snapshot.data ?? [];

          return SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Struktur Pemerintahan Desa',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Kelola data perangkat desa.',
                              style: TextStyle(
                                color:
                                    Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: _tambah,
                          icon:
                              const Icon(
                            Icons.add,
                          ),
                          label:
                              const Text(
                            'Tambah Perangkat',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    if (data.isEmpty)
                      _Kosong()
                    else
                      LayoutBuilder(
                        builder: (
                          context,
                          constraints,
                        ) {
                          int kolom = 1;

                          if (constraints
                                  .maxWidth >=
                              900) {
                            kolom = 3;
                          } else if (constraints
                                  .maxWidth >=
                              600) {
                            kolom = 2;
                          }

                          return GridView
                              .builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount:
                                data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  kolom,
                              crossAxisSpacing:
                                  20,
                              mainAxisSpacing:
                                  20,
                              childAspectRatio:
                                  0.65,
                            ),
                            itemBuilder:
                                (
                              context,
                              index,
                            ) {
                              final perangkat =
                                  data[index];

                              return _KartuPerangkat(
                                perangkat:
                                    perangkat,
                                onEdit: () =>
                                    _edit(
                                  perangkat,
                                ),
                                onDelete: () =>
                                    _hapus(
                                  perangkat,
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================================================================
// DATA KOSONG
// ================================================================

class _Kosong
    extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 70,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Belum ada perangkat desa.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// KARTU PERANGKAT
// ================================================================

class _KartuPerangkat
    extends StatelessWidget {
  final Perangkat perangkat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _KartuPerangkat({
    required this.perangkat,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      clipBehavior:
          Clip.antiAlias,
      elevation: 2,
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              color:
                  AppTheme.lightGreen,
              child: perangkat
                      .fotoUrl
                      .isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 80,
                      color:
                          AppTheme.primary,
                    )
                  : Image.network(
                      perangkat.fotoUrl,
                      width:
                          double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Icon(
                          Icons
                              .broken_image,
                          size: 60,
                          color:
                              Colors.grey,
                        );
                      },
                    ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    perangkat.nama,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    perangkat.jabatan,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color:
                          AppTheme.primary,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  if (perangkat
                      .keterangan
                      .trim()
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      perangkat
                          .keterangan,
                      maxLines: 3,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Colors.grey,
                      ),
                    ),
                  ],

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child:
                            OutlinedButton
                                .icon(
                          onPressed:
                              onEdit,
                          icon:
                              const Icon(
                            Icons.edit,
                            size: 18,
                          ),
                          label:
                              const Text(
                            'Edit',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      IconButton(
                        onPressed:
                            onDelete,
                        color:
                            Colors.red,
                        tooltip:
                            'Hapus',
                        icon:
                            const Icon(
                          Icons
                              .delete_outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// FORM PERANGKAT
// ================================================================

class _FormPerangkat
    extends StatefulWidget {
  final Perangkat? perangkat;
  final PerangkatService perangkatService;
  final StorageService storageService;

  const _FormPerangkat({
    this.perangkat,
    required this.perangkatService,
    required this.storageService,
  });

  @override
  State<_FormPerangkat> createState() =>
      _FormPerangkatState();
}

class _FormPerangkatState
    extends State<_FormPerangkat> {
  final _formKey =
      GlobalKey<FormState>();

  late TextEditingController
      _namaController;

  late TextEditingController
      _jabatanController;

  late TextEditingController
      _keteranganController;

  late TextEditingController
      _urutanController;

  Uint8List? _fotoBaru;
  String? _namaFile;

  String _fotoLama = '';

  bool _loading = false;

  // Progress 0 - 1
  double _uploadProgress = 0;

  @override
  void initState() {
    super.initState();

    final data =
        widget.perangkat;

    _namaController =
        TextEditingController(
      text: data?.nama ?? '',
    );

    _jabatanController =
        TextEditingController(
      text: data?.jabatan ?? '',
    );

    _keteranganController =
        TextEditingController(
      text: data?.keterangan ?? '',
    );

    _urutanController =
        TextEditingController(
      text: '1',
    );

    _fotoLama =
        data?.fotoUrl ?? '';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jabatanController.dispose();
    _keteranganController.dispose();
    _urutanController.dispose();

    super.dispose();
  }

  // ============================================================
  // PILIH FOTO
  // ============================================================

  Future<void> _pilihFoto() async {
    try {
      final result =
          await FilePicker.platform
              .pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null) {
        return;
      }

      final file =
          result.files.first;

      if (file.bytes == null) {
        _pesan(
          'Foto tidak dapat dibaca.',
        );
        return;
      }

      // Batas ukuran foto asli.
      // 10 MB cukup untuk foto perangkat.
      const maxSize =
          10 * 1024 * 1024;

      if (file.bytes!.length >
          maxSize) {
        _pesan(
          'Ukuran foto terlalu besar. '
          'Maksimal 10 MB.',
        );
        return;
      }

      setState(() {
        _fotoBaru =
            file.bytes;
        _namaFile =
            file.name;
      });
    } catch (e) {
      _pesan(
        'Gagal memilih foto: $e',
      );
    }
  }

  // ============================================================
  // UPLOAD FOTO
  // ============================================================

  Future<String> _uploadFoto() async {
    // Tidak memilih foto baru.
    if (_fotoBaru == null) {
      return _fotoLama;
    }

    final url =
        await widget.storageService
            .uploadPerangkatFoto(
      bytes: _fotoBaru!,
      fileName:
          _namaFile ?? 'foto.jpg',

      // Progress upload
      onProgress:
          (progress) {
        if (!mounted) return;

        setState(() {
          _uploadProgress =
              progress;
        });
      },
    );

    // Hapus foto lama SETELAH
    // foto baru berhasil diupload.
    if (_fotoLama.isNotEmpty) {
      await widget.storageService
          .hapusFoto(
        _fotoLama,
      );
    }

    return url;
  }

  // ============================================================
  // SIMPAN
  // ============================================================

  Future<void> _simpan() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    setState(() {
      _loading = true;
      _uploadProgress = 0;
    });

    try {
      // --------------------------------------------------------
      // Upload foto
      // --------------------------------------------------------

      final fotoUrl =
          await _uploadFoto();

      // --------------------------------------------------------
      // Urutan
      // --------------------------------------------------------

      final urutan =
          int.tryParse(
                _urutanController
                    .text
                    .trim(),
              ) ??
              1;

      // --------------------------------------------------------
      // Tambah data
      // --------------------------------------------------------

      if (widget.perangkat ==
          null) {
        await widget
            .perangkatService
            .tambahPerangkat(
          nama: _namaController
              .text
              .trim(),
          jabatan:
              _jabatanController
                  .text
                  .trim(),
          fotoUrl: fotoUrl,
          keterangan:
              _keteranganController
                  .text
                  .trim(),
          urutan: urutan,
        );
      }

      // --------------------------------------------------------
      // Update data
      // --------------------------------------------------------

      else {
        await widget
            .perangkatService
            .updatePerangkat(
          id: widget
              .perangkat!
              .id,
          nama: _namaController
              .text
              .trim(),
          jabatan:
              _jabatanController
                  .text
                  .trim(),
          fotoUrl: fotoUrl,
          keterangan:
              _keteranganController
                  .text
                  .trim(),
          urutan: urutan,
        );
      }

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            widget.perangkat ==
                    null
                ? 'Data berhasil ditambahkan.'
                : 'Data berhasil diperbarui.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      _pesan(
        'Gagal menyimpan data: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // ============================================================
  // PESAN
  // ============================================================

  void _pesan(
    String text,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content:
            Text(text),
      ),
    );
  }

  // ============================================================
  // BUILD FORM
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final edit =
        widget.perangkat !=
            null;

    return AlertDialog(
      title: Text(
        edit
            ? 'Edit Perangkat Desa'
            : 'Tambah Perangkat Desa',
      ),

      content: SizedBox(
        width: 500,
        child:
            SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _PreviewFoto(
                  fotoBaru:
                      _fotoBaru,
                  fotoLama:
                      _fotoLama,
                ),

                const SizedBox(
                  height: 14,
                ),

                // ------------------------------------------------
                // PILIH FOTO
                // ------------------------------------------------

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      ElevatedButton
                          .icon(
                    onPressed:
                        _loading
                            ? null
                            : _pilihFoto,
                    icon:
                        const Icon(
                      Icons
                          .photo_library,
                    ),
                    label:
                        Text(
                      _fotoBaru ==
                              null
                          ? 'Pilih Foto dari Perangkat'
                          : 'Ganti Foto',
                    ),
                  ),
                ),

                if (_namaFile !=
                    null) ...[
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    _namaFile!,
                    textAlign:
                        TextAlign
                            .center,
                    style:
                        const TextStyle(
                      color:
                          Colors.grey,
                    ),
                  ),
                ],

                const SizedBox(
                  height: 20,
                ),

                // ------------------------------------------------
                // PROGRESS UPLOAD
                // ------------------------------------------------

                if (_loading &&
                    _fotoBaru !=
                        null) ...[
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value:
                            _uploadProgress >
                                    0
                                ? _uploadProgress
                                : null,
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        _uploadProgress >
                                0
                            ? 'Mengupload foto '
                                '${(_uploadProgress * 100).toStringAsFixed(0)}%'
                            : 'Menyiapkan foto...',
                        style:
                            const TextStyle(
                          fontSize:
                              13,
                          color:
                              Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],

                // ------------------------------------------------
                // NAMA
                // ------------------------------------------------

                TextFormField(
                  controller:
                      _namaController,
                  enabled:
                      !_loading,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Nama',
                    hintText:
                        'Contoh: Budi Santoso',
                    border:
                        OutlineInputBorder(),
                  ),
                  validator:
                      (value) {
                    if (value ==
                            null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Nama wajib diisi.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 16,
                ),

                // ------------------------------------------------
                // JABATAN
                // ------------------------------------------------

                TextFormField(
                  controller:
                      _jabatanController,
                  enabled:
                      !_loading,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Jabatan',
                    hintText:
                        'Contoh: Kepala Desa',
                    border:
                        OutlineInputBorder(),
                  ),
                  validator:
                      (value) {
                    if (value ==
                            null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Jabatan wajib diisi.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 16,
                ),

                // ------------------------------------------------
                // KETERANGAN
                // ------------------------------------------------

                TextFormField(
                  controller:
                      _keteranganController,
                  enabled:
                      !_loading,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Keterangan',
                    hintText:
                        'Keterangan tambahan',
                    border:
                        OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // ------------------------------------------------
                // URUTAN
                // ------------------------------------------------

                TextFormField(
                  controller:
                      _urutanController,
                  enabled:
                      !_loading,
                  keyboardType:
                      TextInputType
                          .number,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Urutan',
                    hintText:
                        'Contoh: 1',
                    border:
                        OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ==========================================================
      // BUTTON
      // ==========================================================

      actions: [
        TextButton(
          onPressed:
              _loading
                  ? null
                  : () =>
                      Navigator.pop(
                    context,
                  ),
          child:
              const Text(
            'Batal',
          ),
        ),

        ElevatedButton.icon(
          onPressed:
              _loading
                  ? null
                  : _simpan,
          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                        Colors.white,
                  ),
                )
              : const Icon(
                  Icons.save,
                ),
          label: Text(
            _loading
                ? 'Mengupload...'
                : 'Simpan',
          ),
        ),
      ],
    );
  }
}

// ================================================================
// PREVIEW FOTO
// ================================================================

class _PreviewFoto
    extends StatelessWidget {
  final Uint8List? fotoBaru;
  final String fotoLama;

  const _PreviewFoto({
    required this.fotoBaru,
    required this.fotoLama,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    Widget isi;

    if (fotoBaru != null) {
      isi = Image.memory(
        fotoBaru!,
        width:
            double.infinity,
        height:
            double.infinity,
        fit: BoxFit.cover,
      );
    } else if (fotoLama.isNotEmpty) {
      isi = Image.network(
        fotoLama,
        width:
            double.infinity,
        height:
            double.infinity,
        fit: BoxFit.cover,
        errorBuilder:
            (
          context,
          error,
          stackTrace,
        ) {
          return const Icon(
            Icons.broken_image,
            size: 60,
          );
        },
      );
    } else {
      isi = const Icon(
        Icons.person,
        size: 80,
        color:
            AppTheme.primary,
      );
    }

    return Container(
      width: 180,
      height: 180,
      clipBehavior:
          Clip.antiAlias,
      decoration:
          BoxDecoration(
        color:
            AppTheme.lightGreen,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: isi,
    );
  }
}