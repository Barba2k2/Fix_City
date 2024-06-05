import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? password;
  final String fullName;
  final String email;
  final String? phoneNo;
  final String? cpf;
  final bool isAdmin;

  const UserModel({
    this.id,
    this.password,
    required this.email,
    required this.fullName,
    this.phoneNo,
    this.cpf,
    this.isAdmin = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "Nome Completo": fullName,
      "E-mail": email,
      "Numero de Telefone": phoneNo,
      "CPF": cpf,
      "Admin": isAdmin,
    };
  }

  static UserModel empty() => const UserModel(
        id: '',
        email: '',
        fullName: '',
        phoneNo: '',
        cpf: '',
        isAdmin: false,
      );

  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null || data.isEmpty) {
      return UserModel.empty();
    }

    final adminValue = data['Admin'];
    final bool isAdmin = adminValue is bool ? adminValue : false;

    return UserModel(
      id: document.id,
      email: data["E-mail"] ?? '',
      fullName: data["Nome Completo"] ?? '',
      phoneNo: data["Numero de Telefone"] ?? '',
      cpf: data["CPF"] ?? '',
      isAdmin: isAdmin,
    );
  }
}
