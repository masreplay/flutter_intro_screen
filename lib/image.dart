import 'package:flutter/material.dart';

class IntroAssetsImage extends StatelessWidget {
  final String path;
  final BorderRadius? borderRadius;

  const IntroAssetsImage({
    Key? key,
    required this.path,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: Image.asset(
        path,
        fit: BoxFit.cover,
        alignment: Alignment.centerRight,
      ),
    );
  }
}
