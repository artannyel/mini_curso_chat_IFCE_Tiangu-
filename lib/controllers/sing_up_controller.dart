import 'package:chat_app_mini_curso/models/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SingUpController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _collectionUser = FirebaseFirestore.instance.collection('users');

  Future<bool> singUp() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await _collectionUser
          .doc(userCredential.user!.uid)
          .set(
            ChatsMembers(
              email: emailController.text,
              name: nameController.text,
            ).toJson(),
          );
      await userCredential.user?.updateDisplayName(nameController.text);
      await userCredential.user?.reload();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }
}
