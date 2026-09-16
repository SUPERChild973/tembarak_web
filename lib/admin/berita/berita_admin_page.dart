import 'package:flutter/material.dart';

import '../../config/app_theme.dart';

class BeritaAdminPage extends StatefulWidget {
  const BeritaAdminPage({super.key});

  @override
  State<BeritaAdminPage> createState() =>
      _BeritaAdminPageState();
}

class _BeritaAdminPageState
    extends State<BeritaAdminPage> {
  final List<Map<String, dynamic>> _berita = [
    {
      'judul': 'Gotong Royong Desa Tembarak',
      'kategori': 'Kegiatan Desa',
      'tanggal': '10 September 2026',
      'isi':
          'Masyarakat Desa Tembarak melaksanakan kegiatan gotong royong bersama.',
    },
    {
      'judul': 'Kegiatan Posyandu Desa',
      'kategori': 'Kesehatan',
      'tanggal': '7 September 2026',
      'isi':
          'Kegiatan Posyandu dilaksanakan untuk memberikan pelayanan kesehatan kepada masyarakat.',
    },
  ];

  void _tambahBerita() {
    final judulController = TextEditingController();
    final kategoriController = TextEditingController();
    final isiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Berita'),

          content: SizedBox(
            width: 550,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: judulController,
                    decoration: const InputDecoration(
                      labelText: 'Judul Berita',
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
                    controller: isiController,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      labelText: 'Isi Berita',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () {
                if (judulController.text.trim().isEmpty) {
                  return;
                }

                setState(() {
                  _berita.add({
                    'judul':
                        judulController.text.trim(),
                    'kategori':
                        kategoriController.text.trim(),
                    'tanggal': '15 September 2026',
                    'isi':
                        isiController.text.trim(),
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

  void _hapusBerita(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Berita'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus berita ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _berita.removeAt(index);
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
          'Berita Desa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahBerita,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Berita'),
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
                  'Kelola Berita Desa',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Kelola informasi dan berita terbaru Desa Tembarak.',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 25),

                ..._berita.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final berita = entry.value;

                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: 15),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.lightGreen,
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),
                              child: const Icon(
                                Icons.article,
                                size: 45,
                                color:
                                    AppTheme.primary,
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    berita['judul'],
                                    style:
                                        const TextStyle(
                                      fontSize: 19,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          AppTheme.primary,
                                    ),
                                  ),

                                  const SizedBox(height: 7),

                                  Text(
                                    '${berita['kategori']} • ${berita['tanggal']}',
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    berita['isi'],
                                    maxLines: 3,
                                    overflow: TextOverflow
                                        .ellipsis,
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 17,
                                        ),
                                        label:
                                            const Text(
                                          'Edit',
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      OutlinedButton.icon(
                                        onPressed: () =>
                                            _hapusBerita(
                                          index,
                                        ),
                                        icon: const Icon(
                                          Icons.delete_outline,
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