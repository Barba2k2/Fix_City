import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputDescription extends StatelessWidget {
  const InputDescription({
    super.key,
    required this.description,
  });

  final TextEditingController description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrição',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(6),
        InputTextField(
          controller: description,
          keyBoardType: TextInputType.text,
          hintText: 'Descrição do incidente',
          maxLines: 5,
          maxLength: 500,
          obscureText: false,
          onValidator: (value) {
            return value.isBlank ? 'Insira uma descrição' : null;
          },
        ),
      ],
    );
  }
}
