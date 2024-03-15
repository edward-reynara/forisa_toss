import 'package:flutter/material.dart';

const constBottomNavbarPadding = kBottomNavigationBarHeight + 16.0;
const constContainerRadius = 16.0;

class APIRoute {
  static const userWorklocation = '/user/get_worklocation';
  static const userSaveVendorKost = '/user/board_vendor_save';
  static const userCovArea = '/user/coverage_area';
  static const userBoardVendor = '/user/board_vendor_list';

  //Place Autocomplete
  static const mapsPlaceUrl = "/master/google/google_placeautocomp";
  static const mapsPlaceDetailsUrl = "/master/google/google_placedetail";
}

class IMG {
  static const folder = 'assets/images';
  static const logo = '$folder/logo.png';
  static const iconSuccess = '$folder/icon-success.png';
  static const selfieHolder = '$folder/selfie-holder.png';
}