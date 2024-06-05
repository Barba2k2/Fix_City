import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../CommomWidgets/Buttons/primary_button.dart';
import '../../../../Constants/colors.dart';
import '../../../../Controller/theme_controller.dart';
import '../../../Authentication/Models/user_model.dart';
import '../../Category/provider/firestore_provider.dart';
import '../Controller/user_controller.dart';
import '../Form/Screens/edit_report.dart';
import '../model/chamados_model.dart';

class ChamadosWidget extends StatefulWidget {
  const ChamadosWidget(this._reportingModel, {this.userModel, super.key});
  final ReportingModel _reportingModel;
  final UserModel? userModel;

  @override
  State<ChamadosWidget> createState() => _ChamadosWidgetState();
}

class _ChamadosWidgetState extends State<ChamadosWidget> {
  @override
  Widget build(BuildContext context) {
    bool isUnread = false;
    for (var obs in widget._reportingModel.observationsAdmin) {
      if (obs["ready"] == false) {
        isUnread = true;
        break;
      }
    }

    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    final UserController userController = Get.find();

    Future<bool> showExitDialog(BuildContext context) async {
      final completer = Completer<bool>();

      Get.defaultDialog(
        title: "CANCELAR",
        titleStyle: const TextStyle(fontSize: 20),
        content: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text("Tem certeza que gostaria\n de cancelar o chamado?"),
        ),
        confirm: MyPrimaryButton(
          isFullWidth: false,
          onPressed: () {
            FirestoreProvider.updateDocument(
              "Chamados",
              {"Status do chamado": "Cancelado"},
              documentId: widget._reportingModel.chamadoId,
            );
            Navigator.pop(context);
            completer.complete(true);
          },
          text: "Sim",
        ),
        cancel: SizedBox(
          width: 100,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              completer.complete(false);
            },
            child: const Text("Não"),
          ),
        ),
      );
      return completer.future;
    }

    return StreamBuilder<UserModel?>(
      stream: userController.userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        bool isAdmin = user?.isAdmin ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isDark ? tDarkCard : Colors.white70,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "#${widget._reportingModel.chamadoId}",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isUnread)
                              const Icon(
                                Icons.notifications,
                                color: Colors.red,
                                size: 20,
                              ),
                            const Gap(10),
                            if (widget._reportingModel.statusMessage ==
                                "Encerrado")
                              const Icon(
                                Icons.task_alt,
                                color: Colors.green,
                                size: 35.8,
                              )
                            else if (widget._reportingModel.statusMessage ==
                                "Em andamento")
                              const Icon(
                                Icons.rocket_launch,
                                color: Colors.orangeAccent,
                                size: 35.8,
                              )
                            else if (widget._reportingModel.statusMessage ==
                                "Enviado")
                              const Icon(
                                Icons.double_arrow_rounded,
                                color: Colors.blue,
                                size: 35.8,
                              )
                            else if (widget._reportingModel.statusMessage ==
                                "Cancelado")
                              const Icon(
                                Icons.cancel_presentation_rounded,
                                color: Colors.red,
                                size: 35.8,
                              ),
                          ],
                        ),
                        const Gap(5),
                        Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Text(
                                "Descrição: ",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget._reportingModel.description!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Text(
                                "Categoria: ",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget._reportingModel.category!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Text(
                                "Status: ",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget._reportingModel.statusMessage!,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Text(
                                "Data criado: ",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget._reportingModel.formattedDate,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Text(
                                "Data atualizada: ",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget._reportingModel.formattedDate,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        if (widget._reportingModel.statusMessage != "Cancelado")
                          if (widget._reportingModel.statusMessage !=
                              "Encerrado")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isAdmin)
                                  SizedBox(
                                    width: 140,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(5.0),
                                        // minimumSize: const Size(120, 30),
                                        elevation: 5,
                                      ),
                                      onPressed: () async {
                                        final documentData =
                                            await FirestoreProvider
                                                .getDocumentById(
                                          "Chamados",
                                          widget._reportingModel.chamadoId!,
                                        );
                                        Get.to(
                                          () => EditReportFormScreenNew(
                                            documentData: documentData,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Editar',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge
                                            ?.copyWith(
                                              fontSize: 20,
                                            ),
                                      ),
                                    ),
                                  ),
                                const Gap(40),
                                if (widget._reportingModel.statusMessage ==
                                    "Enviado")
                                  SizedBox(
                                    width: 140,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(5.0),
                                        // minimumSize: const Size(120, 30),
                                        elevation: 5,
                                      ),
                                      onPressed: () {
                                        showExitDialog(context);
                                      },
                                      child: Text(
                                        'Cancelar',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge
                                            ?.copyWith(
                                              fontSize: 20,
                                            ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
