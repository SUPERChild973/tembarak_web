import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../config/app_theme.dart';

class StrukturPage extends StatelessWidget {
  const StrukturPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _header(),

          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('perangkat')
                .snapshots(),
            builder: (context, snapshot) {
              // LOADING
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const SizedBox(
                  height: 400,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primary,
                    ),
                  ),
                );
              }

              // ERROR
              if (snapshot.hasError) {
                return _error(
                  snapshot.error.toString(),
                );
              }

              // DATA FIRESTORE
              final documents =
                  snapshot.data?.docs ?? [];

              // JIKA KOSONG
              if (documents.isEmpty) {
                return _empty();
              }

              // URUTKAN BERDASARKAN FIELD "urutan"
              documents.sort((a, b) {
                final urutanA =
                    (a.data()['urutan'] ?? 0) as num;

                final urutanB =
                    (b.data()['urutan'] ?? 0) as num;

                return urutanA.compareTo(urutanB);
              });

              return _content(documents);
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 60,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
            Icons.account_tree,
            color: Colors.white,
            size: 60,
          ),

          SizedBox(height: 20),

          Text(
            'Struktur Pemerintahan Desa',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12),

          Text(
            'Pemerintah Desa Tembarak',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _content(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) {
    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          child: Column(
            children: [
              // DEBUG
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                  bottom: 30,
                ),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius:
                      BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.shade300,
                  ),
                ),
                child: Text(
                  'Firestore berhasil dibaca. '
                  'Jumlah data: ${documents.length}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Text(
                'Perangkat Desa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Susunan perangkat Pemerintah Desa Tembarak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
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
                    itemCount: documents.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final data =
                          documents[index].data();

                      return _card(data);
                    },
                  );
                },
              ),

              const SizedBox(height: 50),

              _information(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _card(
    Map<String, dynamic> data,
  ) {
    final String nama =
        data['nama']?.toString() ?? '';

    final String jabatan =
        data['jabatan']?.toString() ?? '';

    final String fotoUrl =
        data['fotoUrl']?.toString() ?? '';

    final String keterangan =
        data['keterangan']?.toString() ?? '';

    final int urutan =
        data['urutan'] is num
            ? (data['urutan'] as num).toInt()
            : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              AppTheme.primary.withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // FOTO
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              color: AppTheme.lightGreen,
              child: fotoUrl.isNotEmpty
                  ? Image.network(
                      fotoUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color:
                                AppTheme.primary,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color:
                            AppTheme.primary,
                      ),
                    ),
            ),
          ),

          // INFORMASI
          Expanded(
            flex: 4,
            child: Padding(
              padding:
                  const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    jabatan,
                    textAlign:
                        TextAlign.center,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color:
                          AppTheme.primary,
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    nama,
                    textAlign:
                        TextAlign.center,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  if (keterangan.isNotEmpty) ...[
                    const SizedBox(height: 8),

                    Text(
                      keterangan,
                      textAlign:
                          TextAlign.center,
                      maxLines: 3,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color:
                            Colors.black54,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  Text(
                    'Urutan: $urutan',
                    style: const TextStyle(
                      color: Colors.black38,
                      fontSize: 11,
                    ),
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
  // EMPTY
  // ============================================================

  Widget _empty() {
    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: const EdgeInsets.symmetric(
        vertical: 100,
        horizontal: 25,
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey,
            ),

            SizedBox(height: 20),

            Text(
              'Collection perangkat kosong.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              'Belum ada data perangkat yang '
              'diterima dari Firestore.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _error(
    String message,
  ) {
    return Container(
      width: double.infinity,
      color: AppTheme.background,
      padding: const EdgeInsets.all(60),
      child: Center(
        child: Container(
          constraints:
              const BoxConstraints(
            maxWidth: 800,
          ),
          padding:
              const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),

              const SizedBox(height: 20),

              const Text(
                'Firestore ERROR',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              SelectableText(
                message,
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFORMATION
  // ============================================================

  Widget _information() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppTheme.primary,
            size: 28,
          ),

          SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Struktur',
                  style: TextStyle(
                    color:
                        AppTheme.primary,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Data perangkat desa ditampilkan '
                  'langsung dari database Firestore.',
                  style: TextStyle(
                    color:
                        Colors.black54,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}