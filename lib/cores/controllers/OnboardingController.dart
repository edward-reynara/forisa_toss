import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forisa_package/providers/provider_pref.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../configs/config_colors.dart';
import '../routes/pages.dart';

class OnboardingController extends GetxController {
  List<PageViewModel> onboardingList = <PageViewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOnboardingList();
  }

  PageDecoration pageDecoration({Color? pageColor}) => PageDecoration(
        titleTextStyle: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
        bodyTextStyle: const TextStyle(fontSize: 16.0),
        // descriptionPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: pageColor ?? ConfigColor.backgroundColor,
        imagePadding: EdgeInsets.zero,
      );

  fetchOnboardingList() {
    onboardingList = <PageViewModel>[
      PageViewModel(
        title: "Halo Pejuang Sales",
        body: "Terima kasih telah menginstall aplikasi Sales Mobile Forisa",
        image: _buildImageIntro('assets/images/onboarding_cart.svg',
            imgType: 'svg'),
        decoration: pageDecoration(),
      ),
      PageViewModel(
        title: 'Analisis Penjualan',
        body: 'Lihat tren penjualan saat ini dan performa setiap reseller',
        image: _buildImageIntro('assets/images/onboarding_data_report.svg',
            imgType: 'svg'),
        decoration: pageDecoration(),
      ),
      PageViewModel(
        title: 'Transaksi Online',
        body: 'Tidak lagi penggunaan kertas, semua disimpan secara online',
        image: _buildImageIntro(
            'assets/images/onboarding_online_transaction.svg',
            imgType: 'svg'),
        decoration: pageDecoration(),
      ),
    ];
  }

  _buildImageIntro(String assetName, {String? imgType}) {
    Widget buildChild() {
      switch (imgType) {
        case 'svg':
          return Padding(
            padding: const EdgeInsets.all(50.0),
            child: SvgPicture.asset(
              assetName,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          );
        default:
          return Image.asset(assetName);
      }
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: buildChild(),
    );
  }

  setDoneOnboarding() async {
    await PrefProvider.secureStorage
        .write(key: PrefProvider.IS_DONE_INTRO_KEY, value: 'true');
    Get.offAllNamed(Routes.LOGIN_PAGE);
  }
}
