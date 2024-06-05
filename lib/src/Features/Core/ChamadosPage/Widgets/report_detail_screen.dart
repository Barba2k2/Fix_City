import 'dart:developer';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Constants/colors.dart';
import '../../../../Controller/theme_controller.dart';
import '../../Category/provider/firestore_provider.dart';
import '../Controller/chamados_controller.dart';
import '../model/chamados_model.dart';
import 'full_screen_image.dart';
import 'full_screen_video_player.dart';
import 'observation_admin.dart';
import 'video_player.dart';

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key, required this.reportingModel});
  final ReportingModel reportingModel;

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final ReportController reportController = Get.find();
  final String emptyVideo = 'vídeo não disponível';
  String? imageUrls;
  String? videoUrls;

  @override
  void initState() {
    super.initState();
    _loadMedia();
    _markCommentsAsRead();
  }

  void _loadMedia() async {
    imageUrls = await reportController.getChamadoImage(
      widget.reportingModel.chamadoId!,
      widget.reportingModel.userId!,
    );
    log('Imagens recuperadas: $imageUrls');

    videoUrls = await reportController.getChamadoVideo(
      widget.reportingModel.chamadoId!,
      widget.reportingModel.userId!,
    );
    log('Vídeos recuperados: $videoUrls');

    setState(() {});
  }

  void _markCommentsAsRead() {
    List<dynamic> updatedList =
        widget.reportingModel.observationsAdmin.map((item) {
      item['ready'] = true;
      return item;
    }).toList();

    FirestoreProvider.updateDocument(
      "Chamados",
      {"observations_admin": updatedList},
      documentId: widget.reportingModel.chamadoId,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> listObs = widget.reportingModel.observationsAdmin as List;

    final ThemeController themeController = Get.find();
    List<String> statusMessageList = [
      "Enviado",
      "Em andamento",
      "Encerrado",
      "Cancelado"
    ];
    dynamic activeStep = statusMessageList.indexOf(
      widget.reportingModel.statusMessage.toString(),
    );
    final isDark = themeController.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalhes do Chamado",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        backgroundColor: isDark ? tDarkColor : whiteColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  EasyStepper(
                    activeStep: activeStep,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    internalPadding: 0,
                    activeStepTextColor: Colors.green,
                    activeStepBackgroundColor: Colors.green,
                    activeStepIconColor: Colors.green,
                    finishedStepTextColor: Colors.black,
                    finishedStepBackgroundColor: Colors.green,
                    disableScroll: true,
                    showLoadingAnimation: false,
                    stepRadius: 16,
                    lineStyle: const LineStyle(
                      lineLength: 70,
                      lineType: LineType.normal,
                      defaultLineColor: Colors.grey,
                      finishedLineColor: Colors.green,
                    ),
                    steps: List.generate(
                      statusMessageList.length,
                      (index) => EasyStep(
                        customStep: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.green,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: activeStep >= index
                                ? activeStep == statusMessageList.length
                                    ? Colors.red
                                    : Colors.green
                                : Colors.grey,
                          ),
                        ),
                        title: statusMessageList[index],
                      ),
                    ),
                  ),
                  const Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Data do Chamado:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.reportingModel.formattedDate,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              _buildDetailRow(
                context,
                "Endereço:",
                widget.reportingModel.address,
              ),
              const Gap(12),
              _buildDetailRow(
                context,
                "Número do Endereço:",
                widget.reportingModel.addressNumber,
              ),
              const Gap(12),
              _buildDetailRow(
                context,
                "CEP:",
                widget.reportingModel.cep,
              ),
              const Gap(12),
              _buildDetailRow(
                context,
                "Ponto de Referência:",
                widget.reportingModel.referPoint,
              ),
              const Gap(12),
              _buildDetailRow(
                context,
                "Descrição:",
                widget.reportingModel.description,
              ),
              const Gap(12),
              _buildDetailRow(
                context,
                "Categoria:",
                widget.reportingModel.category,
              ),
              if (widget.reportingModel.category == 'Outro') ...[
                const Gap(12),
                _buildDetailRow(
                  context,
                  "Descrição da Categoria:",
                  widget.reportingModel.definicaoCategoria,
                ),
              ],
              const Gap(12),
              _buildDetailRow(
                context,
                "Status do Chamado:",
                widget.reportingModel.statusMessage,
              ),
              const Gap(12),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Imagem/Vídeo do Chamado:',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: videoUrls != emptyVideo
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.center,
                        children: [
                          if (imageUrls != null && imageUrls!.isNotEmpty)
                            Expanded(
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => FullScreenImage(
                                        imageUrl: imageUrls!,
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    imageUrls!,
                                    fit: BoxFit.cover,
                                    height: 300,
                                    width: 150,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          'Erro ao carregar a imagem.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          (videoUrls != emptyVideo)
                              ? Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => FullScreenVideoPlayer(
                                          videoUrl: videoUrls!,
                                        ),
                                      );
                                    },
                                    child: VideoPlayerWidget(
                                      videoUrl: videoUrls ?? '',
                                      height: 300,
                                      width: 150,
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Center(
                                    child: Text(
                                      'Vídeo não disponível',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(20),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Observações do admin:',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ],
              ),
              listObs[0].length != 1
                  ? Column(
                      children: List.generate(
                        listObs.length,
                        (index) => StepWidget(
                          obs: listObs[index]["observation"],
                          data: listObs[index]["data"],
                          status: listObs[index]["status"],
                        ),
                      ),
                    )
                  : const Text(
                      "Sem observações",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String? value) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        const Gap(6),
        Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? blackContainer : whiteContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value ?? '',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    );
  }
}
