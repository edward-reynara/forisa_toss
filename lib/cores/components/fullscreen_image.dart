import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../configs/states.dart';
import '../utils/locator.dart';

class FullScreenImage extends StatefulWidget {
  final String baseUrl;
  final List<String> imgUrl;
  final bool isOutSide;

  FullScreenImage(this.baseUrl, this.imgUrl, this.isOutSide);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  int counterIndex = 1;

  void onPageChanged(int index) {
    setState(() {
      counterIndex = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(
                    widget.isOutSide
                        ? widget.imgUrl[index]
                        : widget.baseUrl + widget.imgUrl[index],
                    headers: locator<States>().headers,
                  ),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.contained * 4,
                );
              },
              itemCount: widget.imgUrl.length,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.horizontal,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Foto ke $counterIndex dari ${widget.imgUrl.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
