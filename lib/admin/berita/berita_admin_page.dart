import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/berita.dart';
import '../../services/berita_service.dart';
import '../../services/storage_service.dart';

class BeritaAdminPage extends StatefulWidget {
  const BeritaAdminPage({super.key});

  @override
  State<BeritaAdminPage> createState() =>
      _BeritaAdminPageState();
}

class _BeritaAdminPageState
    extends State<BeritaAdminPage> {
  final BeritaService _beritaService =
      BeritaService();

  final StorageService _storageService =
      StorageService();

  void _showForm({
    Berita? berita,
  }) {
    final judulController =
        TextEditingController(
      text: berita?.judul ?? '',
    );

    final kategoriController =
        TextEditingController(
      text: berita?.kategori ?? '',
    );

    final ringkasanController =
        TextEditingController(
      text: berita?.ringkasan ?? '',
    );

    final isiController =
        TextEditingController(
      text: berita?.isi ?? '',
    );

    Uint8List? selectedImageBytes;
    String? selectedImageName;

    String fotoUrl =
        berita?.fotoUrl ?? '';

    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            Future<void> pilihGambar() async {
              final result =
                  await FilePicker.platform.pickFiles(
                type: FileType.image,
                withData: true,
              );

              if (result == null) {
                return;
              }

              final file =
                  result.files.single;

              if (file.bytes == null) {
                return;
              }

              setDialogState(() {
                selectedImageBytes =
                    file.bytes;

                selectedImageName =
                    file.name;
              });
            }

            Future<void> simpan() async {
              if (judulController.text
                  .trim()
                  .isEmpty) {
                _showMessage(
                  'Judul berita wajib diisi.',
                );
                return;
              }

              if (kategoriController.text
                  .trim()
                  .isEmpty) {
                _showMessage(
                  'Kategori berita wajib diisi.',
                );
                return;
              }

              if (ringkasanController.text
                  .trim()
                  .isEmpty) {
                _showMessage(
                  'Ringkasan berita wajib diisi.',
                );
                return;
              }

              if (isiController.text
                  .trim()
                  .isEmpty) {
                _showMessage(
                  'Isi berita wajib diisi.',
                );
                return;
              }

              if (berita == null &&
                  selectedImageBytes == null) {
                _showMessage(
                  'Silakan pilih gambar berita.',
                );
                return;
              }

              try {
                setDialogState(() {
                  isLoading = true;
                });

                // ==========================================
                // UPLOAD FOTO BARU
                // ==========================================

                if (selectedImageBytes != null) {
                  fotoUrl =
                      await _storageService
                          .uploadBeritaFoto(
                    bytes:
                        selectedImageBytes!,
                    fileName:
                        selectedImageName ??
                            'berita.jpg',
                  );
                }

                // ==========================================
                // TAMBAH
                // ==========================================

                if (berita == null) {
                  await _beritaService
                      .tambahBerita(
                    judul:
                        judulController.text
                            .trim(),
                    kategori:
                        kategoriController.text
                            .trim(),
                    fotoUrl: fotoUrl,
                    ringkasan:
                        ringkasanController
                            .text
                            .trim(),
                    isi:
                        isiController.text
                            .trim(),
                  );
                }

                // ==========================================
                // EDIT
                // ==========================================

                else {
                  await _beritaService
                      .updateBerita(
                    id: berita.id,
                    judul:
                        judulController.text
                            .trim(),
                    kategori:
                        kategoriController.text
                            .trim(),
                    fotoUrl: fotoUrl,
                    ringkasan:
                        ringkasanController
                            .text
                            .trim(),
                    isi:
                        isiController.text
                            .trim(),
                  );
                }

                if (!dialogContext.mounted) {
                  return;
                }

                Navigator.pop(dialogContext);

                _showMessage(
                  berita == null
                      ? 'Berita berhasil ditambahkan.'
                      : 'Berita berhasil diperbarui.',
                );
              } catch (e) {
                setDialogState(() {
                  isLoading = false;
                });

                _showMessage(
                  'Gagal menyimpan berita: $e',
                );
              }
            }

            return AlertDialog(
              title: Text(
                berita == null
                    ? 'Tambah Berita'
                    : 'Edit Berita',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              content: SizedBox(
                width: 650,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // ======================================
                      // GAMBAR
                      // ======================================

                      const Text(
                        'Gambar Berita',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : pilihGambar,
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          decoration:
                              BoxDecoration(
                            color:
                                AppTheme.lightGreen,
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                            border: Border.all(
                              color: AppTheme.primary
                                  .withOpacity(
                                0.15,
                              ),
                            ),
                          ),
                          child:
                              selectedImageBytes !=
                                      null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        15,
                                      ),
                                      child:
                                          Image.memory(
                                        selectedImageBytes!,
                                        width:
                                            double.infinity,
                                        height: 220,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : fotoUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                            15,
                                          ),
                                          child:
                                              Image.network(
                                            fotoUrl,
                                            width:
                                                double.infinity,
                                            height: 220,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .cloud_upload_outlined,
                                              size: 50,
                                              color:
                                                  AppTheme.primary,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Klik untuk memilih gambar',
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'JPG, PNG, JPEG',
                                              style:
                                                  TextStyle(
                                                color:
                                                    Colors.black54,
                                                fontSize:
                                                    12,
                                              ),
                                            ),
                                          ],
                                        ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ======================================
                      // JUDUL
                      // ======================================

                      TextField(
                        controller:
                            judulController,
                        enabled: !isLoading,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Judul Berita',
                          hintText:
                              'Masukkan judul berita',
                          border:
                              OutlineInputBorder(),
                          prefixIcon:
                              Icon(
                            Icons.title,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ======================================
                      // KATEGORI
                      // ======================================

                      TextField(
                        controller:
                            kategoriController,
                        enabled: !isLoading,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Kategori',
                          hintText:
                              'Contoh: Kegiatan Desa',
                          border:
                              OutlineInputBorder(),
                          prefixIcon:
                              Icon(
                            Icons.category_outlined,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ======================================
                      // RINGKASAN
                      // ======================================

                      TextField(
                        controller:
                            ringkasanController,
                        enabled: !isLoading,
                        maxLines: 3,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Ringkasan Berita',
                          hintText:
                              'Ringkasan yang ditampilkan pada kartu berita',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ======================================
                      // ISI
                      // ======================================

                      TextField(
                        controller:
                            isiController,
                        enabled: !isLoading,
                        maxLines: 10,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Isi Berita Lengkap',
                          hintText:
                              'Masukkan isi berita lengkap...',
                          border:
                              OutlineInputBorder(),
                          alignLabelWithHint:
                              true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.pop(
                            dialogContext,
                          );
                        },
                  child:
                      const Text('Batal'),
                ),

                ElevatedButton.icon(
                  onPressed:
                      isLoading ? null : simpan,
                  icon: isLoading
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
                    isLoading
                        ? 'Menyimpan...'
                        : 'Simpan',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // HAPUS
  // ============================================================

  void _hapusBerita(
    Berita berita,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Hapus Berita',
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus berita "${berita.judul}"?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child:
                  const Text('Batal'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await _beritaService
                      .hapusBerita(
                    berita.id,
                  );

                  _showMessage(
                    'Berita berhasil dihapus.',
                  );
                } catch (e) {
                  _showMessage(
                    'Gagal menghapus berita: $e',
                  );
                }
              },
              icon: const Icon(
                Icons.delete_outline,
              ),
              label:
                  const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ============================================================
  // FORMAT TANGGAL
  // ============================================================

  String _formatTanggal(
    DateTime? date,
  ) {
    if (date == null) {
      return '-';
    }

    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${bulan[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Berita Desa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () =>
            _showForm(),
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Tambah Berita',
        ),
      ),

      body: StreamBuilder<
          List<Berita>>(
        stream:
            _beritaService.getBerita(),
        builder: (
          context,
          snapshot,
        ) {
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
                'Terjadi kesalahan:\n${snapshot.error}',
                textAlign:
                    TextAlign.center,
              ),
            );
          }

          final berita =
              snapshot.data ?? [];

          return SingleChildScrollView(
            padding:
                const EdgeInsets.all(25),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      'Kelola Berita Desa',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            AppTheme.primary,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      'Kelola informasi dan berita terbaru Desa Tembarak.',
                      style: TextStyle(
                        color:
                            Colors.black54,
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    if (berita.isEmpty)
                      Container(
                        width:
                            double.infinity,
                        padding:
                            const EdgeInsets
                                .all(40),
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),
                        ),
                        child:
                            const Column(
                          children: [
                            Icon(
                              Icons
                                  .newspaper_outlined,
                              size: 60,
                              color:
                                  Colors.grey,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Belum ada berita.',
                              style:
                                  TextStyle(
                                fontSize:
                                    17,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Klik tombol Tambah Berita untuk membuat berita baru.',
                              textAlign:
                                  TextAlign
                                      .center,
                              style:
                                  TextStyle(
                                color: Colors
                                    .black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ...berita.map(
                      (item) {
                        return _newsItem(
                          item,
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

  // ============================================================
  // ITEM BERITA
  // ============================================================

  Widget _newsItem(
    Berita berita,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 15,
      ),
      elevation: 2,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // FOTO
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
              child: berita.fotoUrl
                      .isNotEmpty
                  ? Image.network(
                      berita.fotoUrl,
                      width: 150,
                      height: 110,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 150,
                      height: 110,
                      color:
                          AppTheme.lightGreen,
                      child:
                          const Icon(
                        Icons.article,
                        size: 45,
                        color:
                            AppTheme.primary,
                      ),
                    ),
            ),

            const SizedBox(
              width: 18,
            ),

            // INFORMASI
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    berita.judul,
                    style:
                        const TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppTheme.primary,
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  Text(
                    '${berita.kategori} • ${_formatTanggal(berita.createdAt)}',
                    style:
                        const TextStyle(
                      color:
                          Colors.black54,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    berita.ringkasan,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Wrap(
                    spacing: 10,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () =>
                            _showForm(
                          berita: berita,
                        ),
                        icon:
                            const Icon(
                          Icons.edit,
                          size: 17,
                        ),
                        label:
                            const Text(
                          'Edit',
                        ),
                      ),

                      OutlinedButton.icon(
                        onPressed: () =>
                            _hapusBerita(
                          berita,
                        ),
                        icon:
                            const Icon(
                          Icons
                              .delete_outline,
                          size: 17,
                        ),
                        label:
                            const Text(
                          'Hapus',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}