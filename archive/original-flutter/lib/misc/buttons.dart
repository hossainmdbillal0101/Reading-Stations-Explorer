import 'package:explorer/misc/consts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String title;

  const CustomButton({Key? key, this.onTap, required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: onTap,
      child: Center(
        child: Text(
          title,
          style: KEltTextStyle.subtitleText,
        ),
      ),
    );
  }
}
