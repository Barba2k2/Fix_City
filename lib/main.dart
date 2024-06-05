import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
//* Classes importadas
import 'src/Repository/AuthenticationRepository/authentication_repository.dart';
import 'firebase_options.dart';
import 'src/app.dart';

void main() async {
  // Garante a inicialização do binding de widgets do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as opções padrão para a plataforma atual e coloca o `AuthenticationRepository` no GetX para gerenciamento de estado
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (_) => Get.put(
      AuthenticationRepository(),
    ),
  );

  // Carrega variáveis de ambiente usando FlutterConfig
  await FlutterConfig.loadEnvVariables();

  // Cria o usuário administrador, se não existir
  await createUserAdmin();

  // Configura um manipulador global de erros para registrar exceções no Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    log(details.exception.toString());
    log(details.stack.toString());
  };

  // Inicia o aplicativo
  runApp(MyApp());
}

Future<void> createUserAdmin() async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var emailAdmin = 'admin@admin.com';
  var senhaAdmin = 'Admin@123';

  // Instância do repositório de autenticação.
  final auth = AuthenticationRepository();

  try {
    // Verifica se o usuário administrador já existe
    final userSnapshot = await firestore
        .collection('Users')
        .where('E-mail', isEqualTo: emailAdmin)
        .get();

    if (userSnapshot.docs.isEmpty) {
      // Cria o usuário administrador se não existir
      await auth.registerWithEmailAndPassword(emailAdmin, senhaAdmin);

      if (firebaseAuth.currentUser != null) {
        await firestore
            .collection('Users')
            .doc(firebaseAuth.currentUser!.uid)
            .set(
          {
            "id": firebaseAuth.currentUser!.uid,
            "E-mail": emailAdmin,
            "Nome Completo": 'admin',
            "Numero de Telefone": '',
            "CPF": '',
            "Admin": true,
          },
        );
        await firebaseAuth.signOut();
        log("== User admin not exist, created");
      }
    } else {
      log("== User admin already exists");
    }
  } catch (e) {
    log("Erro ao criar usuário admin: $e");
  }
}
