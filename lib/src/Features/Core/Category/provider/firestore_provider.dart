import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class FirestoreProvider with ChangeNotifier {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<List<Category>> getCategoriesStream() {
    return _firestore
        .collection('categories')
        .doc('categoriesDocId')
        .snapshots()
        .map(
      (snapshot) {
        final data = snapshot.data();
        if (data == null) return [];
        return data.entries
            .map((e) => Category(id: e.key, name: e.value['name']))
            .toList();
      },
    );
  }

  static Future<void> updateCategory(Map<String, String> categoryData,
      {String? categoryId}) async {
    try {
      DocumentReference docRef =
          _firestore.collection('categories').doc('categoriesDocId');

      if (categoryId == null || categoryId.isEmpty) {
        categoryId = docRef.collection('autoId').doc().id;
      }

      await docRef.set(
        {categoryId: categoryData},
        SetOptions(merge: true),
      );
      log("Sucesso ao adicionar ou atualizar categoria");
    } catch (e) {
      throw 'Erro ao adicionar ou atualizar a categoria: $e';
    }
  }

  static Future<void> removeCategory(String categoryId) async {
    try {
      DocumentReference docRef =
          _firestore.collection('categories').doc('categoriesDocId');

      await docRef.update({categoryId: FieldValue.delete()});
      log("Sucesso ao remover categoria");
    } catch (e) {
      throw 'Erro ao remover a categoria: $e';
    }
  }

  static Future<Map<String, dynamic>> getCategoryById(String categoryId) async {
    DocumentReference docRef =
        _firestore.collection('categories').doc('categoriesDocId');

    DocumentSnapshot documentSnapshot = await docRef.get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      return data[categoryId] as Map<String, dynamic>;
    } else {
      throw 'Categoria não encontrada';
    }
  }

  static Future<void> updateDocument(
      String collectionName, Map<String, dynamic> data,
      {String? documentId}) async {
    try {
      DocumentReference docRef =
          _firestore.collection(collectionName).doc(documentId);
      await docRef.update(data);
      log("Documento atualizado com sucesso");
    } catch (e) {
      throw 'Erro ao atualizar o documento: $e';
    }
  }

  static Future<void> removeDocument(
      String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
      log("Documento removido com sucesso");
    } catch (e) {
      throw 'Erro ao remover o documento: $e';
    }
  }

  static Future<Map<String, dynamic>> getDocumentById(
      String collectionName, String documentId) async {
    DocumentReference docRef =
        _firestore.collection(collectionName).doc(documentId);
    DocumentSnapshot documentSnapshot = await docRef.get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      throw 'Documento não encontrado';
    }
  }

  static Stream<List<DocumentSnapshot>> getDocumentsBy(
      String collectionName, String attributeName, String attributeValue) {
    try {
      return _firestore
          .collection(collectionName)
          .where(attributeName, isEqualTo: attributeValue)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } catch (e) {
      log('Erro ao obter documentos: $e');
      return Stream.value([]);
    }
  }
}
