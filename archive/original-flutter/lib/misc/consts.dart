import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KEltColor {
  KEltColor._();
  static const Color primary = Color(0xFF676FA3);
  static const Color background = Color(0xFFEEF2FF);
  static const Color txt = Color(0xFF1a1a1a);
  static const Color black = Color(0xFF191919);

  static const Color white = Color(0xFFFFFFFF);

  static const List<Color> flat = [
    Color(0xFFff4757),
    Color(0xFFffa502),
    Color(0xFFff7f50),
    Color(0xFF5352ed),
    Color(0xFF57606f),
    Color(0xFF2f3542)
  ];
}

class KEltDecoration {
  KEltDecoration._();
  static NeumorphicStyle boxDecoration = const NeumorphicStyle(
    depth: 6,
  );

  static NeumorphicStyle innerShadow = const NeumorphicStyle(
    shape: NeumorphicShape.concave,
    depth: -6,
  );
}

class KEltTextStyle {
  KEltTextStyle._();
  static TextStyle subtitleText = const TextStyle(color: KEltColor.txt);
  static TextStyle blackTitleText = TextStyle(
    color: KEltColor.txt,
    fontWeight: FontWeight.bold,
    fontSize: 20.sp,
  );
  static TextStyle whiteTitleText = TextStyle(
    color: KEltColor.white,
    fontWeight: FontWeight.bold,
    fontSize: 20.sp,
  );
  static TextStyle bold14black = TextStyle(
    color: KEltColor.txt,
    fontWeight: FontWeight.bold,
    fontSize: 14.sp,
  );
  static TextStyle normal14light = TextStyle(
    color: KEltColor.primary,
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
  );
}

class KEltInputDecoration {
  KEltInputDecoration._();
  static InputDecoration inputDecoration = const InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  );
}
