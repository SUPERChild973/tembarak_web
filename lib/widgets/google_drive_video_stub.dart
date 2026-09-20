import 'package:flutter/material.dart';

class GoogleDriveVideo extends StatelessWidget {
  final String url;
  final double height;
  final BorderRadius borderRadius;

  const GoogleDriveVideo({
    super.key,
    required this.url,
    this.height = 400,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(20),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: Text(
          'Video hanya tersedia pada versi Web.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}