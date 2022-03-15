import 'package:flutter/material.dart';

class SocilLoginButton extends StatelessWidget {
  const SocilLoginButton({
    Key? key,
    required this.text,
    required this.color,
    this.textColor = Colors.white,
    this.edgeRadius = 12,
    this.height = 40,
    required this.buttonIcon,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Color color;
  final Color textColor;
  final double edgeRadius;
  final double height;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonIcon,
              Text(
                text,
                style: TextStyle(color: textColor),
              ),
              Opacity(
                child: buttonIcon,
                opacity: 0,
              )
            ],
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(edgeRadius))),
              backgroundColor: MaterialStateProperty.all(color)),
        ),
      ),
    );
  }
}
