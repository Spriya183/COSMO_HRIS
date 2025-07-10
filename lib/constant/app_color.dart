import 'package:flutter/material.dart';

class ColorPalette {
  static MaterialColor brand = MaterialColorPalette.brand;
  static MaterialColor brand2 = MaterialColorPalette.brand2;
  static MaterialColor red = MaterialColorPalette.red;
  static MaterialColor neutral = MaterialColorPalette.neutral;
  static MaterialColor orange = MaterialColorPalette.orange;
  static MaterialColor amber = MaterialColorPalette.amber;
  static MaterialColor green = MaterialColorPalette.green;
  static MaterialColor emerald = MaterialColorPalette.emerald;
  static MaterialColor teal = MaterialColorPalette.teal;
  static MaterialColor sky = MaterialColorPalette.sky;
  static MaterialColor indigo = MaterialColorPalette.indigo;
  static MaterialColor violet = MaterialColorPalette.violet;
  static MaterialColor fuchsia = MaterialColorPalette.fuchsia;
  static MaterialColor rose = MaterialColorPalette.rose;
  static MaterialColor slate = MaterialColorPalette.slate;
  static MaterialColor zinc = MaterialColorPalette.zinc;
  static MaterialColor blue = MaterialColorPalette.blue;
  static MaterialColor white = MaterialColorPalette.white;
  static MaterialColor sherpa_blue = MaterialColorPalette.sherpa_blue;
  static MaterialColor daintree = MaterialColorPalette.daintree;
  static MaterialColor indian_tan = MaterialColorPalette.indian_tan;
}

class AppColor {
  static const Color appThemeColor = Color(0xFF034F9E);
  static const Color successColor = Color(0xFF2E7D32);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color greyColor = Colors.grey;
  static const Color redLightColor = Color(0xffef5350);
  static const Color redColor = Colors.red;
  static const Color pageBodyColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color spalshScreenBGColor = Color(0xFF98B9FE);
  static const Color pageBackgroundColor = Color(0xFFE2F3FF);
}

class MaterialColorPalette {
  static MaterialColor white = const MaterialColor(
    0xFFFFFFFF, // Base color (using the 500 value as primary)
    <int, Color>{500: Color(0xFFFFFFFF)},
  );
  static MaterialColor brand = const MaterialColor(
    0xFF8644D4, // Base color (using the 500 value as primary)
    <int, Color>{
      50: Color(0xFFE7DAF6),
      100: Color(0xFFD7C1F1),
      200: Color(0xFFC2A1E9),
      300: Color(0xFFAE82E2),
      400: Color(0xFF9A63DB),
      500: Color(0xFF8644D4),
      600: Color(0xFF7039B1),
      700: Color(0xFF592D8D),
      800: Color(0xFF43226A),
      900: Color(0xFF2D1747),
      950: Color(0xFF1B0E2A),
    },
  );
  static MaterialColor brand2 = const MaterialColor(
    0xFF538BFD, // Base color (using the 500 value as primary)
    <int, Color>{
      50: Color(0xFFD6E3FF),
      100: Color(0xFFBAD1FE),
      200: Color(0xFF98B9FE),
      300: Color(0xFF76A2FE),
      400: Color(0xFF538BFD),
      500: Color(0xFF3174FD),
      600: Color(0xFF2961D3),
      700: Color(0xFF214DA9),
      800: Color(0xFF193A7F),
      900: Color(0xFF102754),
      950: Color(0xFF0A1733),
    },
  );

  static const MaterialColor slate = MaterialColor(
    0xFF64748B, // Base color (using the 600 value as primary)
    <int, Color>{
      50: Color(0xFFF8FAFC),
      100: Color(0xFFF1F5F9),
      200: Color(0xFFE2E8F0),
      300: Color(0xFFCBD5E1),
      400: Color(0xFF94A3B8),
      500: Color(0xFF64748B),
      600: Color(0xFF475569),
      700: Color(0xFF334155),
      800: Color(0xFF1E293B),
      900: Color(0xFF0F172A),
      950: Color(0xFF020617),
    },
  );

  static MaterialColor blue = const MaterialColor(
    0xFF2196F3, // Base blue color
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF2196F3),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
      950: Color(0xFF08357A), // Darker shade for 950
    },
  );

  static MaterialColor zinc = const MaterialColor(
    0xFF4B4F54, // Base color
    <int, Color>{
      50: Color(0xFFE3E6E7),
      100: Color(0xFFBCC0C2),
      200: Color(0xFF979C9F),
      300: Color(0xFF72777A),
      400: Color(0xFF565C5F),
      500: Color(0xFF4B4F54),
      600: Color(0xFF404548),
      700: Color(0xFF343C3F),
      800: Color(0xFF2A3033),
      900: Color(0xFF1F2527),
      950: Color(0xFF141A1D), // Darkest shade
    },
  );

  static MaterialColor red = const MaterialColor(0xFFEF4444, <int, Color>{
    50: Color(0xFFFEE2E2),
    100: Color(0xFFFECACA),
    200: Color(0xFFFCA5A5),
    300: Color(0xFFF87171),
    400: Color(0xFFEF4444),
    500: Color(0xFFDC2626),
    600: Color(0xFFB91C1C),
    700: Color(0xFF991B1B),
    800: Color(0xFF7F1D1D),
    900: Color(0xFF4C0D0D),
    950: Color(0xFF330808),
  });

  static MaterialColor neutral = const MaterialColor(0xFF737373, <int, Color>{
    50: Color(0xFFF5F5F5),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFD4D4D4),
    300: Color(0xFFA3A3A3),
    400: Color(0xFF737373),
    500: Color(0xFF737373),
    600: Color(0xFF404040),
    700: Color(0xFF262626),
    800: Color(0xFF262626),
    900: Color(0xFF0A0A0A),
    950: Color(0xFF050505),
  });

  static MaterialColor orange = const MaterialColor(0xFFF97316, <int, Color>{
    50: Color(0xFFFFEDD5),
    100: Color(0xFFFED7AA),
    200: Color(0xFFFDBA74),
    300: Color(0xFFFB923C),
    400: Color(0xFFF97316),
    500: Color(0xFFEA580C),
    600: Color(0xFFC2410C),
    700: Color(0xFF9A3412),
    800: Color(0xFF7C2D12),
    900: Color(0xFF4B1D0E),
    950: Color(0xFF311407),
  });

  static MaterialColor amber = const MaterialColor(0xFFF59E0B, <int, Color>{
    50: Color(0xFFFEF3C7),
    100: Color(0xFFFDE68A),
    200: Color(0xFFFCD34D),
    300: Color(0xFFFBBF24),
    400: Color(0xFFF59E0B),
    500: Color(0xFFD97706),
    600: Color(0xFFB45309),
    700: Color(0xFF92400E),
    800: Color(0xFF78350F),
    900: Color(0xFF451A03),
    950: Color(0xFF2E1101),
  });

  static MaterialColor green = const MaterialColor(0xFF34C759, <int, Color>{
    50: Color(0xFFD1FAE5),
    100: Color(0xFFA7F3D0),
    200: Color(0xFF6EE7B7),
    300: Color(0xFF34D399),
    400: Color(0xFF10B981),
    500: Color(0xFF34C759),
    600: Color(0xFF047857),
    700: Color(0xFF065F46),
    800: Color(0xFF064E3B),
    900: Color(0xFF022C22),
    950: Color(0xFF011711),
  });

  static MaterialColor emerald = const MaterialColor(0xFF059669, <int, Color>{
    50: Color(0xFFD1FAE5),
    100: Color(0xFFA7F3D0),
    200: Color(0xFF6EE7B7),
    300: Color(0xFF34D399),
    400: Color(0xFF10B981),
    500: Color(0xFF059669),
    600: Color(0xFF047857),
    700: Color(0xFF065F46),
    800: Color(0xFF064E3B),
    900: Color(0xFF022C22),
    950: Color(0xFF011711),
  });

  static MaterialColor teal = const MaterialColor(0xFF14B8A6, <int, Color>{
    50: Color(0xFFCCFBF1),
    100: Color(0xFF99F6E4),
    200: Color(0xFF5EEAD4),
    300: Color(0xFF2DD4BF),
    400: Color(0xFF14B8A6),
    500: Color(0xFF0D9488),
    600: Color(0xFF0F766E),
    700: Color(0xFF115E59),
    800: Color(0xFF134E4A),
    900: Color(0xFF083D36),
    950: Color(0xFF052B26),
  });

  static MaterialColor sky = const MaterialColor(0xFF0EA5E9, <int, Color>{
    50: Color(0xFFE0F2FE),
    100: Color(0xFFBAE6FD),
    200: Color(0xFF7DD3FC),
    300: Color(0xFF38BDF8),
    400: Color(0xFF0EA5E9),
    500: Color(0xFF0284C7),
    600: Color(0xFF0369A1),
    700: Color(0xFF075985),
    800: Color(0xFF0C4A6E),
    900: Color(0xFF082F49),
    950: Color(0xFF051D34),
  });

  static MaterialColor indigo = const MaterialColor(0xFF6366F1, <int, Color>{
    50: Color(0xFFE0E7FF),
    100: Color(0xFFC7D2FE),
    200: Color(0xFFA5B4FC),
    300: Color(0xFF818CF8),
    400: Color(0xFF6366F1),
    500: Color(0xFF4F46E5),
    600: Color(0xFF4338CA),
    700: Color(0xFF3730A3),
    800: Color(0xFF312E81),
    900: Color(0xFF1E1B4B),
    950: Color(0xFF111027),
  });

  static MaterialColor violet = const MaterialColor(0xFF8B5CF6, <int, Color>{
    50: Color(0xFFF5F3FF),
    100: Color(0xFFEDE9FE),
    200: Color(0xFFDDD6FE),
    300: Color(0xFFC4B5FD),
    400: Color(0xFFA78BFA),
    500: Color(0xFF8B5CF6),
    600: Color(0xFF7C3AED),
    700: Color(0xFF6D28D9),
    800: Color(0xFF5B21B6),
    900: Color(0xFF3F1C9E),
    950: Color(0xFF2B145E),
  });

  static MaterialColor fuchsia = const MaterialColor(0xFFD946EF, <int, Color>{
    50: Color(0xFFFDF4FF),
    100: Color(0xFFFAE8FF),
    200: Color(0xFFF5D0FE),
    300: Color(0xFFF0ABFC),
    400: Color(0xFFE879F9),
    500: Color(0xFFD946EF),
    600: Color(0xFFC026D3),
    700: Color(0xFFA21CAF),
    800: Color(0xFF86198F),
    900: Color(0xFF701A75),
    950: Color(0xFF4A0C4A),
  });

  static MaterialColor rose = const MaterialColor(0xFFF43F5E, <int, Color>{
    50: Color(0xFFFFF1F2),
    100: Color(0xFFFFE4E6),
    200: Color(0xFFFECDD3),
    300: Color(0xFFFDA4AF),
    400: Color(0xFFF87171),
    500: Color(0xFFF43F5E),
    600: Color(0xFFE11D48),
    700: Color(0xFFBE123C),
    800: Color(0xFF9F1239),
    900: Color(0xFF881337),
    950: Color(0xFF4E081C),
  });

  static MaterialColor sherpa_blue =
      const MaterialColor(0xFF004358, <int, Color>{
        50: Color(0xFFccd9de),
        100: Color(0xFFb3c7cd),
        200: Color(0xFF80a1ac),
        300: Color(0xFF668e9b),
        400: Color(0xFF4d7b8a),
        500: Color(0xFF336979),
        600: Color(0xFF1a5669),
        700: Color(0xFF004358),
        800: Color(0xFF003c4f),
        900: Color(0xFF003646),
        950: Color(0xFF002f3e),
      });

  static MaterialColor daintree = const MaterialColor(0xFF004358, <int, Color>{
    50: Color(0xFFccd9de),
    100: Color(0xFFE2F3FF),
    200: Color(0xFF8ED8FF),
    300: Color(0xFF00B5E8),
    400: Color(0xFF008DB5),
    500: Color(0xFF006785),
    600: Color(0xFF004358),
    700: Color(0xFF00222F),
    // 800: Color(0xFF003c4f),
    // 900: Color(0xFF003646),
    // 950: Color(0xFF002f3e),
  });

  static MaterialColor indian_tan = const MaterialColor(
    0xFF581500,
    <int, Color>{
      50: Color(0xFFccd9de),
      100: Color(0xFFFFD9D6),
      200: Color(0xFFFFA296),
      300: Color(0xFFFF5E37),
      400: Color(0xFFCB3D00),
      500: Color(0xFF8F2800),
      600: Color(0xFF581500),
      700: Color(0xFF270500),
      // 800: Color(0xFF003c4f),
      // 900: Color(0xFF003646),
      // 950: Color(0xFF002f3e),
    },
  );
}
