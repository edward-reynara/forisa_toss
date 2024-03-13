// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:forisa_attendance/components/alerts_widget.dart';
// import 'package:forisa_attendance/components/appbars.dart';
// import 'package:forisa_attendance/components/dividers.dart';
// import 'package:forisa_attendance/components/error_future_component.dart';
// import 'package:forisa_attendance/components/loaders.dart';
// import 'package:forisa_attendance/components/submit_button.dart';
// import 'package:forisa_attendance/components/text_fields.dart';
// import 'package:forisa_attendance/models/model_arguments.dart';
// import 'package:forisa_attendance/models/place_api_model.dart';
// import 'package:forisa_attendance/services/location_service.dart';
// import 'package:forisa_attendance/services/map_service.dart';
// import 'package:forisa_attendance/utils/formatter.dart';
// import 'package:forisa_attendance/utils/tools.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapsPage extends StatefulWidget {
//   final ScreenArguments? _screenArguments;
//
//   MapsPage(this._screenArguments);
//   @override
//   State<MapsPage> createState() => _MapsPageState();
// }
//
// class _MapsPageState extends State<MapsPage> {
//   final _mapService = MapService();
//   final _locationService = LocationService();
//   GoogleMapController? _mapController;
//
//   final _searchbarCtrl = TextEditingController();
//   String? _sessionToken;
//   LatLng _currentLatLong = LatLng(0.0, 0.0);
//   Set<Marker> _markers = <Marker>{};
//   var _pickedAddress = '';
//   late Future _future;
//   late CameraPosition _cameraPosition;
//
//   String _generateNewSession() {
//     return Tools.randomString(18);
//   }
//
//   Future<List<Prediction>> _searchPlaces(String pattern) async {
//     if (pattern.length > 0) {
//       if (_sessionToken == null) this._sessionToken = _generateNewSession();
//       List<Prediction> suggestions =
//           await _mapService.getSuggestionPlaces(pattern, _sessionToken!);
//       return suggestions;
//     }
//
//     return [];
//   }
//
//   _onSuggestionSelected(Prediction suggestion) async {
//     try {
//       var placeDetail = await _mapService.getPlaceDetail(
//           suggestion.placeId!, this._sessionToken);
//       _currentLatLong = LatLng(placeDetail.result!.geometry!.location!.lat!,
//           placeDetail.result!.geometry!.location!.lng!);
//       await _updateMarker(newAddress: suggestion.description);
//       this._sessionToken = _generateNewSession();
//     } catch (e) {
//       Tools.showAlert(context, 'Response', e.toString(), 'error');
//     }
//   }
//
//   _updateMarker({String? newAddress}) async {
//     _markers.clear();
//     _markers.add(_setMarker('default-id'));
//     _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       target: _currentLatLong,
//       zoom: 17.0,
//     )));
//     await _updateAddress(address: newAddress);
//   }
//
//   Marker _setMarker(String markerId) {
//     return Marker(
//       markerId: MarkerId(markerId),
//       position: _currentLatLong,
//       icon: BitmapDescriptor.defaultMarker,
//       draggable: true,
//       onDragEnd: onMarkerDragged,
//       infoWindow:
//           InfoWindow(title: 'Tahan dan geser tanda untuk lebih presisi'),
//     );
//   }
//
//   onMapCreated(GoogleMapController _controller) {
//     _mapController = _controller;
//   }
//
//   onMarkerDragged(LatLng coor) async {
//     _currentLatLong = coor;
//     await _updateAddress();
//   }
//
//   _updateAddress({String? address}) async {
//     try {
//       if (address != null) {
//         _pickedAddress = address;
//       } else {
//         List<Placemark> placemarks = await placemarkFromCoordinates(
//             _currentLatLong.latitude, _currentLatLong.longitude,
//             localeIdentifier: 'id_ID');
//         if (placemarks.length > 0) {
//           Placemark placeMark = placemarks.first;
//           _pickedAddress = Formatter.formatAddress(
//             street: placeMark.street,
//             name: placeMark.name,
//             subLocality: placeMark.subLocality,
//             locality: placeMark.locality,
//             administrativeArea: placeMark.administrativeArea,
//             postalCode: placeMark.postalCode,
//             country: placeMark.country,
//           );
//         } else {
//           _pickedAddress = 'Alamat tidak diketahui.';
//         }
//       }
//       setState(() {});
//     } catch (e) {}
//   }
//
//   _loadMap() async {
//     try {
//       if (widget._screenArguments?.dynamicData == null) {
//         var location = await _locationService.getCurrentLocation();
//         if (location != null) {
//           _currentLatLong = LatLng(location.latitude!, location.longitude!);
//         }
//       } else {
//         if (widget._screenArguments?.dynamicData != null) {
//           Map<String, double?> coor = widget._screenArguments?.dynamicData;
//           _currentLatLong = LatLng(coor['lat']!, coor['long']!);
//         }
//       }
//       await _updateMarker();
//       await _updateAddress();
//       _cameraPosition = CameraPosition(target: _currentLatLong, zoom: 17.0);
//     } catch (e) {
//       Tools.showAlert(context, 'Error', e.toString(), 'error');
//     }
//   }
//
//   _pickAddress() {
//     Navigator.of(context).pop(_currentLatLong);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _future = _loadMap();
//     _cameraPosition = CameraPosition(target: _currentLatLong, zoom: 17.0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: mapSearchBar(
//         child: AutoCompleteTxtField(
//           hideSuggestionsOnKeyboardHide: true,
//           controller: _searchbarCtrl,
//           inputDecoration:
//               InputDecoration.collapsed(hintText: 'Cari lokasi..').copyWith(
//                   suffixIcon: Icon(
//             FontAwesomeIcons.map,
//             size: 14.0,
//           )),
//           callback: (String pattern) => _searchPlaces(pattern),
//           builder: (context, Prediction result) {
//             return ListTile(
//               dense: true,
//               title: Text(
//                 result.description!,
//                 maxLines: 3,
//               ),
//             );
//           },
//           onSuggestionSelected: (Prediction suggestion) {
//             _onSuggestionSelected(suggestion);
//           },
//           transitionBuilder: (context, suggestionBox, animationController) {
//             return FadeTransition(
//               child: suggestionBox,
//               opacity: CurvedAnimation(
//                 parent: animationController!,
//                 curve: Curves.easeIn,
//               ),
//             );
//           },
//         ),
//       ),
//       extendBodyBehindAppBar: true,
//       resizeToAvoidBottomInset: false,
//       body: FutureBuilder(
//         future: _future,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return defaultLoader();
//           }
//
//           if (snapshot.hasError) {
//             return errorFutureContainer(
//                 error: snapshot.error,
//                 callback: () {
//                   setState(() {
//                     _future = _loadMap();
//                   });
//                 },
//                 context: context);
//           } else {
//             return Stack(
//               children: [
//                 _buildMap(),
//                 _buildSelectedCoor(context),
//                 _buildInfoButton(context),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfoButton(BuildContext context) {
//     return Align(
//       alignment: Alignment.topRight,
//       child: GestureDetector(
//         onTap: () => AlertUtil.showResponseDialog(
//           title: 'Panduan',
//           content:
//               'Tahan lalu geser tanda pada peta untuk koordinat yang lebih presisi.',
//           context: context,
//           status: DialogStatus.info,
//         ),
//         child: Container(
//           margin: EdgeInsets.only(top: kToolbarHeight + 25.0, right: 15.0),
//           padding: EdgeInsets.only(
//             top: 2.0,
//             bottom: 4.0,
//             left: 2.0,
//             right: 2.0,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             boxShadow: <BoxShadow>[
//               BoxShadow(
//                 color: Colors.grey.shade700,
//                 blurRadius: 5.0,
//                 offset: Offset(0.5, 1.0),
//               ),
//             ],
//           ),
//           child: Icon(
//             FontAwesomeIcons.infoCircle,
//             color: Colors.green,
//             size: 30.0,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMap() {
//     return GoogleMap(
//       onMapCreated: onMapCreated,
//       initialCameraPosition: _cameraPosition,
//       markers: _markers,
//       myLocationButtonEnabled: false,
//       myLocationEnabled: false,
//       zoomControlsEnabled: false,
//     );
//   }
//
//   Widget _buildSelectedCoor(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).size.height / 14,
//             left: 15.0,
//             right: 15.0),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(15.0),
//           child: Container(
//             margin: EdgeInsets.only(bottom: 6.0),
//             padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade700,
//                   offset: Offset(1.0, 1.0), //(x,y)
//                   blurRadius: 5.0,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   _pickedAddress == ''
//                       ? 'Geser tanda atau cari alamat...'
//                       : _pickedAddress,
//                   style: TextStyle(
//                     fontWeight: FontWeight.w300,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 5,
//                 ),
//                 dividerForm(),
//                 Container(
//                   width: double.infinity,
//                   child: buttonCompact(
//                     text: 'Pilih',
//                     iconData: FontAwesomeIcons.checkCircle,
//                     onPressed: () => _pickAddress(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
