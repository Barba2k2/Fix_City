import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('dd/MM/yyyy');
final FirebaseAuth _auth = FirebaseAuth.instance;

DateTime currentDate = DateTime.now();
var day = currentDate.day.toString().padLeft(2, '0');
var month = currentDate.month.toString().padLeft(2, '0');
var year = currentDate.year.toString();
String formattedDate = "$day/$month/$year";

class ReportingModel {
  ReportingModel({
    this.chamadoId,
    this.userId,
    this.isDone,
    this.address,
    this.cep,
    this.addressNumber,
    this.referPoint,
    this.description,
    this.category,
    this.date,
    this.statusMessage,
    this.definicaoCategoria,
    this.showMessage,
    this.messageString,
    this.imageFile,
    this.videoFile,
    this.locationReport,
    this.observationsAdmin,
  });

  final String? chamadoId;
  final String? userId;
  final bool? isDone;
  final String? address;
  final String? cep;
  final String? addressNumber;
  final String? referPoint;
  final String? description;
  final String? category;
  final String? definicaoCategoria;
  final DateTime? date;
  final String? statusMessage;
  final bool? showMessage;
  final String? messageString;
  final String? imageFile;
  final String? videoFile;
  final GeoPoint? locationReport;
  final dynamic observationsAdmin;

  String get formattedDate => formatter.format(date!);

  @override
  String toString() {
    return 'ReportingModel: {Categoria: $category, \nDefinição Categoria: $definicaoCategoria, \nPonto de Referencia: $referPoint, \nEndereço: $address, \nNumero do Endereço: $addressNumber, \nCEP: $cep, \nStatus do Chamado: $statusMessage}';
  }

  Map<String, dynamic> toMap() {
    return {
      'Id do Chamado': chamadoId,
      'Id do Usuario': userId,
      'Concluido': isDone,
      'Endereco-Local': address,
      'CEP': cep,
      'Numero do Endereco': addressNumber,
      'Ponto de Referencia': referPoint,
      'Descricao': description,
      'Categoria': category,
      'Categoria do chamado': definicaoCategoria,
      'Data do Chamado': Timestamp.fromDate(date!),
      'Exibir Mensagem': showMessage,
      'Status do chamado': statusMessage,
      'Mensagem do Admin': messageString,
      'Imagem do Chamado': imageFile,
      'Video do Chamado': videoFile,
      'location_report': locationReport,
      'observations_admin': observationsAdmin,
    };
  }

  factory ReportingModel.fromMap(Map<String, dynamic> map) {
    return ReportingModel(
      chamadoId: map['Id do Chamado'] ?? '',
      userId: map['Id do Usuario'] ?? '',
      isDone: map['Concluido'] ?? false,
      address: map['Endereco-Local'] ?? '',
      cep: map['CEP'] ?? '',
      addressNumber: map['Numero do Endereco'] ?? '',
      referPoint: map['Ponto de Referencia'] ?? '',
      description: map['Descricao'] ?? '',
      category: map['Categoria'] ?? '',
      definicaoCategoria: map['Categoria do chamado'] ?? '',
      date: (map['Data do Chamado'] as Timestamp).toDate(),
      showMessage: map['Exibir Mensagem'] ?? false,
      statusMessage: map['Status do chamado'] ?? '',
      messageString: map['Mensagem do Admin'],
      imageFile: map['Imagem do Chamado'] ?? '',
      videoFile: map['Video do Chamado'] ?? '',
      locationReport: map['location_report'],
      observationsAdmin: map['observations_admin'] ?? [{}],
    );
  }

  factory ReportingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    log(data.toString());

    DateTime parseDate(dynamic input) {
      if (input == '') {
        return DateTime(1, 1, 1);
      }
      if (input is Timestamp) {
        return input.toDate();
      } else if (input is String) {
        final parts = input.split('/');
        if (parts.length != 3) {
          throw const FormatException('Formato de data inválido');
        }
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      } else {
        throw Exception(
            'Esperava Timestamp ou String, recebeu ${input.runtimeType}');
      }
    }

    return ReportingModel(
      chamadoId: data['Id do Chamado'] ?? '',
      userId: data['Id do Usuario'] ?? '',
      isDone: data['Concluido'] ?? false,
      address: data['Endereco-Local'] ?? '',
      cep: data['CEP'] ?? '',
      referPoint: data['Ponto de Referencia'] ?? '',
      addressNumber: data['Numero do Endereco'] ?? '',
      description: data['Descricao'] ?? '',
      category: data['Categoria'] ?? '',
      definicaoCategoria: data['Categoria do chamado'] ?? '',
      date: parseDate(data['Data do Chamado'] ?? ''),
      showMessage: data['Exibir Mensagem'] ?? false,
      statusMessage: data['Status do chamado'] ?? '',
      messageString: data['Mensagem do Admin'] ?? '',
      imageFile: data['Imagem do Chamado'] ?? '',
      videoFile: data['Video do Chamado'] ?? '',
      locationReport: data['location_report'],
      observationsAdmin: data['observations_admin'] ?? [{}],
    );
  }

  ReportingModel copyWith({
    String? userId,
    bool? isDone,
    String? address,
    String? cep,
    String? addressNumber,
    String? referPoint,
    String? description,
    String? category,
    String? definicaoCategoria,
    DateTime? date,
    String? statusMessage,
    bool? showMessage,
    String? messageString,
    String? imageFile,
    String? videoFile,
  }) {
    return ReportingModel(
      chamadoId: chamadoId,
      userId: userId ?? this.userId,
      isDone: isDone ?? this.isDone,
      address: address ?? this.address,
      cep: cep ?? this.cep,
      addressNumber: addressNumber ?? this.addressNumber,
      referPoint: referPoint ?? this.referPoint,
      description: description ?? this.description,
      category: category ?? this.category,
      definicaoCategoria: definicaoCategoria ?? this.definicaoCategoria,
      date: date ?? this.date,
      statusMessage: statusMessage ?? this.statusMessage,
      showMessage: showMessage ?? this.showMessage,
      messageString: messageString ?? this.messageString,
      imageFile: imageFile ?? this.imageFile,
      videoFile: videoFile ?? this.videoFile,
    );
  }

  static Future<String> generateReportId() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userCollection = firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('Chamados');
    int lastUserNumber = 0;

    try {
      final userQuerySnapshot = await userCollection
          .orderBy('Id do Chamado', descending: true)
          .limit(1)
          .get();
      log('Consulta à coleção de usuário realizada: $userQuerySnapshot');

      if (userQuerySnapshot.docs.isNotEmpty) {
        final lastUserId =
            userQuerySnapshot.docs.first['Id do Chamado'] as String;
        lastUserNumber = int.parse(lastUserId.replaceFirst('Chamado', ''));
        log('Último ID do chamado recuperado: $lastUserId');
        log('Último número do chamado recuperado: $lastUserNumber');
      } else {
        log('Nenhum chamado encontrado na coleção de usuário.');
      }

      String nextId =
          'Chamado${(lastUserNumber + 1).toString().padLeft(3, '0')}';
      log('Próximo ID do chamado gerado: $nextId');

      return nextId;
    } catch (e) {
      log('Erro: $e');
      throw Exception('Erro ao gerar ID do chamado: $e');
    }
  }
}
