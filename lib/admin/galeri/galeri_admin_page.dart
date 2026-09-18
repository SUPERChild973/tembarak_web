import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/galeri.dart';
import '../../services/galeri_service.dart';
import '../../services/storage_service.dart';

class GaleriAdminPage extends StatefulWidget {
  const GaleriAdminPage({
    super.key,
  });

  @override
  State<GaleriAdminPage> createState() =>
      _GaleriAdminPageState();
}

class _GaleriAdminPageState
    extends State<GaleriAdminPage> {
  final GaleriService _galeriService =
      GaleriService();

  final StorageService _storageService =
      StorageService();

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

    return '${date.day} '
        '${bulan[date.month - 1]} '
        '${date.year}';
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
  // FORM TAMBAH / EDIT
  // ============================================================

  void _showForm({
    Galeri? galeri,
  }) {
    final judulController =
        TextEditingController(
      text: galeri?.judul ?? '',
    );

    final deskripsiController =
        TextEditingController(
      text: galeri?.deskripsi ?? '',
    );

    Uint8List? selectedImageBytes;
    String? selectedImageName;

    String fotoUrl =
        galeri?.fotoUrl ?? '';

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
            // ==================================================
            // PILIH GAMBAR
            // ==================================================

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

            // ==================================================
            // SIMPAN
            // ==================================================

            Future<void> simpan() async {
              if (judulController.text
                  .trim()
                  .isEmpty) {
                _showMessage(
                  'Judul kegiatan wajib diisi.',
                );
                return;
              }

              if (deskripsiController
                  .text
                  .trim()
                  .isEmpty) {
                _showMessage(
                  'Deskripsi wajib diisi.',
                );
                return;
              }

              // Saat tambah, gambar wajib dipilih
              if (galeri == null &&
                  selectedImageBytes == null) {
                _showMessage(
                  'Silakan pilih gambar.',
                );
                return;
              }

              try {
                setDialogState(() {
                  isLoading = true;
                });

                // ==========================================
                // UPLOAD GAMBAR
                // ==========================================

                if (selectedImageBytes !=
                    null) {
                  fotoUrl =
                      await _storageService
                          .uploadGaleriFoto(
                    bytes:
                        selectedImageBytes!,
                    fileName:
                        selectedImageName ??
                            'galeri.jpg',
                  );
                }

                // ==========================================
                // TAMBAH
                // ==========================================

                if (galeri == null) {
                  await _galeriService
                      .tambahGaleri(
                    judul:
                        judulController.text
                            .trim(),
                    deskripsi:
                        deskripsiController
                            .text
                            .trim(),
                    fotoUrl: fotoUrl,
                  );
                }

                // ==========================================
                // EDIT
                // ==========================================

                else {
                  await _galeriService
                      .updateGaleri(
                    id: galeri.id,
                    judul:
                        judulController.text
                            .trim(),
                    deskripsi:
                        deskripsiController
                            .text
                            .trim(),
                    fotoUrl: fotoUrl,
                  );
                }

                if (!dialogContext.mounted) {
                  return;
                }

                Navigator.pop(
                  dialogContext,
                );

                _showMessage(
                  galeri == null
                      ? 'Foto galeri berhasil ditambahkan.'
                      : 'Foto galeri berhasil diperbarui.',
                );
              } catch (e) {
                setDialogState(() {
                  isLoading = false;
                });

                _showMessage(
                  'Gagal menyimpan galeri: $e',
                );
              }
            }

            return AlertDialog(
              title: Text(
                galeri == null
                    ? 'Tambah Foto Galeri'
                    : 'Edit Foto Galeri',
                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              content: SizedBox(
                width: 600,
                child:
                    SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      // ========================================
                      // UPLOAD FOTO
                      // ========================================

                      const Text(
                        'Foto Kegiatan',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : pilihGambar,
                        child:
                            Container(
                          width:
                              double.infinity,
                          height: 250,
                          decoration:
                              BoxDecoration(
                            color:
                                AppTheme.lightGreen,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              18,
                            ),
                            border:
                                Border.all(
                              color: AppTheme
                                  .primary
                                  .withOpacity(
                                0.2,
                              ),
                            ),
                          ),
                          child:
                              selectedImageBytes !=
                                      null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(
                                        18,
                                      ),
                                      child:
                                          Image.memory(
                                        selectedImageBytes!,
                                        width:
                                            double.infinity,
                                        height:
                                            250,
                                        fit:
                                            BoxFit.cover,
                                      ),
                                    )
                                  : fotoUrl
                                          .isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                            18,
                                          ),
                                          child:
                                              Image.network(
                                            fotoUrl,
                                            width:
                                                double.infinity,
                                            height:
                                                250,
                                            fit:
                                                BoxFit.cover,
                                          ),
                                        )
                                      : const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .cloud_upload_outlined,
                                              size:
                                                  55,
                                              color:
                                                  AppTheme.primary,
                                            ),
                                            SizedBox(
                                              height:
                                                  12,
                                            ),
                                            Text(
                                              'Klik untuk upload gambar',
                                              style:
                                                  TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  5,
                                            ),
                                            Text(
                                              'JPG, JPEG, atau PNG',
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

                      const SizedBox(
                        height: 20,
                      ),

                      // ========================================
                      // JUDUL
                      // ========================================

                      TextField(
                        controller:
                            judulController,
                        enabled:
                            !isLoading,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Judul Kegiatan',
                          hintText:
                              'Contoh: Gotong Royong Desa',
                          prefixIcon:
                              Icon(
                            Icons
                                .title_outlined,
                          ),
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      // ========================================
                      // DESKRIPSI
                      // ========================================

                      TextField(
                        controller:
                            deskripsiController,
                        enabled:
                            !isLoading,
                        maxLines: 5,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Deskripsi Singkat',
                          hintText:
                              'Masukkan deskripsi singkat kegiatan...',
                          alignLabelWithHint:
                              true,
                          border:
                              OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                              Navigator.pop(
                                dialogContext,
                              );
                            },
                  child:
                      const Text(
                    'Batal',
                  ),
                ),

                ElevatedButton.icon(
                  onPressed:
                      isLoading
                          ? null
                          : simpan,
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2,
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

  void _hapusGaleri(
    Galeri galeri,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text(
            'Hapus Foto Galeri',
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus "${galeri.judul}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child:
                  const Text(
                'Batal',
              ),
            ),

            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(
                  context,
                );

                try {
                  await _galeriService
                      .hapusGaleri(
                    galeri.id,
                  );

                  _showMessage(
                    'Foto galeri berhasil dihapus.',
                  );
                } catch (e) {
                  _showMessage(
                    'Gagal menghapus galeri: $e',
                  );
                }
              },
              icon:
                  const Icon(
                Icons.delete_outline,
              ),
              label:
                  const Text(
                'Hapus',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppTheme.background,

      appBar: AppBar(
        title:
            const Text(
          'Galeri Desa',
          style:
              TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          _showForm();
        },
        icon:
            const Icon(
          Icons
              .add_photo_alternate,
        ),
        label:
            const Text(
          'Tambah Foto',
        ),
      ),

      body:
          StreamBuilder<
              List<Galeri>>(
        stream:
            _galeriService
                .getGaleri(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot
                  .connectionState ==
              ConnectionState
                  .waiting) {
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

          final galeri =
              snapshot.data ?? [];

          return SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              25,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 1100,
                ),
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      'Kelola Galeri Desa',
                      style:
                          TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight
                                .bold,
                        color:
                            AppTheme
                                .primary,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      'Kelola dokumentasi kegiatan Desa Tembarak.',
                      style:
                          TextStyle(
                        color: Colors
                            .black54,
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    if (galeri
                        .isEmpty)
                      _emptyState(),

                    if (galeri
                        .isNotEmpty)
                      GridView.builder(
                        shrinkWrap:
                            true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount:
                            galeri.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              360,
                          crossAxisSpacing:
                              18,
                          mainAxisSpacing:
                              18,
                          childAspectRatio:
                              0.85,
                        ),
                        itemBuilder:
                            (
                          context,
                          index,
                        ) {
                          return _galeriCard(
                            galeri[
                                index],
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
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        50,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons
                .photo_library_outlined,
            size: 65,
            color: Colors.grey,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Belum ada foto galeri',
            style:
                TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Klik tombol Tambah Foto untuk menambahkan dokumentasi kegiatan.',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CARD GALERI
  // ============================================================

  Widget _galeriCard(
    Galeri galeri,
  ) {
    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      clipBehavior:
          Clip.antiAlias,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          // FOTO
          SizedBox(
            height: 200,
            width: double.infinity,
            child:
                galeri.fotoUrl
                        .isNotEmpty
                    ? Image.network(
                        galeri.fotoUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return _placeholder();
                        },
                      )
                    : _placeholder(),
          ),

          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                15,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    galeri.judul,
                    maxLines: 2,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 16,
                      color:
                          AppTheme.primary,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    _formatTanggal(
                      galeri.createdAt,
                    ),
                    style:
                        const TextStyle(
                      color:
                          Colors.black54,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Expanded(
                    child: Text(
                      galeri.deskripsi,
                      maxLines: 3,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Colors.black54,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child:
                            OutlinedButton
                                .icon(
                          onPressed:
                              () {
                            _showForm(
                              galeri:
                                  galeri,
                            );
                          },
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
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      IconButton(
                        tooltip:
                            'Hapus',
                        onPressed:
                            () {
                          _hapusGaleri(
                            galeri,
                          );
                        },
                        icon:
                            const Icon(
                          Icons
                              .delete_outline,
                          color:
                              Colors.red,
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

  // ============================================================
  // PLACEHOLDER
  // ============================================================

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color:
          AppTheme.lightGreen,
      child: const Center(
        child: Icon(
          Icons.photo,
          size: 65,
          color:
              AppTheme.primary,
        ),
      ),
    );
  }
}