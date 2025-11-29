import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:rawaa_app/controller/chat_controller.dart';
import 'package:rawaa_app/model/model_msg.dart';

class ScreenDiscussion extends StatelessWidget {
  const ScreenDiscussion({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController ctrl = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text(ctrl.selectedContact!.name),
        centerTitle: true,
        elevation: 1,
      ),
      body: GetBuilder<ChatController>(
        builder: (ctrl) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: ctrl.scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: ctrl.listeMessage.length,
                  itemBuilder: (context, idx) {
                    MMessage msg = ctrl.listeMessage[idx];
                    final isMe = msg.isMe;
                    final color = isMe
                        ? Colors.blueAccent
                        : Colors.grey.shade300;
                    final textColor = isMe ? Colors.white : Colors.black87;
                    final align = isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft;
                    final borderRadius = BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: isMe
                          ? Radius.circular(18)
                          : Radius.circular(4),
                      bottomRight: isMe
                          ? Radius.circular(4)
                          : Radius.circular(18),
                    );
                    return Container(
                      alignment: align,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: borderRadius,
                            ),
                            child: Text(
                              msg.content,
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMe ? 0 : 9,
                              right: isMe ? 9 : 0,
                              top: 2,
                            ),
                            child: Text(
                              _formatTime(msg.time),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 8, bottom: 8, top: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Colors.black12,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ctrl.TecMessage,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Entrez votre message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 22,
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          ctrl.storeMsg();
                          
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
