import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/chamados_model.dart';
import '../model/generate_report_id.dart';

class ReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser;

  static const usersCollection = 'Users';
  static const chamadosCollection = 'Chamados';

  String buildFilePath(
    String baseFolder,
    String userName,
    String fileName,
    int chamadoNumber,
  ) {
    final chamadoFolder = 'Chamado${chamadoNumber.toString().padLeft(3, '0')}';
    return '$baseFolder/$userName/$chamadoFolder/$fileName';
  }

  Future<String?> uploadFile(String fileName, String filePath) async {
    if (filePath.isEmpty) {
      return null;
    }

    File file = File(filePath);

    try {
      final ref = _firebaseStorage.ref().child('path_to_save/$fileName');
      await ref.putFile(file);

      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      Get.snackbar('Erro', 'Erro ao fazer o upload do arquivo.');
      return null;
    }
  }

  Future<Map<String, String?>> uploadFilesAndSaveReport(
    PlatformFile imageFile,
    PlatformFile? videoFile,
    String userName,
  ) async {
    try {
      final chamadoNumber = await getChamadoNumberForUser(userName);

      final imagePath = buildFilePath(
        'Chamados',
        userName,
        imageFile.name,
        chamadoNumber,
      );
      final videoPath = videoFile != null
          ? buildFilePath(
              'Chamados',
              userName,
              videoFile.name,
              chamadoNumber,
            )
          : null;

      final imageUrl = await uploadFile(imagePath, imageFile.path!);
      final videoUrl = videoFile != null
          ? await uploadFile(videoPath!, videoFile.path!)
          : null;

      if (imageUrl == null) {
        throw Exception("Erro ao fazer upload da imagem.");
      }

      return {
        'imagemChamado': imageUrl,
        'videoChamado': videoUrl,
      };
    } catch (e) {
      log('Erro ao fazer upload dos arquivos: $e');
      Get.snackbar('Erro', 'Erro ao fazer upload dos arquivos selecionados.');
      rethrow;
    }
  }

  Future<String?> getUserName(String userId) async {
    DocumentSnapshot userDoc =
        await _firestore.collection(usersCollection).doc(userId).get();

    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    if (userData != null && userData.containsKey('Nome Completo')) {
      return userData['Nome Completo'];
    }

    return null;
  }

  Future<int> getChamadoNumberForUser(String userName) async {
    try {
      int existingChamados = await _firestore
          .collection(usersCollection)
          .doc(userName)
          .collection(chamadosCollection)
          .get()
          .then((snapshot) => snapshot.docs.length);

      return existingChamados + 1;
    } catch (e) {
      log('Erro ao obter o número do chamado: $e');
      rethrow;
    }
  }

  Future<void> addNewReport(
    String address,
    String cep,
    String referPoint,
    String addressNumber,
    String description,
    String category,
    String definicaoCategoria,
    double? longitudeReport,
    double? latitudeReport, {
    PlatformFile? imageFile,
    PlatformFile? videoFile,
    String? messageString,
    String statusMessage = 'Enviado',
    bool showMessage = false,
    bool isDone = false,
  }) async {
    try {
      String? userName = await getUserName(user!.uid);

      Map<String, String?> fileUrls = {};

      if (userName != null && imageFile != null) {
        fileUrls = await uploadFilesAndSaveReport(
          imageFile,
          videoFile,
          userName,
        );
      } else {
        throw Exception("Erro ao obter o nome do usuário.");
      }

      DateTime dateTime = DateTime.now();
      final chamadoId = GenerateReportId.generateRandomNumber();

      final report = ReportingModel(
        chamadoId: chamadoId,
        userId: user!.uid,
        isDone: isDone,
        address: address,
        cep: cep,
        referPoint: referPoint,
        addressNumber: addressNumber,
        description: description,
        category: category,
        date: dateTime,
        statusMessage: statusMessage,
        messageString: messageString ?? '',
        definicaoCategoria: definicaoCategoria,
        showMessage: showMessage,
        imageFile: fileUrls['imagemChamado'] ?? 'imagem não disponivel',
        videoFile: fileUrls['videoChamado'] ?? 'vídeo não disponivel',
        locationReport: GeoPoint(latitudeReport!, longitudeReport!),
      );

      DocumentReference documentReference =
          _firestore.collection(chamadosCollection).doc(chamadoId);

      await documentReference.set(report.toMap());

      Get.snackbar(
        'Sucesso!',
        'Chamado enviado com sucesso. ID: $chamadoId',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.green,
        borderRadius: 20,
        colorText: Colors.white,
        dismissDirection: DismissDirection.up,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao enviar o chamado: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
        borderRadius: 20,
        colorText: Colors.white,
        dismissDirection: DismissDirection.up,
      );
    }
  }

  final StreamController<QuerySnapshot> _streamController =
      StreamController.broadcast();

  final StreamController<QuerySnapshot> _adminStreamController =
      StreamController.broadcast();

  Stream<QuerySnapshot> adminStream() {
    _firestore.collection(chamadosCollection).snapshots().listen(
      (data) {
        _adminStreamController.add(data);
      },
      onError: (error) {
        _adminStreamController.addError(error);
      },
    );

    return _adminStreamController.stream;
  }

  List<QueryDocumentSnapshot> prioritizeDocs(List<QueryDocumentSnapshot> docs) {
    final arvoreCaidaDocs = <QueryDocumentSnapshot>[];
    final otherDocs = <QueryDocumentSnapshot>[];

    for (final doc in docs) {
      if (doc['Categoria'] == 'Árvore Caída') {
        arvoreCaidaDocs.add(doc);
      } else {
        otherDocs.add(doc);
      }
    }

    return [...arvoreCaidaDocs, ...otherDocs];
  }

  @override
  void onClose() {
    _streamController.close();
    _adminStreamController.close();
    super.onClose();
  }

  Future<List<ReportingModel>> fetchUserReports() async {
    try {
      final querySnapshot = await _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(chamadosCollection)
          .get();

      return querySnapshot.docs.map(
        (doc) {
          final data = doc.data();
          return ReportingModel.fromMap(data);
        },
      ).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<ReportingModel>> fetchAdminReports() async {
    try {
      final querySnapshot =
          await _firestore.collection(chamadosCollection).get();

      return querySnapshot.docs.map(
        (doc) {
          final data = doc.data();
          return ReportingModel.fromMap(data);
        },
      ).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> fetchAndEditReport(
    String chamadoId, {
    String? newAddress,
    String? newCep,
    String? newReferPoint,
    String? newAddressNumber,
    String? newDescription,
    String? newCategory,
    String? newCategoryString,
    String? newStatusMessage,
    bool? newShowMessage,
    bool? newIsDone,
  }) async {
    try {
      final docRef = _firestore
          .collection(usersCollection)
          .doc(_auth.currentUser!.uid)
          .collection(chamadosCollection)
          .doc(chamadoId);

      DocumentSnapshot docSnapshot = await docRef.get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        log('Erro: Chamado não encontrado.');
        return;
      }

      ReportingModel report =
          ReportingModel.fromMap(docSnapshot.data() as Map<String, dynamic>);

      final updatedReport = report.copyWith(
        address: newAddress ?? report.address,
        cep: newCep ?? report.cep,
        referPoint: newReferPoint ?? report.referPoint,
        addressNumber: newAddressNumber ?? report.addressNumber,
        description: newDescription ?? report.description,
        category: newCategory ?? report.category,
        definicaoCategoria: newCategoryString ?? report.definicaoCategoria,
        statusMessage: newStatusMessage ?? report.statusMessage,
        showMessage: newShowMessage ?? report.showMessage,
        isDone: newIsDone ?? report.isDone,
      );

      await docRef.update(updatedReport.toMap());

      Get.snackbar(
        'Sucesso!',
        'Chamado atualizado com sucesso',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      log('Erro ao buscar ou editar o chamado: $e');
      Get.snackbar(
        'Erro',
        'Falha ao atualizar o chamado: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  Future<ReportingModel?> getReportById(String reportId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection(chamadosCollection).doc(reportId).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return ReportingModel.fromMap(
          docSnapshot.data() as Map<String, dynamic>,
        );
      } else {
        return null;
      }
    } catch (e) {
      log('Erro ao buscar o relatório: $e');
      return null;
    }
  }

  Future<void> updateReport(
    String reportId,
    Map<String, dynamic> updatedReport,
  ) async {
    try {
      final docRef = _firestore.collection(chamadosCollection).doc(reportId);

      await docRef.update(updatedReport);

      Get.snackbar('Sucesso!', 'Chamado atualizado com sucesso');
    } catch (e) {
      log('Erro ao atualizar o chamado: $e');
      Get.snackbar('Erro', 'Falha ao atualizar o chamado: $e');
    }
  }

  Future<void> updateDisplayMessage(String reportId, bool showMessage) async {
    try {
      await _firestore.collection(chamadosCollection).doc(reportId).update(
        {'Exibir Mensagem': showMessage},
      );

      final docSnapshot =
          await _firestore.collection(chamadosCollection).doc(reportId).get();
      final userId = docSnapshot.data()?['UserId'];

      if (userId != null) {
        await _firestore
            .collection(usersCollection)
            .doc(userId)
            .collection(chamadosCollection)
            .doc(reportId)
            .update(
          {
            'Exibir Mensagem': showMessage,
          },
        );
      }
    } catch (e) {
      log('Erro ao atualizar a mensagem: $e');
      Get.snackbar('Erro', 'Falha ao atualizar a mensagem: $e');
    }
  }

  Future<String?> getChamadoImage(String chamadoId, String userId) async {
    try {
      DocumentSnapshot chamadoSnapshot =
          await _firestore.collection('Chamados').doc(chamadoId).get();

      final data = chamadoSnapshot.data() as Map<String, dynamic>;

      return data['Imagem do Chamado'] as String?;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> getChamadoVideo(String chamadoId, String userId) async {
    try {
      DocumentSnapshot chamadoSnapshot =
          await _firestore.collection('Chamados').doc(chamadoId).get();

      final data = chamadoSnapshot.data() as Map<String, dynamic>;

      return data['Video do Chamado'] as String?;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
