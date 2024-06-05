import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputName extends StatelessWidget {
  const InputName({
    super.key,
    required this.name,
  });

  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(6),
        InputTextField(
          controller: name,
          keyBoardType: TextInputType.text,
          hintText: 'Nome Completo',
          maxLines: 1,
          obscureText: false,
          onValidator: (value) {
            return value.isBlank ? 'Insira seu nome' : null;
          },
        ),
      ],
    );
  }
}
