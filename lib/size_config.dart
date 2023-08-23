import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQuerydata;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeH;
  static double? blockSizeV;

  void init(BuildContext context) {
    _mediaQuerydata = MediaQuery.of(context);
    screenWidth = _mediaQuerydata!.size.width;
    screenHeight = _mediaQuerydata!.size.height;
    blockSizeH = screenHeight! / 100;
    blockSizeV = screenWidth! / 100;
  }
}
