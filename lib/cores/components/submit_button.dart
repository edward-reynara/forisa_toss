import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Container buttonIconContainer({
  required IconData iconData,
  required void Function() onPressed,
  required String text,
  Color? buttonColor,
  Color? textColor,
  Color? iconColor,
}) =>
    Container(
      width: double.infinity,
      height: 75.0,
      padding: const EdgeInsets.symmetric(
        // horizontal: 10.0,
        vertical: 10.0,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          iconData,
          color: iconColor ?? Colors.white,
          size: 20.0,
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          )),
          backgroundColor:
              MaterialStateProperty.all(buttonColor ?? Colors.green),
        ),
        label: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );

Widget buttonCompact({
  IconData? iconData,
  required void Function()? onPressed,
  required String text,
  bool isSubmitting = false,
  Color? buttonColor,
  Color? textColor,
  double? elevation,
  double? size,
}) {
  if (iconData != null && !isSubmitting) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(elevation ?? 0.0),
        backgroundColor:
            MaterialStateProperty.all(buttonColor ?? Colors.orange),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
      ),
      onPressed: isSubmitting ? null : onPressed,
      icon: Icon(
        iconData,
        size: (size ?? 16.0) * 1.2,
        color: textColor ?? Colors.white,
      ),
      label: Text(
        text,
        style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: size ?? 16.0),
      ),
    );
  }

  return ElevatedButton(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(elevation ?? 0.0),
      backgroundColor:
          MaterialStateProperty.all(buttonColor ?? Colors.orange),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
    ),
    onPressed: isSubmitting ? null : onPressed,
    child: isSubmitting
        ? FittedBox(
            fit: BoxFit.contain,
            child: SpinKitCircle(
              color: Colors.white,
              size: (size ?? 16.0) * 1.2,
            ),
          )
        : Text(
            text,
            style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: size ?? 16.0),
          ),
  );
}