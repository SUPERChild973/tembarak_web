import 'package:flutter/material.dart';

import '../../config/app_theme.dart';

class GaleriAdminPage extends StatefulWidget {
  const GaleriAdminPage({super.key});

  @override
  State<GaleriAdminPage> createState() =>
      _GaleriAdminPageState();
}

class _GaleriAdminPageState
    extends State<GaleriAdminPage> {
  final List<Map<String, dynamic>> _galeri = [
    {
      'judul': 'Gotong Royong Desa',
      'tanggal': '10 September 2026',
    },
    {
      'judul': 'Kegiatan Posyandu',
      'tanggal': '7 September 2026',
    },
    {
      'judul': 'Musyawarah Desa',
      'tanggal': '5 September 2026',
    },
    {
      'judul': 'Pelatihan UMKM',
      'tanggal': '2 September 2026',
    },
  ];

  void _tambahGaleri() {
    final judulController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Foto Galeri'),

          content: SizedBox(
            width: 500,
            child: TextField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Kegiatan',
                border: OutlineInputBorder(),
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
                  _galeri.add({
                    'judul':
                        judulController.text.trim(),
                    'tanggal': '15 September 2026',
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

  void _hapusGaleri(int index) {
    setState(() {
      _galeri.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Galeri Desa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahGaleri,
        icon: const Icon(Icons.add_photo_alternate),
        label: const Text('Tambah Foto'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kelola Galeri Desa',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Kelola dokumentasi kegiatan Desa Tembarak.',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 25),

                GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount: _galeri.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final item = _galeri[index];

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.lightGreen,
                                borderRadius:
                                    const BorderRadius
                                        .vertical(
                                  top: Radius.circular(18),
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.photo,
                                  size: 65,
                                  color:
                                      AppTheme.primary,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['judul'],
                                  maxLines: 2,
                                  overflow: TextOverflow
                                      .ellipsis,
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  item['tanggal'],
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          OutlinedButton(
                                        onPressed: () {},
                                        child:
                                            const Text(
                                          'Edit',
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    IconButton(
                                      onPressed: () =>
                                          _hapusGaleri(
                                        index,
                                      ),
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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