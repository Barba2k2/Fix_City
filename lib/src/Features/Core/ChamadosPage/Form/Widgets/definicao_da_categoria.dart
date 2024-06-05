import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../Utils/Widgets/input_text_field.dart';

class DefinicaoCategoria extends StatelessWidget {
  final TextEditingController categoryController;

  const DefinicaoCategoria({
    super.key,
    required this.categoryController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Defina a categoria',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Gap(6),
        InputTextField(
          controller: categoryController,
          keyBoardType: TextInputType.text,
          hintText: 'Defina a Categoria',
          maxLines: 1,
          obscureText: false,
          onValidator: (value) {
            return value.isBlank ? 'Insira uma categoria' : null;
          },
        ),
      ],
    );
  }
}
