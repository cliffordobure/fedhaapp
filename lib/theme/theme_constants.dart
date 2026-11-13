import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class AppColors {
//   static Color primaryColor = const Color(0xFF03a63c);
//   static Color primaryGraph = const Color(0xFF3CDB73);
//   static Color darkBlueColor = const Color(0xFF012340);
//   static Color darkGreenColor = const Color(0xFF027333);
//   static Color greyColor = const Color(0xFFC7C7C7);
//   static Color fadeBlackColor = const Color(0xff919191);
//   // new
//   static Color scaffoldBackground = const Color(0xFFF7F6F9);
//   static Color darkColor = const Color(0xFF333333);
//   static Color whiteColor = const Color(0xFFFFFFFF);
//   static Color dangerColor = Colors.red;
//   static Color warningColor = Colors.orange;

//   static const Color unreadNotificationColor = Color(0xFFF5F5F5);
//   static const Color unreadNotificationTextColor = Color(0xFF333333);
// }

// ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   // primaryColor: AppColors.primaryColor,
//   visualDensity: VisualDensity.adaptivePlatformDensity,
//   elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ButtonStyle(
//     backgroundColor: WidgetStateProperty.all<Color>(AppColors.primaryColor),
//     padding: WidgetStateProperty.all<EdgeInsets>(
//         const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
//     shape:
//         WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(26),
//     )),
//   )),
//   fontFamily: "Google Sans",
//   useMaterial3: true,
//   textTheme: TextTheme(
//       titleLarge: const TextStyle(fontSize: 24, color: Colors.black),
//       displayMedium: const TextStyle(fontSize: 14, color: Colors.black),
//       displayLarge: const TextStyle(fontSize: 15, color: Colors.black),
//       displaySmall: TextStyle(fontSize: 12, color: AppColors.greyColor)),
//   inputDecorationTheme: InputDecorationTheme(
//     errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(26),
//         borderSide: const BorderSide(color: Colors.red, width: 1.0)),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(26),
//       borderSide: BorderSide(color: AppColors.darkGreenColor, width: 1.0),
//     ),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(26),
//       borderSide: BorderSide(color: AppColors.greyColor, width: 1.0),
//     ),
//   ),
//   colorScheme: ColorScheme.light(
//       primary: AppColors.primaryColor,
//       error: AppColors.dangerColor,
//       surface: AppColors.scaffoldBackground),
// );

class AppColors {
  static Color primaryColor = const Color(0xFF03a63c);
  static Color primaryGraph = const Color(0xFF3CDB73);
  static Color darkBlueColor = const Color(0xFF012340);
  static Color darkGreenColor = const Color(0xFF027333);
  static Color greyColor = const Color(0xFFC7C7C7);
  static Color fadeBlackColor = const Color(0xff919191);

  // New Colors
  static Color scaffoldBackground = const Color(0xFFF7F6F9);
  static Color darkColor = const Color(0xFF333333);
  static Color whiteColor = const Color(0xFFFFFFFF);
  static Color dangerColor = Colors.red;
  static Color warningColor = Colors.orange;

  static const Color unreadNotificationColor = Color(0xFFF5F5F5);
  static const Color unreadNotificationTextColor = Color(0xFF333333);
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: GoogleFonts.poppins().fontFamily,
  useMaterial3: true,

  // Colors
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.scaffoldBackground,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.darkGreenColor,
    surface: AppColors.whiteColor,
    error: AppColors.dangerColor,
    onPrimary: AppColors.whiteColor,
    onSecondary: AppColors.whiteColor,
    onSurface: AppColors.darkColor,
    onError: AppColors.whiteColor,
  ),

  // ElevatedButton Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      textStyle: WidgetStateProperty.all(
        GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  ),

  // Text Theme — Poppins (matches home mock)
  textTheme: GoogleFonts.poppinsTextTheme().copyWith(
    headlineSmall: GoogleFonts.poppins(
      color: AppColors.darkBlueColor,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.poppins(
      color: AppColors.darkColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    titleMedium: GoogleFonts.poppins(
      color: const Color(0xff919191),
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.poppins(
      color: AppColors.darkColor.withValues(alpha: 0.5),
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.black,
    ),
    displayLarge: GoogleFonts.poppins(
      fontSize: 15,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 12,
      color: AppColors.greyColor,
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: const Color(0XFF555555),
      fontWeight: FontWeight.bold,
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: BorderSide(color: AppColors.darkGreenColor, width: 1.0),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(26),
      borderSide: BorderSide(color: AppColors.greyColor, width: 1.0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  ),

  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.whiteColor,
    iconTheme: IconThemeData(color: AppColors.darkBlueColor),
    titleTextStyle: TextStyle(
      color: AppColors.darkBlueColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    elevation: 1,
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: AppColors.whiteColor,
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: AppColors.whiteColor,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  // Icon Theme
  iconTheme: IconThemeData(
    color: AppColors.darkColor,
    size: 24,
  ),
);


// class AppColors {
//   static Color primaryColor = const Color(0xFF03a63c);
//   static Color primaryGraph = const Color(0xFF3CDB73);
//   static Color darkBlueColor = const Color(0xFF012340);
//   static Color darkGreenColor = const Color(0xFF027333);
//   static Color greyColor = const Color(0xFFC7C7C7);
//   static Color fadeBlackColor = const Color(0xff919191);
//   static Color scaffoldBackground = const Color(0xFFF7F6F9);
//   static Color darkColor = const Color(0xFF333333);
//   static Color whiteColor = const Color(0xFFFFFFFF);
//   static Color dangerColor = Colors.red;
//   static Color warningColor = Colors.orange;

//   static const Color unreadNotificationColor = Color(0xFFF5F5F5);
//   static const Color unreadNotificationTextColor = Color(0xFF333333);
// }

// ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   visualDensity: VisualDensity.adaptivePlatformDensity,
//   primaryColor: AppColors.primaryColor,
//   scaffoldBackgroundColor: AppColors.scaffoldBackground,
//   fontFamily: "Google Sans",
//   useMaterial3: true,

//   colorScheme: ColorScheme.light(
//     primary: AppColors.primaryColor,
//     secondary: AppColors.darkBlueColor,
//     error: AppColors.dangerColor,
//     surface: AppColors.whiteColor,
//     onPrimary: AppColors.whiteColor,
//     onSecondary: AppColors.whiteColor,
//     onSurface: AppColors.darkColor,
//   ),

//   textTheme: TextTheme(
//     displayLarge: TextStyle(
//         fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkColor),
//     displayMedium: TextStyle(
//         fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkColor),
//     displaySmall: TextStyle(
//         fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkColor),
//     headlineMedium: TextStyle(
//         fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.darkColor),
//     headlineSmall: TextStyle(
//         fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.darkColor),
//     titleLarge: TextStyle(
//         fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkColor),
//     bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkColor),
//     bodyMedium: TextStyle(fontSize: 14, color: AppColors.fadeBlackColor),
//     labelLarge: TextStyle(
//         fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkColor),
//     bodySmall: TextStyle(fontSize: 12, color: AppColors.greyColor),
//   ),

//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ButtonStyle(
//       backgroundColor: WidgetStateProperty.all<Color>(AppColors.primaryColor),
//       foregroundColor: WidgetStateProperty.all<Color>(AppColors.whiteColor),
//       padding: WidgetStateProperty.all<EdgeInsets>(
//         const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       ),
//       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//         RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(26),
//         ),
//       ),
//       elevation: WidgetStateProperty.all(2),
//     ),
//   ),

//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: AppColors.scaffoldBackground,
//     errorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(26),
//       borderSide: BorderSide(color: AppColors.dangerColor, width: 1.0),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(26),
//       borderSide: BorderSide(color: AppColors.darkGreenColor, width: 1.0),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(26),
//       borderSide: BorderSide(color: AppColors.greyColor, width: 1.0),
//     ),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(26),
//       borderSide: BorderSide(color: AppColors.greyColor, width: 1.0),
//     ),
//     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     labelStyle: TextStyle(color: AppColors.fadeBlackColor),
//     hintStyle: TextStyle(color: AppColors.greyColor),
//   ),

//   cardTheme: CardTheme(
//     color: AppColors.whiteColor,
//     elevation: 2,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(12),
//     ),
//   ),

//   dividerTheme: DividerThemeData(
//     color: AppColors.greyColor,
//     thickness: 1,
//     space: 1,
//   ),

//   appBarTheme: AppBarTheme(
//     backgroundColor: AppColors.primaryColor,
//     foregroundColor: AppColors.whiteColor,
//     elevation: 0,
//   ),

//   // Add more theme customizations here
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: AppColors.primaryColor,
//     foregroundColor: AppColors.whiteColor,
//   ),

//   switchTheme: SwitchThemeData(
//     thumbColor:
//         WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
//       if (states.contains(WidgetState.selected)) {
//         return AppColors.primaryColor;
//       }
//       return AppColors.greyColor;
//     }),
//     trackColor:
//         WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
//       if (states.contains(WidgetState.selected)) {
//         return AppColors.primaryColor.withOpacity(0.5);
//       }
//       return AppColors.greyColor.withOpacity(0.5);
//     }),
//   ),

//   checkboxTheme: CheckboxThemeData(
//     fillColor:
//         WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
//       if (states.contains(WidgetState.selected)) {
//         return AppColors.primaryColor;
//       }
//       return AppColors.greyColor;
//     }),
//     checkColor: WidgetStateProperty.all(AppColors.whiteColor),
//   ),

//   radioTheme: RadioThemeData(
//     fillColor:
//         WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
//       if (states.contains(WidgetState.selected)) {
//         return AppColors.primaryColor;
//       }
//       return AppColors.greyColor;
//     }),
//   ),

//   sliderTheme: SliderThemeData(
//     activeTrackColor: AppColors.primaryColor,
//     inactiveTrackColor: AppColors.greyColor,
//     thumbColor: AppColors.primaryColor,
//     overlayColor: AppColors.primaryColor.withOpacity(0.2),
//   ),
// );
