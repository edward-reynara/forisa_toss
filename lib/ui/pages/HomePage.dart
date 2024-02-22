// import 'package:ResellerSalesMobile/cores/configs/config_app.dart';
// import 'package:ResellerSalesMobile/cores/configs/config_colors.dart';
// import 'package:ResellerSalesMobile/cores/configs/config_constants.dart';
// import 'package:ResellerSalesMobile/cores/controllers/AuthController.dart';
// import 'package:ResellerSalesMobile/cores/controllers/HomeController.dart';
// import 'package:ResellerSalesMobile/cores/data/models/counter_info_model.dart';
// import 'package:ResellerSalesMobile/cores/data/models/home_menu_model.dart';
// import 'package:ResellerSalesMobile/cores/data/models/screen_argument_model.dart';
// import 'package:ResellerSalesMobile/cores/utils/AlertUtil.dart';
// import 'package:ResellerSalesMobile/cores/utils/FormatUtil.dart';
// import 'package:ResellerSalesMobile/ui/widgets/dividers.dart';
// import 'package:ResellerSalesMobile/ui/widgets/layouts.dart';
// import 'package:ResellerSalesMobile/ui/widgets/loaders.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forisa_package/models/screen_argument_model.dart';
import 'package:forisa_package/utils/AlertUtil.dart';
import 'package:forisa_package/utils/FormatUtil.dart';
import 'package:forisa_package/widgets/dividers.dart';
import 'package:forisa_package/widgets/loaders.dart';
import 'package:get/get.dart';

import '../../cores/configs/config_app.dart';
import '../../cores/configs/config_colors.dart';
import '../../cores/configs/config_constants.dart';
import '../../cores/controllers/AuthController.dart';
import '../../cores/controllers/HomeController.dart';
import '../../cores/data/models/counter_info_model.dart';
import '../../cores/data/models/home_menu_model.dart';
import '../widgets/layouts.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConfigColor.backgroundColor,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadHomeInfo();
          await controller.getHomeMenu();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: ConfigConstant.bottomNavBarPadding),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 180.0,
                  ),
                  Container(
                    height: 170.0,
                    decoration: BoxDecoration(
                      color: ConfigColor.primaryColor,
                      image: const DecorationImage(
                          alignment: Alignment.bottomRight,
                          image: CachedNetworkImageProvider(
                              '${ConfigApp.webUrl}/images/header_home_mobile.png'),
                          fit: BoxFit.contain,
                          repeat: ImageRepeat.noRepeat),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 15.0,
                    height: 75.0,
                    child: Container(
                      padding: EdgeInsets.zero,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () async {},
                            child: Container(
                              alignment: Alignment.center,
                              width: 75.0,
                              height: 75.0,
                              decoration: BoxDecoration(
                                color: ConfigColor.secondaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                FontAwesomeIcons.userAlt,
                                size: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                'Selamat ${FormatUtil.formatTextClock()},',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    controller.userModel.value.displayName ??
                                        '-',
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: kToolbarHeight,
                      right: 20,
                      child: Obx(
                        () => GestureDetector(
                          onTap: controller.badge.value.link == ''
                              ? null
                              : () async => await Get.toNamed(
                                      '/${controller.badge.value.link}',
                                      arguments: ScreenArgument(
                                          pageTitle:
                                              controller.badge.value.title))
                                  ?.whenComplete(
                                      () => controller.loadHomeInfo()),
                          child: badges.Badge(
                            badgeContent: Text(
                              controller.badge.value.notifQty!,
                              style: const TextStyle(
                                color: ConfigColor.secondaryTextColor,
                              ),
                            ),
                            // badgeColor: Colors.red, //TODO CHECK EDO
                            child: const Icon(
                              FontAwesomeIcons.bell,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              _buildHomeMenu(context),
              _buildCounterInfo(),
              // _buildSubtitle('Promo Hari Ini'),
              // _buildCarouselPromo(imageSliders),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardUserInfo(BuildContext context) => Positioned(
        bottom: 0.0,
        height: 75.0,
        left: 15.0,
        right: 15.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Nomor Identitas',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    Obx(
                      () => Expanded(
                        child: Text(
                          controller.userModel.value.userName ?? '-',
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: SizedBox(
                  child: Container(
                    color: Colors.black54,
                  ),
                  width: 2.0,
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        'Posisi : ${controller.userModel.value.position ?? '-'}',
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildCounterInfo() {
    return Obx(() {
      if (controller.isProgressLoading.value) {
        return Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: horizontalBoxLoader(),
        );
      }

      if (controller.counterInfoList.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSubtitle('Progress Anda'),
            dividerForm(),
            SizedBox(
              width: double.infinity,
              height: 100.0,
              child: ListView.builder(
                  itemCount: controller.counterInfoList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 15.0),
                  itemBuilder: (context, index) {
                    CounterInfo item = controller.counterInfoList[index];
                    return GestureDetector(
                      onTap: item.onClick,
                      onLongPress: () => AlertUtil.showSnackbarStatic(
                          'Info', 'Tap to detail', AlertStatus.info),
                      child: Container(
                        width: 150.0,
                        margin: const EdgeInsets.only(right: 5.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              item.fromColor!,
                              item.toColor!,
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: ConfigColor.secondaryTextColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                item.qty,
                                style: const TextStyle(
                                    fontSize: 24.0,
                                    color: ConfigColor.secondaryTextColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }

  // Widget _buildCarouselPromo(List<Widget> sliders) {
  //   return Container(
  //     child: CarouselSlider(
  //       options: CarouselOptions(
  //         height: 150.0,
  //         aspectRatio: 2.2,
  //         initialPage: (sliders.length ~/ 2),
  //         enlargeCenterPage: true,
  //         enlargeStrategy: CenterPageEnlargeStrategy.height,
  //       ),
  //       items: sliders,
  //     ),
  //   );
  // }

  Widget _buildSubtitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        title,
        style: const TextStyle(
          color: ConfigColor.primaryTextColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHomeMenu(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        width: double.infinity,
        // height: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          if (controller.isMenuLoading.value) {
            return GridView.count(
              physics: const BouncingScrollPhysics(),
              mainAxisSpacing: 2.0,
              crossAxisCount: 4,
              controller: controller.scrollController,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: List<Widget>.generate(8, (i) => roundmenuLoader()),
            );
          }

          if (controller.errorMenuLoading.code != null) {
            return errorFutureContainer(context: context, error: controller.errorMenuLoading);
          } else {
            HomeMenuModel homeMenuModel = controller.homeMenuModel!;
            List<Arrdatum> menus = homeMenuModel.data!.arrdata!
                .where((el) => el.position != 'FOOTER' && el.menuLvl == '1')
                .toList();

            return GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                crossAxisCount: 4,
                controller: controller.scrollController,
                shrinkWrap: true,
                children: menus.asMap().entries.take(8).map((el) {
                  Arrdatum menu = el.value;
                  int index = el.key;

                  if (index == 7) {
                    return GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (modalContext) {
                          return _buildModalMenu(
                              modalContext, menus, homeMenuModel);
                        },
                      ),
                      child: Container(
                        padding: EdgeInsets.zero,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[400],
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/load_menu.png'),
                                      fit: BoxFit.contain),
                                ),
                              ),
                            ),
                            const Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Text(
                                'Lainnya',
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return _buildMenuItem(context, menu, homeMenuModel);
                }).toList());
          }
        }),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Arrdatum menu, HomeMenuModel homeMenuModel) =>
      GestureDetector(
        onTap: () async {
          if (menu.link == 'logout') {
            AuthController authController = Get.put(AuthController(),
                tag: FormatUtil.getRandomString(type: RandomType.classId));
            await authController.doLogout(context);
          } else {
            if (menu.isHasChild == '1') {
              List<Arrdatum> submenus = homeMenuModel.data!.arrdata!
                  .where((m) => m.parentId == menu.menuId)
                  .toList();
              Get.toNamed('/submenu',
                  arguments: ScreenArgument(
                      id: menu.menuId,
                      pageTitle: menu.menuDisplayName,
                      listPayload: submenus));
            } else {
              await Get.toNamed('/${menu.link}',
                      arguments: ScreenArgument(
                          pageTitle: menu.menuDisplayName, id: menu.menuId))
                  ?.whenComplete(() => controller.loadHomeInfo());
            }
          }
        },
        child: Container(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[400],
                    image: DecorationImage(
                        image: (menu.icon!.isEmpty
                            ? const AssetImage('assets/images/img-notfound.png')
                            : CachedNetworkImageProvider(menu.icon!)) as ImageProvider,
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '${menu.menuDisplayName}',
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildModalMenu(BuildContext modalContext, List<Arrdatum> menus,
      HomeMenuModel homeMenuModel) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.7,
      expand: false,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          primary: false,
          shrinkWrap: true,
          controller: controller,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 70.0,
                height: 5.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const Text(
              'Menu Lainnya',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              crossAxisCount: 4,
              shrinkWrap: true,
              children: menus
                  .map((Arrdatum menu) => _buildMenuItem(modalContext, menu, homeMenuModel))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
