import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/produk.dart';
import '../../services/produk_service.dart';
import '../../services/storage_service.dart';

class ProdukAdminPage extends StatefulWidget {
  const ProdukAdminPage({super.key});

  @override
  State<ProdukAdminPage> createState() =>
      _ProdukAdminPageState();
}

class _ProdukAdminPageState
    extends State<ProdukAdminPage> {
  final ProdukService _produkService =
      ProdukService();

  final StorageService _storageService =
      StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Kelola Produk Desa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
        onPressed: () {
          _showProdukForm();
        },
      ),

      body: StreamBuilder<List<Produk>>(
        stream: _produkService.getProduk(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.redAccent,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Gagal memuat produk',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final produk =
              snapshot.data ?? [];

          if (produk.isEmpty) {
            return Center(
              child: Container(
                constraints:
                    const BoxConstraints(
                  maxWidth: 500,
                ),
                margin:
                    const EdgeInsets.all(30),
                padding:
                    const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(22),
                ),
                child: const Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.storefront_outlined,
                      size: 70,
                      color: AppTheme.primary,
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Belum Ada Produk',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            AppTheme.primary,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Silakan tambahkan produk unggulan desa menggunakan tombol Tambah Produk.',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.fromLTRB(
              30,
              30,
              30,
              100,
            ),
            itemCount: produk.length,
            itemBuilder:
                (context, index) {
              final item =
                  produk[index];

              return _ProdukItem(
                produk: item,
                onEdit: () {
                  _showProdukForm(
                    produk: item,
                  );
                },
                onDelete: () {
                  _hapusProduk(item);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showProdukForm({
    Produk? produk,
  }) async {
    final formKey =
        GlobalKey<FormState>();

    final namaController =
        TextEditingController(
      text: produk?.nama ?? '',
    );

    final pemilikController =
        TextEditingController(
      text: produk?.pemilik ?? '',
    );

    final alamatController =
        TextEditingController(
      text: produk?.alamat ?? '',
    );

    final teleponController =
        TextEditingController(
      text: produk?.telepon ?? '',
    );

    final deskripsiController =
        TextEditingController(
      text: produk?.deskripsi ?? '',
    );

    final urutanController =
        TextEditingController(
      text: produk?.urutan.toString() ??
          '1',
    );

    Uint8List? selectedBytes;
    String? selectedFileName;

    String fotoUrl =
        produk?.fotoUrl ?? '';

    bool uploading = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            Future<void> pilihFoto() async {
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
                    result.files.single;

                if (file.bytes == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Foto tidak dapat dibaca.',
                      ),
                    ),
                  );
                  return;
                }

                setDialogState(() {
                  selectedBytes =
                      file.bytes;
                  selectedFileName =
                      file.name;
                });
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Gagal memilih foto: $e',
                    ),
                  ),
                );
              }
            }

            Future<void> simpan() async {
              if (!formKey.currentState!
                  .validate()) {
                return;
              }

              setDialogState(() {
                uploading = true;
              });

              try {
                String finalFotoUrl =
                    fotoUrl;

                if (selectedBytes != null) {
                  finalFotoUrl =
                      await _storageService
                          .uploadProdukFoto(
                    bytes: selectedBytes!,
                    fileName:
                        selectedFileName ??
                            'produk.jpg',
                  );

                  if (produk != null &&
                      produk.fotoUrl
                          .trim()
                          .isNotEmpty &&
                      produk.fotoUrl !=
                          finalFotoUrl) {
                    await _storageService
                        .hapusFoto(
                      produk.fotoUrl,
                    );
                  }
                }

                final nama =
                    namaController.text
                        .trim();

                final pemilik =
                    pemilikController.text
                        .trim();

                final alamat =
                    alamatController.text
                        .trim();

                final telepon =
                    teleponController.text
                        .trim();

                final deskripsi =
                    deskripsiController
                        .text
                        .trim();

                final urutan =
                    int.tryParse(
                          urutanController
                              .text
                              .trim(),
                        ) ??
                        1;

                if (produk == null) {
                  await _produkService
                      .tambahProduk(
                    nama: nama,
                    pemilik: pemilik,
                    alamat: alamat,
                    telepon: telepon,
                    fotoUrl:
                        finalFotoUrl,
                    deskripsi:
                        deskripsi,
                    urutan: urutan,
                  );
                } else {
                  await _produkService
                      .updateProduk(
                    id: produk.id,
                    nama: nama,
                    pemilik: pemilik,
                    alamat: alamat,
                    telepon: telepon,
                    fotoUrl:
                        finalFotoUrl,
                    deskripsi:
                        deskripsi,
                    urutan: urutan,
                  );
                }

                if (!dialogContext
                    .mounted) {
                  return;
                }

                Navigator.of(
                  dialogContext,
                ).pop();

                if (!mounted) {
                  return;
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      produk == null
                          ? 'Produk berhasil ditambahkan.'
                          : 'Produk berhasil diperbarui.',
                    ),
                  ),
                );
              } catch (e) {
                setDialogState(() {
                  uploading = false;
                });

                if (!dialogContext
                    .mounted) {
                  return;
                }

                ScaffoldMessenger.of(
                  dialogContext,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Gagal menyimpan produk: $e',
                    ),
                  ),
                );
              }
            }

            return AlertDialog(
              title: Text(
                produk == null
                    ? 'Tambah Produk'
                    : 'Edit Produk',
              ),

              content: SizedBox(
                width: 650,
                child:
                    SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller:
                              namaController,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Nama Produk',
                            hintText:
                                'Contoh: Keripik Singkong',
                            prefixIcon:
                                Icon(
                              Icons
                                  .storefront_outlined,
                            ),
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
                              return 'Nama produk wajib diisi.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        TextFormField(
                          controller:
                              pemilikController,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Nama Pemilik',
                            hintText:
                                'Nama pemilik usaha',
                            prefixIcon:
                                Icon(
                              Icons
                                  .person_outline,
                            ),
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
                              return 'Nama pemilik wajib diisi.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        TextFormField(
                          controller:
                              alamatController,
                          maxLines: 2,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Alamat',
                            hintText:
                                'Alamat pemilik/usaha',
                            prefixIcon:
                                Icon(
                              Icons
                                  .location_on_outlined,
                            ),
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
                              return 'Alamat wajib diisi.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        TextFormField(
                          controller:
                              teleponController,
                          keyboardType:
                              TextInputType.phone,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Nomor Telepon',
                            hintText:
                                'Contoh: 08xxxxxxxxxx',
                            prefixIcon:
                                Icon(
                              Icons
                                  .phone_outlined,
                            ),
                            border:
                                OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        TextFormField(
                          controller:
                              deskripsiController,
                          maxLines: 5,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Deskripsi Produk',
                            hintText:
                                'Jelaskan produk unggulan desa...',
                            prefixIcon:
                                Icon(
                              Icons
                                  .description_outlined,
                            ),
                            border:
                                OutlineInputBorder(),
                            alignLabelWithHint:
                                true,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Align(
                          alignment:
                              Alignment
                                  .centerLeft,
                          child: Text(
                            'Foto Produk',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color: Colors
                                  .grey
                                  .shade800,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          width:
                              double.infinity,
                          height: 210,
                          decoration:
                              BoxDecoration(
                            color: AppTheme
                                .lightGreen,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              16,
                            ),
                            border:
                                Border.all(
                              color:
                                  Colors.black12,
                            ),
                          ),
                          child:
                              selectedBytes !=
                                      null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(
                                        16,
                                      ),
                                      child:
                                          Image.memory(
                                        selectedBytes!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : fotoUrl
                                          .trim()
                                          .isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(
                                            16,
                                          ),
                                          child:
                                              Image.network(
                                            fotoUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return const Center(
                                                child:
                                                    Icon(
                                                  Icons
                                                      .broken_image_outlined,
                                                  size:
                                                      60,
                                                  color:
                                                      AppTheme.primary,
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : const Center(
                                          child:
                                              Icon(
                                            Icons
                                                .add_photo_alternate_outlined,
                                            size:
                                                65,
                                            color:
                                                AppTheme.primary,
                                          ),
                                        ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        SizedBox(
                          width:
                              double.infinity,
                          child:
                              OutlinedButton
                                  .icon(
                            onPressed:
                                uploading
                                    ? null
                                    : pilihFoto,
                            icon:
                                const Icon(
                              Icons
                                  .add_photo_alternate_outlined,
                            ),
                            label: Text(
                              selectedBytes !=
                                          null ||
                                      fotoUrl
                                          .trim()
                                          .isNotEmpty
                                  ? 'Ganti Foto'
                                  : 'Pilih Foto dari Perangkat',
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        TextFormField(
                          controller:
                              urutanController,
                          keyboardType:
                              TextInputType
                                  .number,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Urutan Tampilan',
                            hintText:
                                'Contoh: 1',
                            prefixIcon:
                                Icon(
                              Icons.sort,
                            ),
                            border:
                                OutlineInputBorder(),
                          ),
                          validator:
                              (value) {
                            final number =
                                int.tryParse(
                              value?.trim() ??
                                  '',
                            );

                            if (number ==
                                null) {
                              return 'Urutan harus berupa angka.';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: uploading
                      ? null
                      : () {
                          Navigator.of(
                            dialogContext,
                          ).pop();
                        },
                  child:
                      const Text('Batal'),
                ),

                ElevatedButton.icon(
                  onPressed:
                      uploading
                          ? null
                          : simpan,
                  icon: uploading
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
                    uploading
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

    namaController.dispose();
    pemilikController.dispose();
    alamatController.dispose();
    teleponController.dispose();
    deskripsiController.dispose();
    urutanController.dispose();
  }

  Future<void> _hapusProduk(
    Produk produk,
  ) async {
    final konfirmasi =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Hapus Produk'),
          content: Text(
            'Yakin ingin menghapus produk "${produk.nama}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false);
              },
              child:
                  const Text('Batal'),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(true);
              },
              child:
                  const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) {
      return;
    }

    try {
      await _produkService
          .hapusProduk(produk.id);

      if (produk.fotoUrl
          .trim()
          .isNotEmpty) {
        await _storageService
            .hapusFoto(
          produk.fotoUrl,
        );
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Produk berhasil dihapus.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menghapus produk: $e',
          ),
        ),
      );
    }
  }
}

class _ProdukItem
    extends StatelessWidget {
  final Produk produk;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProdukItem({
    required this.produk,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 15,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _fotoProduk(),

          const SizedBox(
            width: 20,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  produk.nama,
                  style:
                      const TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppTheme.primary,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                if (produk.pemilik
                    .isNotEmpty)
                  _info(
                    Icons
                        .person_outline,
                    produk.pemilik,
                  ),

                if (produk.alamat
                    .isNotEmpty) ...[
                  const SizedBox(
                    height: 6,
                  ),
                  _info(
                    Icons
                        .location_on_outlined,
                    produk.alamat,
                  ),
                ],

                if (produk.telepon
                    .isNotEmpty) ...[
                  const SizedBox(
                    height: 6,
                  ),
                  _info(
                    Icons
                        .phone_outlined,
                    produk.telepon,
                  ),
                ],

                if (produk.deskripsi
                    .isNotEmpty) ...[
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    produk.deskripsi,
                    maxLines: 3,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        const TextStyle(
                      color:
                          Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          Column(
            children: [
              IconButton(
                tooltip: 'Edit',
                onPressed: onEdit,
                icon: const Icon(
                  Icons
                      .edit_outlined,
                  color:
                      AppTheme.primary,
                ),
              ),

              IconButton(
                tooltip: 'Hapus',
                onPressed: onDelete,
                icon: const Icon(
                  Icons
                      .delete_outline,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fotoProduk() {
    return Container(
      width: 180,
      height: 150,
      decoration:
          BoxDecoration(
        color:
            AppTheme.lightGreen,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: produk.fotoUrl
              .trim()
              .isNotEmpty
          ? ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
              child: Image.network(
                produk.fotoUrl,
                fit: BoxFit.cover,
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
                      size: 55,
                      color:
                          AppTheme.primary,
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: Icon(
                Icons
                    .storefront_outlined,
                size: 55,
                color:
                    AppTheme.primary,
              ),
            ),
    );
  }

  Widget _info(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color:
              AppTheme.primary,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            text,
            style:
                const TextStyle(
              color:
                  Colors.black54,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}