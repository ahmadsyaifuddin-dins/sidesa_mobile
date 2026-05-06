// Lokasi: lib/features/message/controllers/contact_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/message_repository.dart';
import '../../../core/utils/snackbar_helper.dart';

class ContactController extends GetxController {
  final MessageRepository _repo = MessageRepository();

  var allContacts = <UserModel>[].obs; // Data asli dari server
  var filteredContacts = <UserModel>[].obs; // Data yang ditampilkan (setelah di-search)
  
  var isLoading = true.obs;
  final TextEditingController searchC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    try {
      isLoading.value = true;
      final data = await _repo.getContacts();
      final users = data.map((e) => UserModel.fromJson(e)).toList();
      
      allContacts.value = users;
      filteredContacts.value = users; // Awalnya tampilkan semua
    } catch (e) {
      SnackbarHelper.error(title: "Error", message: "Gagal memuat daftar kontak.");
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk filter kontak berdasarkan nama
  void searchContact(String query) {
    if (query.isEmpty) {
      filteredContacts.value = allContacts;
    } else {
      filteredContacts.value = allContacts.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}