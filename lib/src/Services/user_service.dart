import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/colors.dart';
import '../Features/Authentication/Models/user_model.dart';

class UserService extends GetxController {
  static UserService get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection("Users").add(user.toJson());

      Get.snackbar(
        'Sucesso',
        'Sua conta foi criada',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: whiteColor,
      );
    } catch (error) {
      Get.snackbar(
        'Erro',
        'Algo saiu mal. Tente novamente mais tarde.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        backgroundColor: Colors.red,
      );

      log('Erro ao criar usuário: $error');
    }
  }
}
