import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

// const kPaddingMargin = EdgeInsets.all(28);
TextTheme textTheme = TextTheme(
  headline1: GoogleFonts.poppins(
      fontSize: 28.sp, fontWeight: FontWeight.w600, letterSpacing: -1.5),
  headline2: GoogleFonts.poppins(
      fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.poppins(fontSize: 47, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.poppins(
      fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.poppins(
      fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.poppins(
      fontSize: 16.sp, fontWeight: FontWeight.w600, letterSpacing: -1),
  subtitle2: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.poppins(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.poppins(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.poppins(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.poppins(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

extension CustomTextTheme on TextTheme {
  TextStyle description({String? color = "000000"}) {
    return GoogleFonts.poppins(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: -1,
        color: HexColor("$color"));
  }

  TextStyle medium({String? color = "000000"}) {
    return GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: -1,
        color: HexColor("$color"));
  }

  TextStyle h1({String? color = "000000"}) {
    return GoogleFonts.poppins(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.5,
        color: HexColor("$color"));
  }

  TextStyle sub16({String? color = "000000"}) {
    return GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        color: HexColor("$color"));
  }

  TextStyle regular13({String? color = "000000", double opacity = 1}) {
    return GoogleFonts.poppins(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: -1,
        color: HexColor("$color").withOpacity(opacity));
  }

  TextStyle sub14({String? color = "0D0D26"}) {
    return GoogleFonts.poppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        color: HexColor("$color"));
  }

  TextStyle medium12({String? color = "0D0D26", double opacity = 1}) {
    return poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
        opacity: opacity);
  }

  TextStyle medium14({String? color = "0D0D26", double opacity = 1}) {
    return poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        opacity: opacity,
        letterSpacing: -0.01);
  }

  TextStyle semibold16({String? color = "FFFFFF", double opacity = 1}) {
    return poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        opacity: opacity);
  }

  TextStyle semibold20({String? color = "290200", double opacity = 1}) {
    return poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        opacity: opacity);
  }

  TextStyle regular11({String? color = "FFFFFF", double opacity = 1}) {
    return poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
        opacity: opacity,
        letterSpacing: -0.01);
  }

  TextStyle headline17({String? color = "FFFFFF", double opacity = 1}) {
    return poppins(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: color,
        opacity: opacity,
        letterSpacing: -1.5);
  }

  TextStyle headline14({String? color = "FFFFFF", double opacity = 1}) {
    return poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        opacity: opacity,
        letterSpacing: -0.01);
  }

  TextStyle headline22({String? color = "FFFFFF", double opacity = 1}) {
    return poppins(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: color,
        opacity: opacity,
        letterSpacing: -0.01);
  }

  TextStyle poppins(
      {double? fontSize = 14,
      FontWeight? fontWeight = FontWeight.w400,
      double? letterSpacing,
      String? color = "0D0D26",
      double opacity = 1}) {
    return GoogleFonts.poppins(
        fontSize: fontSize?.sp,
        fontWeight: fontWeight,
        letterSpacing: -1,
        color: HexColor("$color").withOpacity(opacity));
  }
}
