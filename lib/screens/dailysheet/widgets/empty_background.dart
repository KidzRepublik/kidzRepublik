import 'package:flutter/material.dart';
import 'package:kids_republik/utils/const.dart';

class EmptyBackground extends StatelessWidget {
  final String title;
  const EmptyBackground({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: mQ.height * 0.05,
        ),
        Center(
          child: Image.asset(
            'assets/empty_2.png',
            height: mQ.height * 0.2,
            width: mQ.width * 0.9,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 17,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: kprimary.withOpacity(0.6),
            //fontSize: 16,
          ),
        ),
      ],
    );
  }
}
