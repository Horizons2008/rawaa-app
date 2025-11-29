import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:rawaa_app/controller/chat_controller.dart';
import 'package:rawaa_app/model/model_contact.dart';
import 'package:rawaa_app/model/model_msg.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/client/screen_message.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    // A messenger-like screen: horizontal contacts w/profile pic+name, history below, search bar at
    return Scaffold(
      appBar: AppBar(title: Text("Chat Room")),
      body: GetBuilder<ChatController>(
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
                        print(
                          "${Constants.photoUrl}users/${ctrl.listeContact[idx].id}.jpg",
                        );
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
                                    backgroundImage: NetworkImage(
                                      // Conversation partner's image
                                      "${Constants.photoUrl}users/${ctrl.listeContact[idx].id}.jpg",
                                    ),
                                    onBackgroundImageError:
                                        (exception, stackTrace) {
                                          Icon(Icons.person);
                                        },
                                    radius: 24,
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
                      itemCount: ctrl
                          .listeRecent
                          .length, // Replace by conversation count
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, idx) {
                        MMessage item = ctrl.listeRecent[idx];
                        return InkWell(
                          onTap: () {},
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                // Conversation partner's image
                                "${Constants.photoUrl}users/${item.id}.jpg",
                              ),
                              onBackgroundImageError: (exception, stackTrace) {
                                Icon(Icons.person);
                              },
                              radius: 24,
                            ),
                            title: Text(
                              ctrl.getName(item),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              item.content,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(item.time),

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
                              // Navigate to conversation screen
                              int id =
                                  item.receiverId.toString() ==
                                      Constants.currentUser!.id
                                  ? item.senderId
                                  : item.receiverId;
                              MContact contact = ctrl.listeContact.firstWhere(
                                (element) => element.id == id,
                              );
                              ctrl.setSelectedContact(contact);
                              Get.to(() => ScreenDiscussion());
                              // TODO: Go to chat screen for this person
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
