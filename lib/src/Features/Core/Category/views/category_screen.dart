import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Constants/colors.dart';
import '../../../../Controller/theme_controller.dart';
import '../../../Authentication/Models/user_model.dart';
import '../../ChamadosPage/Controller/user_controller.dart';
import '../components/category_header.dart';
import '../components/category_title.dart';
import '../models/category.dart';
import '../provider/firestore_provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final ThemeController themeController = Get.find();

    DateTime currentDate = DateTime.now();
    final day = currentDate.day.toString().padLeft(2, '0');
    final month = currentDate.month;
    final year = currentDate.year;
    String formattedDate = "$day/$month/$year";

    return Obx(
      () {
        final isDark = themeController.isDarkMode.value;

        return SafeArea(
          child: Scaffold(
            key: ValueKey(Get.isDarkMode),
            backgroundColor: isDark ? tDarkColor : Colors.grey.shade200,
            appBar: AppBar(
              backgroundColor: isDark ? tDarkColor : whiteColor,
              foregroundColor: isDark ? blackColor : whiteColor,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: StreamBuilder<UserModel?>(
                stream: userController.userStream,
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  if (user == null) {
                    return const Text('Nome de usuário não disponível');
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
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Gap(20),
                  CategoryHeader(formattedDate: formattedDate),
                  const Gap(20),
                  Expanded(
                    child: StreamBuilder<List<Category>>(
                      stream: FirestoreProvider.getCategoriesStream(),
                      builder: (
                        context,
                        AsyncSnapshot<List<Category>> snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Erro ao carregar dados: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('Nenhuma categoria encontrada.'),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (ctx, i) => CategoryTile(
                            snapshot.data![i],
                          ),
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
