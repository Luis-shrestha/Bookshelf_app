import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kHeadingTextStyle = ThemeData(
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    titleLarge: GoogleFonts.montserrat(
      fontSize: 32, // Set font size to 40
      fontWeight: FontWeight.bold, // Set font weight to bold
      // Add any additional properties as needed
    ),
  ),
);

final kHeading2TextStyleBold = ThemeData(
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    displaySmall: GoogleFonts.montserrat(
      fontSize: 32, // Set font size to 40
      fontWeight: FontWeight.bold, // Set font weight to bold
      // Add any additional properties as needed
    ),
  ),
);

final kHeading2TextStyle = ThemeData(
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 20, // Set font size to 40
      // Add any additional properties as needed
    ),
  ),
);

final kRegularTextStyle = ThemeData(
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    bodySmall: GoogleFonts.montserrat(
      fontSize: 14, // Set font size to 40
      fontWeight: FontWeight.w700,
      // Add any additional properties as needed
    ),
  ),
);

final kRegular2TextStyle = ThemeData(
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    bodySmall: GoogleFonts.montserrat(
      fontWeight: FontWeight.w500,
      // Add any additional properties as needed
    ),
  ),
);
