import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forisa_package/widgets/dividers.dart';

Widget defaultLoader({String? caption}) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SpinKitRing(
            color: Colors.green,
            size: 54.0,
            lineWidth: 6.0,
          ),
          dividerTiny(),
          if (caption != null)
          Text(caption),
        ],
      ),
    );
