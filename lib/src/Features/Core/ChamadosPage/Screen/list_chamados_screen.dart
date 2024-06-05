import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Category/models/category.dart';
import '../../Category/provider/firestore_provider.dart';
import '../Controller/chamados_controller.dart';
import '../Widgets/chamados_widget.dart';
import '../Widgets/report_detail_screen.dart';
import '../model/chamados_model.dart';
import 'Widgets/search_handler.dart';
import 'Widgets/serach_button.dart';
import 'chamados_screen.dart';

class AdminChamadosNew extends StatefulWidget {
  const AdminChamadosNew({super.key, required this.widget, this.usuarioLogado});

  final ChamadosScreen widget;
  final String? usuarioLogado;

  @override
  State<AdminChamadosNew> createState() => _AdminChamadosState();
}

class _AdminChamadosState extends State<AdminChamadosNew> {
  final searchBar = TextEditingController();
  final SearchHandler searchHandler = SearchHandler();
  List<ReportingModel> searchResults = [];
  List<Category> categories = [];
  final isSelected = TextEditingController();

  Future<void> _loadCategories() async {
    FirestoreProvider.getCategoriesStream().listen((categories) {
      setState(() {
        this.categories = categories;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void handleSearch(String query) async {
    try {
      final results = await searchHandler.searchReports(query.trim());
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      log('Erro do handle: $e');
    }
  }

  void clearSearch() {
    searchBar.clear();
    setState(() {
      searchResults = [];
    });
  }

  void clearSearchCategory(isSelected) {
    setState(() {
      this.isSelected.text = isSelected;
      searchResults = [];
    });
  }

  void onFiltered(List<ReportingModel> filteredResults) {
    setState(() {
      searchResults = filteredResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? usuarioLogado = widget.usuarioLogado;

    return Column(
      children: [
        TextFormField(
          onFieldSubmitted: handleSearch,
          controller: searchBar,
          decoration: InputDecoration(
            labelText: 'Pesquisar',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: clearSearch,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        StreamBuilder(
          stream: FirestoreProvider.getCategoriesStream(),
          builder: (context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
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

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
                child: Row(
                  children: [
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: snapshot.data!.map(
                        (category) {
                          return FilterButton(
                            category: category.name,
                            onFiltered: onFiltered,
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: searchResults.isEmpty
              ? usuarioLogado != null
                  ? StreamBuilder(
                      stream: FirestoreProvider.getDocumentsBy(
                        "Chamados",
                        "Id do Usuario",
                        usuarioLogado,
                      ),
                      builder: (context,
                          AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                        if (snapshot.hasError) {
                          log('Erro: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text(
                              'Nenhum dado disponível',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final reportList = snapshot.data!.map(
                          (doc) {
                            return ReportingModel.fromSnapshot(doc
                                as QueryDocumentSnapshot<Map<String, dynamic>>,);
                          },
                        ).toList();

                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final report = reportList[index];

                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ReportDetailScreen(
                                    reportingModel: report,
                                  ),
                                );
                              },
                              child: ChamadosWidget(report),
                            );
                          },
                          itemCount: reportList.length,
                        );
                      },
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: ReportController().adminStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text(
                              'Nenhum dado disponível',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        final reportList = snapshot.data!.docs.map(
                          (doc) {
                            return ReportingModel.fromSnapshot(
                              doc as QueryDocumentSnapshot<
                                  Map<String, dynamic>>,
                            );
                          },
                        ).toList();
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            final report = reportList[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ReportDetailScreen(
                                    reportingModel: report,
                                  ),
                                );
                              },
                              child: ChamadosWidget(report),
                            );
                          },
                          itemCount: reportList.length,
                        );
                      },
                    )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final report = searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ReportDetailScreen(
                            reportingModel: report,
                          ),
                        );
                      },
                      child: ChamadosWidget(report),
                    );
                  },
                  itemCount: searchResults.length,
                ),
        ),
      ],
    );
  }
}
