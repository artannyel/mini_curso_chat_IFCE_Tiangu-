import 'package:cloud_firestore/cloud_firestore.dart';

class Chats {
  late Timestamp createdAt;
  late List<String> membersEmails;
  late List<ChatsMembers> members;

  Chats({
    required this.createdAt,
    required this.members,
  }) {
    membersEmails = members.map((member) => member.email).toList();
  }

  Chats.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    membersEmails = List<String>.from(json['membersEmails'] ?? []);
    members = (json['members'] as List<dynamic>)
        .map((member) => ChatsMembers.fromJson(member))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'membersEmails': membersEmails,
      'members': members.map((member) => member.toJson()).toList(),
    };
  }
}

class ChatsMembers {
  late String email;
  late String name;

  ChatsMembers({required this.email, required this.name});

  ChatsMembers.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'name': name};
  }
}

class ChatsMessages {
  late String chatId;
  late String senderEmail;
  late String receiverEmail;
  late String message;
  late Timestamp createdAt;

  ChatsMessages({
    required this.chatId,
    required this.senderEmail,
    required this.receiverEmail,
    required this.message,
    required this.createdAt,
  });

  ChatsMessages.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    senderEmail = json['senderEmail'];
    receiverEmail = json['receiverEmail'];
    message = json['message'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'message': message,
      'createdAt': createdAt,
    };
  }
}
