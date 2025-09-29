import 'package:chat_app_mini_curso/components/message_bubble.dart';
import 'package:chat_app_mini_curso/controllers/chat_messages_controller.dart';
import 'package:chat_app_mini_curso/models/chats.dart';
import 'package:flutter/material.dart';

class ChatMessagesPage extends StatefulWidget {
  final String chatId;
  final String chatName;
  final String chatEmail;

  const ChatMessagesPage({
    super.key,
    required this.chatId,
    required this.chatName,
    required this.chatEmail,
  });

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  final controller = ChatMessagesController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
              stream: controller.streamChatMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                }

                return Column(
                  children: [
                    Expanded(
                      child: !snapshot.hasData || snapshot.data!.docs.isEmpty
                          ? Center(child: Text('Nenhuma mensagem encontrada'))
                          : ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final doc = snapshot.data!.docs[index];
                                final data = doc.data();
                                final chatMessages = ChatsMessages.fromJson(
                                  data,
                                );
                                final message = chatMessages.message;

                                return MessageBubble(
                                  message: message,
                                  isMe: controller.isMe(
                                    chatMessages.senderEmail,
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(
                      child: Row(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              style: TextStyle(height: 1.2),
                              controller: controller.messageTextController,
                              decoration: InputDecoration(
                                hintText: 'Digite uma mensagem',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                          IconButton.filled(
                            onPressed: () {
                              controller.sendMessage(
                                widget.chatId,
                                widget.chatName,
                              );
                            },
                            icon: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(Icons.send_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
