import 'package:flutter/material.dart';
import 'package:n_reach_nsbm/size_config.dart';

Color kPrimaryColor = const Color.fromARGB(255, 0, 0, 0);
Color kSecondaryColor = const Color.fromARGB(255, 53, 53, 53);
Color kThemeColor = const Color.fromARGB(255, 3, 95, 10);
final kTitle = TextStyle(
  fontFamily: 'poppins',
  fontSize: SizeConfig.blockSizeH! * 3,
  color: kPrimaryColor,
  fontWeight: FontWeight.bold,
);

final kBodyText = TextStyle(
  color: kSecondaryColor,
  fontSize: SizeConfig.blockSizeH! * 1.5,
  fontFamily: 'poppins',
);
