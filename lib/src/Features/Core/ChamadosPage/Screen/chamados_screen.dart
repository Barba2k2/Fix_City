import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Constants/colors.dart';
import '../../../../Controller/theme_controller.dart';
import '../../../Authentication/Models/user_model.dart';
import '../../Category/provider/fireauth_provider.dart';
import '../Controller/user_controller.dart';
import '../Widgets/chamados_page_body_header.dart';
import '../model/chamados_model.dart';
import 'list_chamados_screen.dart';

class ChamadosScreen extends StatefulWidget {
  const ChamadosScreen({this.userModel, this.reportingModel, super.key});
  final ReportingModel? reportingModel;
  final UserModel? userModel;

  @override
  State<ChamadosScreen> createState() => _ChamadosScreenState();
}

class _ChamadosScreenState extends State<ChamadosScreen> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final ThemeController themeController = Get.find();

    DateTime currentDate = DateTime.now();
    final day = currentDate.day.toString().padLeft(2, '0');
    final month = currentDate.month;
    final year = currentDate.year;
    String formattedDate = "$day/$month/$year";
    User? usuarioLogado = FireauthProvider.getCurrentUser();

    if (usuarioLogado != null) {
      log('Usuário logado: ${usuarioLogado.email}');
    } else {
      log('Nenhum usuário logado.');
    }

    return Obx(
      () {
        final isDark = themeController.isDarkMode.value;

        return SafeArea(
          child: Scaffold(
            key: ValueKey(Get.isDarkMode),
            backgroundColor: isDark ? tDarkColor : Colors.grey.shade200,
            appBar: AppBar(
              backgroundColor: isDark ? tDarkColor : whiteColor,
              foregroundColor: isDark ? Colors.black : whiteColor,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: StreamBuilder<UserModel?>(
                stream: userController.userStream,
                builder: (context, snapshot) {
                  final user = snapshot.data;

                  if (user == null) {
                    return const Text('Nome de usuário não disponivel');
                  } else {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber.shade400,
                        radius: 25,
                        child: Image.asset('assets/images/avatar.png'),
                      ),
                      title: Text(
                        'Olá, Bem-Vindo!',
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    );
                  }
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.calendar,
                          color: isDark ? tWhiteColor : tDarkColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.bell,
                          color: isDark ? tWhiteColor : tDarkColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Gap(20),
                  ChamadosPageBodyHeader(formattedDate: formattedDate),
                  const Gap(20),
                  Expanded(
                    child: StreamBuilder<UserModel?>(
                      stream: userController.userStream,
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                        bool isAdmin = user?.isAdmin ?? false;

                        return isAdmin
                            ? AdminChamadosNew(
                                widget: widget,
                              )
                            : AdminChamadosNew(
                                widget: widget,
                                usuarioLogado: user?.id,
                              );
                      },
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
