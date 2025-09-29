import 'package:chat_app_mini_curso/models/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessagesController {
  final _collection = FirebaseFirestore.instance.collection('chat_messages');
  final _user = FirebaseAuth.instance.currentUser!;
  final messageTextController = TextEditingController();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChatMessages(
    String chatId,
  ) {
    return _collection
        .where('chatId', isEqualTo: chatId)
        .orderBy('createdAt')
        .snapshots();
  }

  bool isMe(String senderEmail) {
    return senderEmail == _user.email;
  }

  Future<void> sendMessage(String chatId, String receiverEmail) async {
    try {
      await _collection.add(
        ChatsMessages(
          chatId: chatId,
          senderEmail: _user.email!,
          receiverEmail: receiverEmail,
          message: messageTextController.text,
          createdAt: Timestamp.now(),
        ).toJson(),
      );
      messageTextController.clear();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
