import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputStatusMessage extends StatelessWidget {
  const InputStatusMessage({
    super.key,
    required this.statusMessage,
  });

  final TextEditingController statusMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status do Chamado',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(6),
        InputTextField(
          controller: statusMessage,
          keyBoardType: TextInputType.text,
          hintText: 'Atualize o status do chamado caso necessário',
          maxLines: 1,
          obscureText: false,
          onValidator: (value) {
            return null;
          },
        ),
      ],
    );
  }
}
