import 'package:flutter/material.dart';

class AppTheme {
  // Primary color palette - mint green
  static const Color primaryMint = Color(0xFF6ECB94);
  static const Color primaryLightMint = Color(0xFF9FDFB8);
  static const Color primaryDarkMint = Color(0xFF4A996B);
  
  // Secondary colors
  static const Color accentTeal = Color(0xFF47C2BE);
  static const Color accentBlue = Color(0xFF4A90E2);
  static const Color accentYellow = Color(0xFFFDD563);
  
  // Neutral colors
  static const Color background = Color(0xFFF5F9F7);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFE4F0E9);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFF688596);

  // Game-specific colors
  static const Color successGreen = Color(0xFF5CB85C);
  static const Color errorRed = Color(0xFFD9534F);
  static const Color infoBlue = Color(0xFF5BC0DE);
  static const Color warningYellow = Color(0xFFF0AD4E);
  
  // Create the theme data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryMint,
      colorScheme: ColorScheme.light(
        primary: primaryMint,
        secondary: accentTeal,
        background: background,
        surface: surfaceLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textDark,
        onSurface: textDark,
        error: errorRed,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: primaryMint,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Gamified card style
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceLight,
        shadowColor: primaryDarkMint.withOpacity(0.3),
      ),
      // Rounded button style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMint,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 3,
          shadowColor: primaryDarkMint.withOpacity(0.4),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      // Outlined button with mint accent
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryMint,
          side: BorderSide(color: primaryMint, width: 2),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      // Text button with mint accent
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryMint,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // Modern typography
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textDark,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textDark,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: textDark,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: textDark,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: textDark,
          fontSize: 14,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          color: primaryMint,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      // Gamified checkbox style
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.withOpacity(.32);
          }
          return primaryMint;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      // Gamified slider style
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryMint,
        inactiveTrackColor: primaryLightMint.withOpacity(0.4),
        thumbColor: primaryMint,
        overlayColor: primaryMint.withOpacity(0.2),
        valueIndicatorColor: primaryDarkMint,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Modern radio button style
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.withOpacity(.32);
          }
          return primaryMint;
        }),
      ),
      // Animated switch style
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.withOpacity(.32);
          } else if (states.contains(MaterialState.selected)) {
            return primaryMint;
          }
          return Colors.white;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.withOpacity(.12);
          } else if (states.contains(MaterialState.selected)) {
            return primaryLightMint;
          }
          return Colors.grey.withOpacity(.38);
        }),
      ),
      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentTeal,
        foregroundColor: Colors.white,
      ),
      // Divider style
      dividerTheme: DividerThemeData(
        color: surfaceDark,
        thickness: 1,
        space: 32,
      ),
      iconTheme: IconThemeData(
        color: primaryMint,
        size: 24,
      ),
      // Visual feedback for taps
      splashColor: primaryLightMint.withOpacity(0.3),
      highlightColor: primaryLightMint.withOpacity(0.1),
    );
  }
  
  // Utility method for game-related card decorations
  static BoxDecoration gameCardDecoration() {
    return BoxDecoration(
      color: surfaceLight,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: primaryDarkMint.withOpacity(0.2),
          offset: Offset(0, 4),
          blurRadius: 12,
        ),
      ],
      border: Border.all(
        color: primaryLightMint,
        width: 1.5,
      ),
    );
  }
  
  // Award badge decoration
  static BoxDecoration badgeDecoration(Color color) {
    return BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.4),
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    );
  }
  
  // Animated button style when pressed
  static ButtonStyle animatedButtonStyle() {
    return ButtonStyle(
      animationDuration: Duration(milliseconds: 200),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return primaryLightMint;
        }
        return Colors.transparent;
      }),
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return primaryDarkMint;
        }
        return primaryMint;
      }),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      )),
      elevation: MaterialStateProperty.resolveWith<double>((states) {
        if (states.contains(MaterialState.pressed)) {
          return 1;
        }
        return 3;
      }),
    );
  }
}
