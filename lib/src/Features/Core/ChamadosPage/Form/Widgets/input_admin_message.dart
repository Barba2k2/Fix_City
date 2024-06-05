import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputAdminMessage extends StatelessWidget {
  const InputAdminMessage({super.key, required this.adminMessage});

  final TextEditingController adminMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mensagem para o usuário',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(6),
        InputTextField(
          controller: adminMessage,
          keyBoardType: TextInputType.text,
          hintText: 'Defina uma mensagem relevante ao chamado',
          maxLines: 1,
          obscureText: false,
          onValidator: (value) {
            return value.isBlank ? 'Insira um ponto de Referência' : null;
          },
        ),
      ],
    );
  }
}
