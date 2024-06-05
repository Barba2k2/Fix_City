import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/chamados_model.dart';

class SearchHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ReportingModel>> searchReports(String query) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('Chamados').get();

      final List<ReportingModel> reports = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReportingModel.fromMap(data);
      }).toList();

      final filteredReports = reports.where(
        (report) {
          return report.category!.toLowerCase().contains(query.toLowerCase()) ||
              report.description!.toLowerCase().contains(query.toLowerCase()) ||
              report.statusMessage!.toLowerCase().contains(query.toLowerCase());
        },
      ).toList();

      return filteredReports;
    } catch (e) {
      log('Erro ao pesquisar relatórios: $e');

      return [];
    }
  }

  Future<List<ReportingModel>> filterReportsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('Chamados')
          .where('Categoria', isEqualTo: category)
          .get();

      final List<ReportingModel> reports = snapshot.docs.map(
        (doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ReportingModel.fromMap(data);
        },
      ).toList();

      return reports;
    } catch (e) {
      log('Erro ao filtrar relatórios por categoria: $e');

      return [];
    }
  }
}
