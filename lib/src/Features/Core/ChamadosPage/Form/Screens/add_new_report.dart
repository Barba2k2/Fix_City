import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../../../Constants/colors.dart';
import '../../../../../Controller/theme_controller.dart';
import '../../../../../Services/storage_service.dart';
import '../../../Category/models/category.dart';
import '../../../Category/provider/firestore_provider.dart';
import '../../Controller/chamados_controller.dart';
import '../../Widgets/full_screen_image.dart';
import '../../Widgets/full_screen_video_player.dart';
import '../Widgets/input_address.dart';
import '../Widgets/input_description.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({Key? key}) : super(key: key);

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final address = TextEditingController();
  final cep = TextEditingController();
  final referPoint = TextEditingController();
  final addressNumber = TextEditingController();
  final description = TextEditingController();
  final definicaoCategoria = TextEditingController();
  final messageString = TextEditingController();
  final latitudeReport = TextEditingController();
  final longitudeReport = TextEditingController();
  late Map<String, dynamic> locationReport;

  String _selectedCategory = '';
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    FirestoreProvider.getCategoriesStream().listen(
      (categories) {
        setState(
          () {
            _categories = categories;
            if (_categories.isNotEmpty) {
              _selectedCategory = _categories[0].name;
            }
          },
        );
      },
    );
  }

  StorageService service = StorageService();
  String? imageUrl;
  String? videoUrl;

  PlatformFile? selectedImageFile;
  PlatformFile? selectedVideoFile;

  late VideoPlayerController _videoController;

  bool submitData() {
    if (description.text.trim().isEmpty || address.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: const Text(
            'Por favor, verifique se os dados foram preenchidos.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return false;
    }

    if (selectedImageFile == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Arquivo Obrigatório'),
          content: const Text(
            'Por favor, envie pelo menos uma imagem.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _getImageFromCamera() async {
    log('Iniciando _getImageFromCamera...');
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      setState(() {
        selectedImageFile = PlatformFile(
          name: pickedFile.name,
          path: pickedFile.path,
          size: file.lengthSync(),
          bytes: file.readAsBytesSync(),
        );
      });
    } else {
      Get.snackbar(
        'Ação Cancelada',
        'Você não tirou nenhuma foto ou vídeo.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> _getVideoFromCamera() async {
    log('Iniciando _getVideoFromCamera...');
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        log('Vídeo selecionado: ${pickedFile.path}');
        File file = File(pickedFile.path);
        setState(() {
          selectedVideoFile = PlatformFile(
            name: pickedFile.name,
            path: pickedFile.path,
            size: file.lengthSync(),
            bytes: file.readAsBytesSync(),
          );

          _videoController = VideoPlayerController.file(
            File(selectedVideoFile!.path!),
          )..initialize();
        });
      } else {
        log('Ação cancelada. Nenhum vídeo foi gravado.');
        Get.snackbar(
          'Ação Cancelada',
          'Você não gravou nenhum vídeo.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      log('Erro ao tentar gravar vídeo: $e');
      Get.snackbar(
        'Erro',
        'Falha ao tentar gravar vídeo: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> _getImageFromGallery() async {
    log('Iniciando _getImageFromGallery...');
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        selectedImageFile = result.files.first;
      });
      log('Imagem selecionada da galeria: ${selectedImageFile?.path}');
    } else {
      Get.snackbar(
        'Ação Cancelada',
        'Você não selecionou nenhuma foto.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  Future<void> pickImage() async {
    log('Iniciando _pickImage...');
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolha uma opção'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.camera),
              title: const Text('Câmera'),
              onTap: () {
                log('Opção Câmera selecionada.');
                _getImageFromCamera();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.photo),
              title: const Text('Galeria'),
              onTap: () {
                log('Opção Galeria selecionada.');
                _getImageFromGallery();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickVideo() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolha uma opção'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.camera),
              title: const Text('Câmera'),
              onTap: () {
                _getVideoFromCamera();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.photo),
              title: const Text('Galeria'),
              onTap: () {
                _getImageFromGallery();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novo Chamado',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        backgroundColor: isDark ? tDarkColor : whiteColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: isDark ? tDarkColor : Colors.grey.withOpacity(.1),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputDescription(description: description),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecione a categoria:',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Gap(6),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    items: _categories.map((Category category) {
                      return DropdownMenuItem<String>(
                        value: category.name,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  )
                ],
              ),
              Column(
                children: [
                  InputAddress(
                    address: address,
                    addressNumber: addressNumber,
                    cep: cep,
                    referPoint: referPoint,
                    longitudeReport: longitudeReport,
                    latitudeReport: latitudeReport,
                  ),
                  const Gap(20),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Arquivos:',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: pickImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(CupertinoIcons.camera_fill),
                              Text(
                                'Enviar Foto',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      color: tPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: pickVideo,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                CupertinoIcons.videocam_fill,
                                color: isDark ? blackColor : whiteColor,
                              ),
                              Text(
                                'Enviar Vídeo',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      color: isDark ? blackColor : whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const Gap(5),
                  Row(
                    children: [
                      if (selectedImageFile != null ||
                          selectedImageFile?.path != null)
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => FullScreenImage(
                                imagePath: selectedImageFile!.path!,
                              ),
                            );
                          },
                          child: Image.file(
                            File(selectedImageFile!.path!),
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  'Erro ao carregar a imagem.',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                              );
                            },
                          ),
                        ),
                      const Gap(20),
                      if (selectedVideoFile != null ||
                          selectedVideoFile?.path != null)
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => FullScreenVideoPlayer(
                                videoPath: selectedVideoFile!.path!,
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 200,
                            width: 140,
                            child: AspectRatio(
                              aspectRatio: _videoController.value.playbackSpeed,
                              child: VideoPlayer(_videoController),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const Gap(20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancelar',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: tPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (submitData()) {
                          await ReportController().addNewReport(
                            address.text.trim(),
                            cep.text.trim(),
                            referPoint.text.trim(),
                            addressNumber.text.trim(),
                            description.text.trim(),
                            _selectedCategory,
                            definicaoCategoria.text.trim(),
                            double.tryParse(longitudeReport.text),
                            double.tryParse(latitudeReport.text),
                            imageFile: selectedImageFile!,
                            videoFile: selectedVideoFile,
                            isDone: false,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Enviar',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: isDark ? blackColor : whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
