import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../Core/NavBar/navigation_bar.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  final showPassword = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final fullName = TextEditingController();
  final emailController = TextEditingController();
  final phoneNo = TextEditingController();
  final password = TextEditingController();
  final cpf = TextEditingController();

  final isLoading = false.obs;
  final isAdmin = false.obs;

  Future<void> createUser(String email) async {
    try {
      if (await recordExist(email)) {
        throw "O e-mail informado já possui um cadastro";
      } else {
        isLoading.value = true;

        if (!signupFormKey.currentState!.validate()) {
          isLoading.value = false;
          return;
        }

        final auth = AuthenticationRepository();

        await auth.registerWithEmailAndPassword(
          emailController.text.trim(),
          password.text.trim(),
        );

        await _firestore.collection('Users').doc(_auth.currentUser!.uid).set(
          {
            "id": _auth.currentUser!.uid,
            "E-mail": emailController.text.trim(),
            "Nome Completo": fullName.text.trim(),
            "Numero de Telefone": phoneNo.text.trim(),
            "CPF": cpf.text.trim(),
            "Admin": isAdmin.value = false,
          },
        ).catchError(
          (e) => log('Erro ao criar coleção: $e'),
        );

        auth.setInitialScreen(auth.firebaseUser);

        Get.to(() => const MyNavigationBar());
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Erro',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 10),
      );
      log(e.toString());
    }
  }

  Future<bool> recordExist(String email) async {
    try {
      final snapshot = await _db
          .collection("Users")
          .where(
            "E-mail",
            isEqualTo: email,
          )
          .get();

      return snapshot.docs.isEmpty ? false : true;
    } catch (e, s) {
      log('Error on find register', error: e, stackTrace: s);
      throw "Erro ao buscar registro.";
    }
  }
}
