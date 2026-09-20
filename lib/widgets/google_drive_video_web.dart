// TODO Implement this library.
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class GoogleDriveVideo extends StatefulWidget {
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
  State<GoogleDriveVideo> createState() =>
      _GoogleDriveVideoState();
}

class _GoogleDriveVideoState
    extends State<GoogleDriveVideo> {
  late final String _viewType;
  late final String _embedUrl;

  @override
  void initState() {
    super.initState();

    _viewType =
        'google-drive-video-${DateTime.now().microsecondsSinceEpoch}';

    _embedUrl = _convertToPreviewUrl(widget.url);

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement();

        iframe.src = _embedUrl;

        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';

        iframe.setAttribute(
          'allow',
          'autoplay; fullscreen',
        );

        iframe.setAttribute(
          'allowfullscreen',
          'true',
        );

        return iframe;
      },
    );
  }

  String _convertToPreviewUrl(String url) {
    if (url.trim().isEmpty) {
      return '';
    }

    // Jika sudah berupa link preview
    if (url.contains('/preview')) {
      return url;
    }

    final uri = Uri.tryParse(url);

    if (uri == null) {
      return url;
    }

    final segments = uri.pathSegments;

    // Format:
    // https://drive.google.com/file/d/FILE_ID/view

    final fileIndex = segments.indexOf('d');

    if (fileIndex != -1 &&
        fileIndex + 1 < segments.length) {
      final fileId = segments[fileIndex + 1];

      return 'https://drive.google.com/file/d/$fileId/preview';
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.trim().isEmpty) {
      return Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: widget.borderRadius,
        ),
        child: const Center(
          child: Icon(
            Icons.video_library_outlined,
            size: 70,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: HtmlElementView(
          viewType: _viewType,
        ),
      ),
    );
  }
}