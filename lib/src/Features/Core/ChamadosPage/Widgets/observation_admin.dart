import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StepWidget extends StatelessWidget {
  final String? status;
  final dynamic data;
  final String obs;

  const StepWidget({
    super.key,
    required this.status,
    required this.data,
    required this.obs,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> statusList = {
      "Enviado": const Icon(
        Icons.double_arrow_rounded,
        color: Colors.blue,
        size: 36,
      ),
      "Em andamento": const Icon(
        Icons.rocket_launch,
        color: Colors.orangeAccent,
        size: 36,
      ),
      "Encerrado": const Icon(
        Icons.task_alt,
        color: Colors.green,
        size: 36,
      ),
      "Cancelado": const Icon(
        Icons.cancel_presentation_rounded,
        color: Colors.red,
        size: 36,
      ),
    };

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            child: statusList[status],
          ),
          const Gap(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.toDate().toString()),
                Text(obs),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
