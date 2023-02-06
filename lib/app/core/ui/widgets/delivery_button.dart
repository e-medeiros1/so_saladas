// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:vakinha_burger/app/core/ui/styles/text_styles.dart';

class DeliveryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const DeliveryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
            backgroundColor:
                MaterialStateProperty.all(const Color(0xFF61d800))),
        onPressed: onPressed,
        child: Text(
          label,
          style: context.textStyles.textTitle.copyWith(fontSize: 18),
        ),
      ),
    );
  }
}
