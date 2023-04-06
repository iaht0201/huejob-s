import 'package:app_tim_kiem_viec_lam/core/providers/chat_messager_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/user_provider.dart';
import 'package:app_tim_kiem_viec_lam/screens/chat/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../core/models/chat_message.dart';
import 'chatBubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.userTo, this.userFrom}) : super(key: key);
  final String? userTo;
  final String? userFrom;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _formKey = GlobalKey<FormState>();
  final _msgController = TextEditingController();

  Future<void> _submit(ChatProvider appService) async {
    final _text = _msgController.text;

    if (_text.isEmpty) {
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await appService.saveMessage(_text, widget.userTo.toString());

      _msgController.text = '';
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appService = context.read<ChatProvider>();

    return Scaffold(
      backgroundColor: HexColor("#BB2649"),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return Container(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${userProvider.userByID.name}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ));
              },
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45)),
                    color: Colors.white),
                child: StreamBuilder<List<Message>>(
                  stream: appService.getMessages(
                      widget.userFrom.toString(), widget.userTo.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data!;

                      List<Message> filteredMessages = messages
                          .where((message) =>
                              (message.userFrom == widget.userFrom &&
                                  message.userTo == widget.userTo) ||
                              (message.userFrom == widget.userTo &&
                                  message.userTo == widget.userFrom))
                          .toList();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                reverse: true,
                                itemCount: filteredMessages.length,
                                itemBuilder: (context, index) {
                                  final message = filteredMessages[index];

                                  return ChatBubble(message: message);
                                },
                              ),
                            ),
                            // SafeArea(
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Form(
                            //       key: _formKey,
                            //       child: TextFormField(
                            //         controller: _msgController,
                            //         decoration: InputDecoration(
                            //             labelText: 'Message',
                            //             suffixIcon: IconButton(
                            //               onPressed: () => _submit(appService),
                            //               icon: const Icon(
                            //                 Icons.send_rounded,
                            //                 color: Colors.grey,
                            //               ),
                            //             )),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 40.0)
                          ],
                        ),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
