import 'package:flutter/material.dart';
import 'package:forisa_package/widgets/buttons.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../cores/configs/config_colors.dart';
import '../../cores/controllers/OnboardingController.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingController controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: controller.onboardingList,
      onDone: () => controller.setDoneOnboarding(),
      done: btnOnboarding(title: 'Mulai'),
      showSkipButton: true,
      showNextButton: true,
      skip: const Text(
        'Lewati',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      next: btnOnboarding(title: 'Lanjut'),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: ConfigColor.primaryColor,
        color: ConfigColor.primaryTextColor,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      dotsFlex: 0,
      nextFlex: 0,
    );
  }
}