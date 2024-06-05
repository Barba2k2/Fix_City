import 'package:flutter/material.dart';

import '../../model/chamados_model.dart';
import 'search_handler.dart';

class FilterButton extends StatelessWidget {
  final String category;
  final ValueChanged<List<ReportingModel>> onFiltered;

  const FilterButton({
    super.key,
    required this.category,
    required this.onFiltered,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final results = await SearchHandler().filterReportsByCategory(category);
        onFiltered(results);
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      child: Text(
        category,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
