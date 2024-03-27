import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../configs/config.dart';

AppBar overlayAppBar(BuildContext context) {
  return AppBar(
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      child: Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/images/forisa-tanpa-kata.png',
            fit: BoxFit.cover,
            height: kToolbarHeight - 10,
          )),
    ),
    // title: Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Container(
    //     width: 100.0,
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage('assets/images/forisa-tanpa-kata.png'),
    //         fit: BoxFit.fitHeight,
    //       ),
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(30.0),
    //     ),
    //   ),
    // ),
    elevation: 0.0,
    backgroundColor: Colors.white,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.only(
    //     bottomRight: Radius.circular(15.0),
    //     bottomLeft: Radius.circular(15.0),
    //   ),
    // ),
    centerTitle: false,
    actions: <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 20.0),
        alignment: Alignment.bottomCenter,
        child: const Text(
          !Config.isDebugMode ? 'TOSS' : 'TOSS DEV',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

AppBar defaultAppBar({
  required String title,
  List<Widget> actions = const [],
}) =>
    AppBar(
      title: Text(title),
      backgroundColor: Colors.orange,
      actions: actions,
    );

AppBar defaultAppBarHero({
  required String id,
  required String title,
  List<Widget> actions = const [],
}) =>
    AppBar(
      title: Hero(
        tag: id,
        child: Text(title),
      ),
      backgroundColor: Colors.orange,
      actions: actions,
    );

PreferredSizeWidget searchAppBar(
    {required String title,
    required TextEditingController controller,
    required void Function() onSubmit}) {
  return AppBar(
    backgroundColor: Colors.orange,
    title: Container(
      margin: EdgeInsets.zero,
      height: kToolbarHeight / 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            isCollapsed: true,
            hintText: title,
            border: InputBorder.none,
          ),
          // autofocus: true,
          textInputAction: TextInputAction.search,
          minLines: 1,
          maxLines: 1,
          textAlign: TextAlign.start,
          onEditingComplete: () {
            onSubmit();
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ),
    ),
    actions: [
      IconButton(
          icon: const Icon(FontAwesomeIcons.magnifyingGlass),
          onPressed: () {
            onSubmit();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          splashColor: Colors.grey[400])
    ],
  );
}
