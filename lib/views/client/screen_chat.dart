import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:rawaa_app/controller/chat_controller.dart';
import 'package:rawaa_app/views/client/screen_message.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    // A messenger-like screen: horizontal contacts w/profile pic+name, history below, search bar at top
    return GetBuilder<ChatController>(
      init: ChatController(),
      builder: (ctrl) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF4F5F7),
                    ),
                  ),
                ),

                // Horizontal list of contacts
                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl
                        .listeContact
                        .length, // Replace with real contacts count
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, idx) {
                      return InkWell(
                        onTap: () {
                          ctrl.setSelectedContact(ctrl.listeContact[idx]);

                          Get.to(() => ScreenDiscussion());
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(
                                    // Use contact image here
                                    "https://randomuser.me/api/portraits/men/$idx.jpg",
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  bottom: 2,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: BoxDecoration(
                                      color: idx % 3 == 0
                                          ? Colors.green
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            SizedBox(
                              width: 60,
                              child: Text(
                                // Use contact name here
                                ctrl.listeContact[idx].name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // List of last conversation history
                Expanded(
                  child: ListView.separated(
                    itemCount: 15, // Replace by conversation count
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (context, idx) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            // Conversation partner's image
                            "https://randomuser.me/api/portraits/women/$idx.jpg",
                          ),
                          radius: 24,
                        ),
                        title: Text(
                          'Contact $idx',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Last message snippet goes here...",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "1${idx}:10 AM",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            if (idx % 4 == 0) ...[
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        onTap: () {
                          // TODO: Go to chat screen for this person
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
