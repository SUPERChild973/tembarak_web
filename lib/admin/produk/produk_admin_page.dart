import 'package:flutter/material.dart';

import '../../config/app_theme.dart';

class ProdukAdminPage extends StatefulWidget {
  const ProdukAdminPage({super.key});

  @override
  State<ProdukAdminPage> createState() => _ProdukAdminPageState();
}

class _ProdukAdminPageState extends State<ProdukAdminPage> {
  final List<Map<String, dynamic>> _produk = [
    {
      'nama': 'Keripik Singkong',
      'kategori': 'Makanan',
      'harga': 'Rp15.000',
      'deskripsi':
          'Keripik singkong khas Desa Tembarak yang dibuat oleh masyarakat desa.',
    },
    {
      'nama': 'Kerajinan Bambu',
      'kategori': 'Kerajinan',
      'harga': 'Rp50.000',
      'deskripsi':
          'Kerajinan bambu hasil karya masyarakat Desa Tembarak.',
    },
  ];

  void _tambahProduk() {
    final namaController = TextEditingController();
    final kategoriController = TextEditingController();
    final hargaController = TextEditingController();
    final deskripsiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Produk Desa'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Produk',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: kategoriController,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: hargaController,
                    decoration: const InputDecoration(
                      labelText: 'Harga',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: deskripsiController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () {
                if (namaController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  _produk.add({
                    'nama': namaController.text.trim(),
                    'kategori':
                        kategoriController.text.trim(),
                    'harga': hargaController.text.trim(),
                    'deskripsi':
                        deskripsiController.text.trim(),
                  });
                });

                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _hapusProduk(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus produk ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _produk.removeAt(index);
                });

                Navigator.pop(context);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Produk Desa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahProduk,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1100,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kelola Produk Desa',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Tambah dan kelola produk unggulan Desa Tembarak.',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 25),

                LayoutBuilder(
                  builder: (context, constraints) {
                    int columns = 1;

                    if (constraints.maxWidth >= 900) {
                      columns = 3;
                    } else if (constraints.maxWidth >= 600) {
                      columns = 2;
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: _produk.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio:
                            columns == 1 ? 2.2 : 1.25,
                      ),
                      itemBuilder: (context, index) {
                        final produk = _produk[index];

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightGreen,
                                    borderRadius:
                                        BorderRadius.circular(
                                      14,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.storefront,
                                    size: 55,
                                    color:
                                        AppTheme.primary,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                Text(
                                  produk['nama'],
                                  maxLines: 2,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        AppTheme.primary,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  produk['kategori'],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  produk['harga'],
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const Spacer(),

                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          OutlinedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 17,
                                        ),
                                        label:
                                            const Text('Edit'),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    IconButton(
                                      onPressed: () =>
                                          _hapusProduk(
                                        index,
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }
}