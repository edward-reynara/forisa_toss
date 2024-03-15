import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/color_palete.dart';

Shimmer fullWidthColShimmer(bool enabled) => Shimmer.fromColors(
      baseColor: ColorPalete.shimmerBaseColor,
      highlightColor: ColorPalete.shimmerHighlightColor,
      enabled: enabled,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '##',
                    style: TextStyle(
                      backgroundColor: ColorPalete.shimmerInitColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '###########',
                    style: TextStyle(
                      backgroundColor: ColorPalete.shimmerInitColor,
                    ),
                  ),
                ],
              ),
              Text(
                '#############',
                style: TextStyle(
                  backgroundColor: ColorPalete.shimmerInitColor,
                ),
              ),
            ],
          ),
          Divider(
            height: 20.0,
            thickness: 2.0,
            color: Colors.grey.withOpacity(0.3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '##',
                    style: TextStyle(
                      backgroundColor: ColorPalete.shimmerInitColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '######',
                    style: TextStyle(
                      backgroundColor: ColorPalete.shimmerInitColor,
                    ),
                  ),
                ],
              ),
              Text(
                '########',
                style: TextStyle(
                  backgroundColor: ColorPalete.shimmerInitColor,
                ),
              ),
            ],
          ),
          Divider(
            height: 20.0,
            thickness: 2.0,
            color: Colors.grey.withOpacity(0.3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '##',
                    style: TextStyle(
                      backgroundColor: ColorPalete.shimmerInitColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '#############',
                    style: TextStyle(
                      backgroundColor: ColorPalete.shimmerInitColor,
                    ),
                  ),
                ],
              ),
              Text(
                '###########',
                style: TextStyle(
                  backgroundColor: ColorPalete.shimmerInitColor,
                ),
              ),
            ],
          ),
          Divider(
            height: 20.0,
            thickness: 2.0,
            color: Colors.grey.withOpacity(0.3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '##',
                    style: TextStyle(
                      backgroundColor: ColorPalete.shimmerInitColor,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '##########',
                    style: TextStyle(
                      backgroundColor: ColorPalete.shimmerInitColor,
                    ),
                  ),
                ],
              ),
              Text(
                '###########',
                style: TextStyle(
                  backgroundColor: ColorPalete.shimmerInitColor,
                ),
              ),
            ],
          ),
          Divider(
            height: 20.0,
            thickness: 2.0,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );

Shimmer rectHorizonListShimmer(bool enabled, BuildContext buildContext) =>
    Shimmer.fromColors(
      baseColor: ColorPalete.shimmerBaseColor,
      highlightColor: ColorPalete.shimmerHighlightColor,
      enabled: enabled,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        width: MediaQuery.of(buildContext).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.green[500],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.orange[500],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Text(
                '################',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  backgroundColor: ColorPalete.shimmerInitColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: const Text(
                'Nama : ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: const Text(
                'No : ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: const Text(
                'Ket : ',
                style: TextStyle(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );

Shimmer menuUtamaShimmer(bool enabled) => Shimmer.fromColors(
      baseColor: ColorPalete.shimmerBaseColor,
      highlightColor: ColorPalete.shimmerHighlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                shape: BoxShape.circle,
                color: ColorPalete.shimmerInitColor,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorPalete.shimmerInitColor,
                ),
              ),
            ),
          ),
          Container(
            width: 20.0,
            height: 5.0,
            color: ColorPalete.shimmerInitColor,
          ),
        ],
      ),
    );

Shimmer beritaShimmer(bool enabled, BuildContext buildContext) =>
    Shimmer.fromColors(
      baseColor: ColorPalete.shimmerInitColor,
      highlightColor: ColorPalete.shimmerHighlightColor,
      child: Container(
        margin: const EdgeInsets.only(right: 10.0),
        width: MediaQuery.of(buildContext).size.width * 0.6,
        decoration: BoxDecoration(
          color: ColorPalete.shimmerInitColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );

    Shimmer statusSummaryShimmer(bool enabled, BuildContext buildContext) => Shimmer.fromColors(
      baseColor: ColorPalete.shimmerInitColor,
      highlightColor: ColorPalete.shimmerHighlightColor,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        height: 150.0,
        decoration: BoxDecoration(
          color: ColorPalete.shimmerInitColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
