import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DisplayMessageDropdown extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const DisplayMessageDropdown(
    this.initialValue,
    this.onChanged, {
    super.key,
  });

  @override
  State<DisplayMessageDropdown> createState() => _DisplayMessageDropdownState();
}

class _DisplayMessageDropdownState extends State<DisplayMessageDropdown> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue ? 'Sim' : 'Não';
    log('Valor selecionado: $_selectedValue');
  }

  void _handleDropdownChanged(String? newValue) {
    log('Dropdown changed: $newValue');
    if (newValue != null) {
      setState(() {
        _selectedValue = newValue;
      });

      widget.onChanged(newValue == 'Sim');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Exibir mensagem: ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            DropdownButton<String>(
              value: _selectedValue,
              items: <String>['Sim', 'Não'].map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              onChanged: _handleDropdownChanged,
            ),
          ],
        ),
      ],
    );
  }
}
