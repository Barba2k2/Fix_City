import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../Constants/colors.dart';

class ButtonLoadingWidget extends StatelessWidget {
  const ButtonLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(color: tWhiteColor),
        ),
        Gap(10),
        Text('Carregando...'),
      ],
    );
  }
}
