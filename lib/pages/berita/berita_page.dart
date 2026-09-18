import 'package:flutter/material.dart';

import '../../config/app_theme.dart';
import '../../models/berita.dart';
import '../../services/berita_service.dart';
import 'berita_detail_page.dart';

class BeritaPage
    extends StatelessWidget {
  const BeritaPage({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _headerSection(),
          _newsSection(context),
        ],
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 60,
      ),
      decoration:
          const BoxDecoration(
        gradient: LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(0xFF0D3B13),
            AppTheme.primary,
            AppTheme.primaryLight,
          ],
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.newspaper,
            color: Colors.white,
            size: 60,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Berita & Informasi',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            'Informasi terbaru seputar Desa Tembarak',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _newsSection(
    BuildContext context,
  ) {
    final service =
        BeritaService();

    return Container(
      width: double.infinity,
      color:
          AppTheme.background,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 1150,
          ),
          child:
              StreamBuilder<List<Berita>>(
            stream:
                service.getBerita(),
            builder: (
              context,
              snapshot,
            ) {
              if (snapshot
                      .connectionState ==
                  ConnectionState.waiting) {
                return const Padding(
                  padding:
                      EdgeInsets.all(60),
                  child: Center(
                    child:
                        CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Gagal memuat berita:\n${snapshot.error}',
                    textAlign:
                        TextAlign.center,
                  ),
                );
              }

              final news =
                  snapshot.data ?? [];

              if (news.isEmpty) {
                return const Padding(
                  padding:
                      EdgeInsets.all(60),
                  child: Center(
                    child: Text(
                      'Belum ada berita.',
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  const Text(
                    'Berita Terbaru',
                    style: TextStyle(
                      color:
                          AppTheme.primary,
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    'Berbagai informasi dan kegiatan terbaru Desa Tembarak',
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color:
                          Colors.black54,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  Wrap(
                    spacing: 22,
                    runSpacing: 22,
                    alignment:
                        WrapAlignment
                            .center,
                    children:
                        news.map(
                      (item) {
                        return _newsCard(
                          context,
                          item,
                        );
                      },
                    ).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _newsCard(
    BuildContext context,
    Berita berita,
  ) {
    return Container(
      width: 350,
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.06),
            blurRadius: 18,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // FOTO
          ClipRRect(
            borderRadius:
                const BorderRadius
                    .only(
              topLeft:
                  Radius.circular(22),
              topRight:
                  Radius.circular(22),
            ),
            child: berita.fotoUrl
                    .isNotEmpty
                ? Image.network(
                    berita.fotoUrl,
                    width:
                        double.infinity,
                    height: 200,
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

          Padding(
            padding:
                const EdgeInsets.all(
              20,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  berita.kategori,
                  style:
                      const TextStyle(
                    color:
                        AppTheme.primary,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  berita.judul,
                  maxLines: 2,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      const TextStyle(
                    color:
                        AppTheme.primary,
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                    height: 1.4,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  berita.ringkasan,
                  maxLines: 3,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style:
                      const TextStyle(
                    color:
                        Colors.black54,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BeritaDetailPage(
                            berita:
                                berita,
                          ),
                        ),
                      );
                    },
                    icon:
                        const Icon(
                      Icons
                          .arrow_forward,
                      size: 17,
                    ),
                    label:
                        const Text(
                      'Baca Selengkapnya',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color:
          AppTheme.lightGreen,
      child: const Icon(
        Icons.article,
        size: 60,
        color:
            AppTheme.primary,
      ),
    );
  }
}