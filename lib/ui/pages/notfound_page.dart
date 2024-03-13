import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cores/components/overlay_appbar.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: 'Halaman Tidak Ditemukan'),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Oops...',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'Halaman yang anda cari tidak ditemukan atau sedang dikembangkan',
                textAlign: TextAlign.center,
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  side: const BorderSide(color: Colors.green, width: 4.0),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const FaIcon(FontAwesomeIcons.arrowCircleLeft, size: 16.0,color: Colors.green,),
                label: const Text('Kembali', style: TextStyle(color: Colors.green),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
