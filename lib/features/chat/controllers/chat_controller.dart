import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidesa_mobile/core/utils/snackbar_helper.dart';
import '../data/chat_model.dart';
import '../data/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository _repo = ChatRepository();
  
  // State
  var messages = <ChatMessage>[].obs;
  var isTyping = false.obs;
  var isLoadingHistory = false.obs;

  // Controllers UI
  final textController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // 1. Muat Riwayat Chat
  Future<void> loadHistory() async {
    isLoadingHistory.value = true;
    try {
      final data = await _repo.getHistory();
      messages.clear();
      
      for (var item in data) {
        if (item['pertanyaan'] != null) {
          messages.add(ChatMessage(text: item['pertanyaan'], isUser: true));
        }
        if (item['jawaban'] != null) {
          messages.add(ChatMessage(text: item['jawaban'], isUser: false));
        }
      }

      // Sapaan awal jika kosong
      if (messages.isEmpty) {
        messages.add(ChatMessage(text: "Halo! Saya SiDesa AI. Ada yang bisa saya bantu terkait layanan desa?", isUser: false));
      }
      
      _scrollToBottom();
    } catch (e) {
      SnackbarHelper.error(
        title: "Gagal memuat riwayat chat",
        message: e.toString().replaceAll("Exception: ", ""),
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // 2. Kirim Pesan
  Future<void> sendMessage() async {
    String text = textController.text.trim();
    if (text.isEmpty) return;

    // Masukkan pesan user ke UI
    messages.add(ChatMessage(text: text, isUser: true));
    textController.clear();
    isTyping.value = true; // Munculkan indikator loading
    _scrollToBottom();

    try {
      // Tembak API Groq
      String reply = await _repo.sendMessage(text);
      messages.add(ChatMessage(text: reply, isUser: false));
    } catch (e) {
      messages.add(ChatMessage(text: "Maaf, jaringan sedang bermasalah. Coba lagi ya.", isUser: false));
    } finally {
      isTyping.value = false;
      _scrollToBottom();
    }
  }

  // 3. Bersihkan Chat
  Future<void> clearChat() async {
    try {
      await _repo.clearHistory();
      messages.clear();
      messages.add(ChatMessage(text: "Riwayat obrolan telah dibersihkan. Ada yang bisa saya bantu lagi?", isUser: false));
      
      // Menggunakan helper tipe Success
      SnackbarHelper.success(
        title: "Sukses", 
        message: "Riwayat obrolan berhasil dihapus"
      );
    } catch (e) {
      // Menggunakan helper tipe Error
      SnackbarHelper.error(
        title: "Error", 
        message: "Gagal membersihkan riwayat"
      );
    }
  }

  // 4. Auto Scroll ke bawah
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}