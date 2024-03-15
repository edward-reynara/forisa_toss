import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../cores/components/error_future_component.dart';
import '../../cores/components/shimmers.dart';
import '../../cores/configs/config.dart';
import '../../cores/models/model_arguments.dart';
import '../../cores/models/model_profile.dart';
import '../../cores/models/model_user_customer.dart';
import '../../cores/utils/api_service.dart';
import '../../cores/utils/constants.dart';
import '../../cores/utils/tools.dart';

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({super.key});

  @override
  _ProfileHomePageState createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  late Future _futureProfile;
  ApiService apiService = ApiService();
  Profile? profile;
  late UserCustomer userCustomer;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late List<String> deviceInfo;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _futureProfile = _loadProfile();
    // _loadMappingDistributor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: constBottomNavbarPadding),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Data Karyawan',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: fullWidthColShimmer(true),
                  ),
                  //Data Asuransi
                  Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Data Asuransi',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    height: MediaQuery.of(context).size.height * 0.2,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20.0),
                      itemBuilder: (context, index) {
                        return rectHorizonListShimmer(true, context);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasError && profile != null) {
            var insurances = groupBy<InsuranceDatum, String>(
                profile!.insuranceData, (obj) => obj.insuranceCode);
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Data Karyawan',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Flexible(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.user,
                                    color: Colors.green,
                                    size: 20.0,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text('Nama Lengkap'),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Text(
                                profile!.profileData.employeeName,
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                textAlign: TextAlign.right,
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
                            const Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.idCardClip,
                                  color: Colors.green,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text('Nomor Induk Karyawan'),
                              ],
                            ),
                            Text(profile!.profileData.employeeNo),
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
                            const Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.rightToBracket,
                                  color: Colors.green,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text('Tanggal Masuk'),
                              ],
                            ),
                            Text(Tools.formatIdDate(
                                'dd MMMM yyyy', profile!.profileData.joinDate)),
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
                            const Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.envelope,
                                  color: Colors.green,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text('Alamat Email'),
                              ],
                            ),
                            Text(profile!.profileData.email),
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
                            const Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.handPointRight,
                                  color: Colors.green,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text('Posisi'),
                              ],
                            ),
                            Text(profile!.profileData.position),
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
                            const Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.turnUp,
                                  color: Colors.green,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text('Level'),
                              ],
                            ),
                            Text(profile!.profileData.empLevel),
                          ],
                        ),
                        Divider(
                          height: 20.0,
                          thickness: 2.0,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              '/leavedetail',
                              arguments:
                                  ScreenArguments(titleMenu: 'Sisa Cuti')),
                          child: Container(
                            color: Colors.white,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.circleInfo,
                                        color: Colors.green,
                                        size: 20.0,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text('Sisa Cuti'),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text('Lihat'),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.arrowRight,
                                      color: Colors.grey,
                                      size: 14.0,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 20.0,
                          thickness: 2.0,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              '/coverage_area',
                              arguments:
                                  ScreenArguments(titleMenu: 'POH / Work Location')),
                          child: Container(
                            color: Colors.white,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.locationPin,
                                        color: Colors.green,
                                        size: 20.0,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text('POH / Work Location'),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text('Lihat'),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.arrowRight,
                                      color: Colors.grey,
                                      size: 14.0,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 20.0,
                          thickness: 2.0,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  //Data Asuransi
                  Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Data Asuransi',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (profile!.insuranceData.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, bottom: 10.0, right: 20.0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.green[500],
                        gradient: LinearGradient(
                          colors: [Colors.orange[400]!, Colors.red[400]!],
                        ),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.ban, color: Colors.white),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Data Asuransi belum ada',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20.0, bottom: 10.0, right: 20.0),
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: 16 / 9,
                        mainAxisSpacing: 2.0,
                        children: insurances.entries
                            .map((e) => GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/insurance', arguments: ScreenArguments(
                                    titleMenu: 'Asuransi ${e.value[0].insuranceCategory}',
                                    listData: e.value,
                                  )),
                                  child: Container(
                                    margin: const EdgeInsets.all(2.0),
                                    padding:
                                        const EdgeInsets.only(top: 4.0, left: 8.0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange,
                                          Colors.orange.shade300,
                                          Colors.orange.shade100
                                              .withOpacity(0.7),
                                        ],
                                        begin: Alignment.bottomRight,
                                        end: Alignment.topLeft,
                                      ),
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 3.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: CachedNetworkImage(
                                            height: 24.0,
                                            fit: BoxFit.contain,
                                            imageUrl:
                                                '${Config.webUrl}/images/${e.key}-logo.png',
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Colors.green,
                                              Colors.greenAccent.shade400,
                                            ]),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(16.0),
                                              bottomRight:
                                                  Radius.circular(14.0),
                                            ),
                                          ),
                                          child: const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Lihat Detail',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 4.0,
                                              ),
                                              FaIcon(
                                                FontAwesomeIcons
                                                    .circleChevronRight,
                                                size: 18.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return errorFutureContainer(
                error: snapshot.error,
                context: context,
                callback: () {
                  setState(() {
                    _futureProfile = _loadProfile();
                  });
                });
          }
        },
      ),
    );
  }

  _loadProfile() async {
    Dio dio = apiService.getApiClient(context: context);
    Response response;

    try {
      response = await dio.get(
        '/user',
      );

      setState(() {
        profile = Profile.fromJson(response.data);
      });
    } catch (e) {
      e is DioException
          ? throw e
          : Tools.showAlert(context, 'Exception', e.toString(), 'error');
    }
  }
}
