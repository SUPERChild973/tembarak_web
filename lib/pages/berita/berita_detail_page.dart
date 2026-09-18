import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/berita.dart';

class BeritaDetailPage
    extends StatelessWidget {
  final Berita berita;

  const BeritaDetailPage({
    super.key,
    required this.berita,
  });

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
          'Detail Berita',
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 900,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  // FOTO
                  if (berita.fotoUrl
                      .isNotEmpty)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                      child:
                          Image.network(
                        berita.fotoUrl,
                        width:
                            double.infinity,
                        height: 430,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return _imagePlaceholder();
                        },
                      ),
                    )
                  else
                    _imagePlaceholder(),

                  const SizedBox(
                    height: 25,
                  ),

                  // KATEGORI
                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          AppTheme.lightGreen,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      berita.kategori,
                      style:
                          const TextStyle(
                        color:
                            AppTheme.primary,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // JUDUL
                  Text(
                    berita.judul,
                    style:
                        const TextStyle(
                      color:
                          AppTheme.primary,
                      fontSize: 34,
                      fontWeight:
                          FontWeight.bold,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  // TANGGAL
                  Row(
                    children: [
                      const Icon(
                        Icons
                            .calendar_today_outlined,
                        size: 16,
                        color:
                            Colors.black54,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        _formatTanggal(
                          berita.createdAt,
                        ),
                        style:
                            const TextStyle(
                          color:
                              Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // RINGKASAN
                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets
                            .all(20),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Text(
                      berita.ringkasan,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                        height: 1.7,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  // ISI BERITA
                  Text(
                    berita.isi,
                    style:
                        const TextStyle(
                      fontSize: 16,
                      height: 1.9,
                      color:
                          Colors.black87,
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  // KEMBALI
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    label: const Text(
                      'Kembali ke Berita',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 430,
      decoration:
          BoxDecoration(
        color:
            AppTheme.lightGreen,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child: const Icon(
        Icons.newspaper,
        size: 100,
        color:
            AppTheme.primary,
      ),
    );
  }
}