import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'login.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageDecoration pageDecoration({Color? pageColor}) => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
        bodyTextStyle: TextStyle(fontSize: 16.0),
        //descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: pageColor ?? Colors.white,
        imagePadding: EdgeInsets.zero,
        bodyAlignment: Alignment.center,
        imageFlex: 1,
        bodyFlex: 1,
      );
  List<PageViewModel> onboardingList = [];
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    this.onboardingList = [
    PageViewModel(
      image: Image.asset('assets/images/logo.png'),
      title: 'Hi,',
      body:
          'Terima kasih telah menginstall aplikasi absensi karyawan PT. Forisa Nusapersada',
      decoration: pageDecoration()
    ),
    PageViewModel(
      image: Image.asset('assets/images/logo.png'),
      title: 'Tentang',
      body:
          'Aplikasi terkait absensi, pengajuan lembur dan ketidakhadiran yang dilakukan oleh karyawan secara mandiri',
      decoration: pageDecoration()
    ),
    PageViewModel(
      image: Image.asset('assets/images/logo.png'),
      title: 'Fitur',
      body: 'Absensi, Pengajuan, Berita, dll',
      decoration: pageDecoration()
    ),
  ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: this.onboardingList,
      onDone: () => doneOnboarding(context),
      done: btnOnboarding(title: 'Mulai'),
      showSkipButton: true,
      showNextButton: true,
      skip: Text('Lewati', style: TextStyle(
        fontWeight: FontWeight.bold
      ),),
      next: btnOnboarding(title: 'Lanjut'),
      dotsDecorator: DotsDecorator(
        size: Size.square(10.0),
        activeSize: Size(20.0, 10.0),
        activeColor: Colors.green,
        color: Colors.grey,
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      //skipFlex: 0,
      nextFlex: 0,
      globalBackgroundColor: Colors.white,
    );
  }

  Future<void> doneOnboarding(BuildContext context) async {
    await secureStorage.write(key: 'intro', value: 'true');
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  Widget btnOnboarding({required String title}) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        gradient: LinearGradient(colors: <Color>[
          Colors.green,
          Colors.green[300]!,
        ]),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
}
