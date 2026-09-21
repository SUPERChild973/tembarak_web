import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../config/app_theme.dart';

class Navbar extends StatelessWidget {
  final String currentPage;
  final Function(String) onNavigate;

  const Navbar({
    super.key,
    required this.currentPage,
    required this.onNavigate,
  });

  static const List<Map<String, String>>
      menus = [
    {
      'title': 'Beranda',
      'page': 'home',
    },
    {
      'title': 'Profil',
      'page': 'profil',
    },
    {
      'title': 'Struktur',
      'page': 'struktur',
    },
    {
      'title': 'Peta',
      'page': 'peta',
    },
    {
      'title': 'Produk',
      'page': 'produk',
    },
    {
      'title': 'Berita',
      'page': 'berita',
    },
    {
      'title': 'Galeri',
      'page': 'galeri',
    },
    {
      'title': 'Kontak',
      'page': 'kontak',
    },
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    final width =
        MediaQuery.of(context).size.width;

    final isMobile =
        width < 900;

    return Container(
      height: 76,

      padding:
          EdgeInsets.symmetric(
        horizontal:
            isMobile ? 20 : 60,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.06,
            ),
            blurRadius: 12,
            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [

          // ====================================================
          // LOGO
          // ====================================================

          _logo(),

          const Spacer(),

          if (isMobile)
            _mobileMenu(context)
          else
            _desktopMenu(context),
        ],
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _logo() {
    return StreamBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore
          .instance
          .collection('pengaturan')
          .doc('website')
          .snapshots(),

      builder:
          (context, snapshot) {

        final data =
            snapshot.data?.data() ??
                {};

        final String logoUrl =
            data['logoUrl']
                    ?.toString()
                    .trim() ??
                '';

        final String namaDesa =
            data['namaDesa']
                    ?.toString()
                    .trim() ??
                'DESA TEMBARAK';

        return GestureDetector(
          onTap: () {
            onNavigate('home');
          },

          child: Row(
            children: [

              Container(
                width: 45,
                height: 45,

                padding:
                    const EdgeInsets.all(5),

                decoration:
                    const BoxDecoration(
                  color:
                      AppTheme.lightGreen,
                  shape:
                      BoxShape.circle,
                ),

                child: logoUrl.isEmpty
                    ? const Icon(
                        Icons.account_balance,
                        color:
                            AppTheme.primary,
                      )
                    : ClipOval(
                        child:
                            Image.network(
                          logoUrl,
                          fit:
                              BoxFit.contain,

                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const Icon(
                              Icons.account_balance,
                              color:
                                  AppTheme.primary,
                            );
                          },
                        ),
                      ),
              ),

              const SizedBox(
                width: 12,
              ),

              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    namaDesa
                        .toUpperCase(),

                    style:
                        const TextStyle(
                      color:
                          AppTheme.primary,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const Text(
                    'Website Resmi Desa',

                    style:
                        TextStyle(
                      color:
                          Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _desktopMenu(
    BuildContext context,
  ) {
    return Row(
      children: [

        ...menus.map(
          (menu) {
            final page =
                menu['page']!;

            final title =
                menu['title']!;

            final selected =
                currentPage == page;

            return Padding(
              padding:
                  const EdgeInsets.only(
                left: 5,
              ),

              child:
                  TextButton(
                onPressed: () {
                  onNavigate(page);
                },

                style:
                    TextButton.styleFrom(
                  foregroundColor:
                      selected
                          ? AppTheme.primary
                          : Colors.black87,
                ),

                child:
                    Text(
                  title,

                  style:
                      TextStyle(
                    fontWeight:
                        selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(
          width: 15,
        ),

        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/admin');
          },

          icon:
              const Icon(
            Icons
                .admin_panel_settings_outlined,
            size: 19,
          ),

          label:
              const Text(
            'Login Admin',
          ),

          style:
              ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                25,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _mobileMenu(
    BuildContext context,
  ) {
    return PopupMenuButton<String>(
      icon:
          const Icon(
        Icons.menu,
        color:
            AppTheme.primary,
      ),

      onSelected: (value) {

        if (value == 'admin') {
          Navigator.of(context)
              .pushNamed('/admin');
        } else {
          onNavigate(value);
        }
      },

      itemBuilder:
          (context) {

        return [

          ...menus.map(
            (menu) {
              return PopupMenuItem<String>(
                value:
                    menu['page'],

                child:
                    Text(
                  menu['title']!,
                ),
              );
            },
          ),

          const PopupMenuDivider(),

          const PopupMenuItem<String>(
            value: 'admin',

            child:
                Row(
              children: [

                Icon(
                  Icons
                      .admin_panel_settings_outlined,
                  color:
                      AppTheme.primary,
                ),

                SizedBox(
                  width: 10,
                ),

                Text(
                  'Login Admin',

                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
} 