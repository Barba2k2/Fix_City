import 'package:get/get.dart';
import '../../../Constants/text_strings.dart';
import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../../Repository/UserRepository/user_repository.dart';
import '../../../utils/helper/helper_controller.dart';
import '../Models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = AuthenticationRepository.instance;
  final _userRepo = UserRepository.instance;

  getUserData() async {
    try {
      final currentUserEmail = _authRepo.getUserEmail;
      if (currentUserEmail.isNotEmpty) {
        return await _userRepo.getUserDetails(currentUserEmail);
      } else {
        Helper.warningSnackBar(
          title: 'Erro',
          message: 'Nenhum usuario encotrado!',
        );
        return;
      }
    } catch (e) {
      Helper.errorSnackBar(
        title: 'Erro',
        message: 'Nenhum dado de usuário encontrado: $e',
      );
    }
  }

  Future<String?> getUserName() async {
    try {
      final currentUserName = _authRepo.getDisplayName;
      if (currentUserName.isNotEmpty) {
        final user = await _userRepo.getUserNameDetails(currentUserName);
        return user.fullName;
      } else {
        Helper.warningSnackBar(
          title: 'Erro',
          message: 'Nenhum usuario encontrado!',
        );
        return null;
      }
    } catch (e) {
      Helper.errorSnackBar(title: 'Erro', message: e.toString());
      return null;
    }
  }

  updateRecord(UserModel user) async {
    try {
      await _userRepo.updateUserRecord(user);
      Helper.successSnackBar(
        title: tCongratulations,
        message: 'Seus dados forma atualizados com sucesso!',
      );
    } catch (e) {
      Helper.errorSnackBar(
        title: 'Erro',
        message: 'Ocorreu um erro ao atualizar os dados: $e',
      );
    }
  }

  Future<void> deleteUser() async {
    try {
      String uID = _authRepo.getUserID;
      if (uID.isNotEmpty) {
        await _userRepo.deleteUser(uID);
        Helper.successSnackBar(
            title: tCongratulations, message: 'Conta exluida com sucesso!');
      } else {
        Helper.successSnackBar(
          title: 'Erro',
          message: 'Usuário não pode ser deletado!',
        );
      }
    } catch (e) {
      Helper.errorSnackBar(
        title: 'Erro',
        message: 'Erro ao excluir usuário: $e',
      );
    }
  }
}
