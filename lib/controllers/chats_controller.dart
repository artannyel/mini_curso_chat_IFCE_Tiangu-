import 'package:chat_app_mini_curso/models/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsController {
  final _auth = FirebaseAuth.instance;
  final _collection = FirebaseFirestore.instance.collection('chats');
  final _collectionUsers = FirebaseFirestore.instance.collection('users');
  final User user = FirebaseAuth.instance.currentUser!;

  Future<bool> singOut() async {
    try {
      await _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats() {
    return _collection
        .where('membersEmails', arrayContains: user.email)
        .snapshots();
  }

  Future<ChatsMembers?> _existUser(String email) async {
    final dataUser = await _collectionUsers
        .where('email', isEqualTo: email)
        .get();
    return dataUser.docs.isEmpty
        ? null
        : dataUser.docs
              .map((member) => ChatsMembers.fromJson(member.data()))
              .toList()
              .first;
  }

  Future<String?> createChat(String emailSender) async {
    try {
      final userSend = await _existUser(emailSender);
      if (userSend == null) {
        return 'Usuário não encontrado';
      }
      final chats = Chats(
        createdAt: Timestamp.now(),
        members: [
          ChatsMembers(email: user.email!, name: user.displayName!),
          ChatsMembers(email: emailSender, name: userSend.name),
        ],
      );
      await _collection.add(chats.toJson());
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return 'Erro ao criar chat';
    }
  }

  ChatsMembers chatOtherMember(List<ChatsMembers> members) {
    if (members[0].email == user.email) {
      return members[1];
    }
    return members[0];
  }
}
