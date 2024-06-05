import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../Repository/AuthenticationRepository/Exceptions/exceptions.dart';
import '../../../../Repository/UserRepository/user_repository.dart';
import '../../../Authentication/Models/user_model.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _user = Rxn<UserModel>();
  UserModel? get currentUser => _user.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<UserModel?> getUserDetailsById(String uid) async {
    try {
      final snapshot = await _db.collection("Users").doc(uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        UserModel user = UserModel.fromSnapshot(snapshot);

        _user.value = user;
        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      final result = MyExceptions.fromCode(e.code);
      throw result.message;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      throw e.toString().isEmpty
          ? 'Something went wrong. Please Try Again'
          : e.toString();
    }
  }

  Stream<UserModel?> get userStream {
    return _db.collection("Users").doc(_auth.currentUser!.uid).snapshots().map(
          (snapshot) => snapshot.exists && snapshot.data() != null
              ? UserModel.fromSnapshot(snapshot)
              : null,
        );
  }

  void _loadUserData() async {
    try {
      UserModel? user = await UserRepository.instance.getUserDetailsById(
        _auth.currentUser!.uid,
      );

      _user.value = user;

      update();
    } catch (e) {
      log('Erro ao obter dados do usuário: $e');
    }
  }
}
