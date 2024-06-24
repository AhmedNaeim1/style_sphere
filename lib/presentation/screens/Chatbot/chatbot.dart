import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:style_sphere/constants.dart';
import 'package:style_sphere/data/models/user_data.dart';
import 'package:style_sphere/presentation/router.dart';
import 'package:style_sphere/presentation/screens/Chatbot/chatbot_results.dart';

class Chatbot extends StatefulWidget {
  final UserData user;

  const Chatbot({super.key, required this.user});

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  List<Map<String, dynamic>> messages = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _messageController = TextEditingController();
  bool showNextButton =
      false; // Control variable to determine if "Next" button should show
  final Dio _dio = Dio();
  bool isTyping = false; // Control variable for typing indicator
  // List<Product> recommendedProducts = [];
  bool isSendButtonEnabled = false; // Control variable for send button

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleMessageInputChange);
  }

  void _handleMessageInputChange() {
    setState(() {
      isSendButtonEnabled = _messageController.text.trim().isNotEmpty;
    });
  }

  void _attachImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        messages.add({
          "text": image.path,
          "time":
              "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
          "isSent": true,
          "isDelivered": false,
          "isImage": true,
          "date": DateTime.now(),
        });
      });
      _searchByImage(image.path);
    }
  }

  Future<void> _searchByImage(String imagePath) async {
    setState(() {
      isTyping = false; // Show typing indicator
    });

    File image = File(imagePath);

    Navigator.of(context, rootNavigator: true)
        .pushNamed(AppRoutes.searchResult, arguments: {
      "user": json.encode(widget.user),
      "image": image,
      "search": false,
    });
  }

  Future<void> _sendMessage() async {
    String messageText = _messageController.text;
    setState(() {
      messages.add({
        "text": messageText,
        "time":
            "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
        "isSent": true,
        "isDelivered": false,
        "isImage": false,
        "date": DateTime.now(),
      });
      _messageController.clear();
      isTyping = true; // Show typing indicator
    });

    try {
      final response = await _dio.post(
        'https://chatbott.loca.lt/chat',
        data: {'text': messageText, 'next': false},
      );

      final responseData = response.data;
      final chatbotMessage = responseData['response'] ?? '';
      final boolean = responseData['boolean'];
      final List<String> imageIds =
          List<String>.from(responseData['image_ids'] ?? []);

      setState(() {
        chatbotMessage == ""
            ? null
            : messages.add({
                "text": chatbotMessage,
                "time":
                    "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
                "isSent": false,
                "isDelivered": true,
                "isImage": false,
                "date": DateTime.now(),
              });
        showNextButton = boolean;
        isTyping = false; // Hide typing indicator
      });

      if (boolean) {
        // Make another request with next=true
        final secondResponse = await _dio.post(
          'https://chatbott.loca.lt/chat',
          data: {'text': messageText, 'next': true},
        );

        final secondResponseData = secondResponse.data;
        print(secondResponseData);
        final secondImageIds = List<String>.from(
            secondResponseData['image_ids']?.map((id) => id.toString()) ?? []);

        print(secondImageIds);

        if (secondImageIds.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ChatbotResultPage(
                      user: widget.user,
                      ids: secondImageIds,
                    )),
          );
        }
      } else if (imageIds.isNotEmpty) {
        // Fetch product details
        // await _fetchProductDetails(imageIds);
      }
    } catch (e) {
      print('Error sending message: $e');
      _showErrorMessage('Error sending message. Please try again later.');
      setState(() {
        isTyping = false; // Hide typing indicator
      });
    }
  }

  void _showErrorMessage(String errorMessage) {
    setState(() {
      messages.add({
        "text": errorMessage,
        "time":
            "${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
        "isSent": false,
        "isDelivered": true,
        "isImage": false,
        "date": DateTime.now(),
      });
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_handleMessageInputChange);
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  // widget.chat['imagePath'].isEmpty
                  primaryColor,
              // : null,
              backgroundImage:
                  // widget.chat['imagePath'].isNotEmpty
                  //     ? AssetImage(widget.chat['imagePath'])
                  //     :
                  null,
              child:
                  // widget.chat['imagePath'].isEmpty
                  //     ? Text(
                  //         widget.chat['name']
                  //             .split(' ')
                  //             .map((e) => e.isNotEmpty ? e[0] : '')
                  //             .take(2)
                  //             .join(),
                  //         style: const TextStyle(color: Colors.white, fontSize: 18),
                  //       )
                  //     :
                  null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Chatbot", style: TextStyle(color: Colors.black)),
                if (isTyping)
                  const Text("Typing...",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isSent = messages[index]['isSent'] == true;
                  bool isImage = messages[index]['isImage'] == true;
                  bool showDateHeader = index == 0 ||
                      messages[index]['date'].day !=
                          messages[index - 1]['date'].day ||
                      messages[index]['date'].month !=
                          messages[index - 1]['date'].month ||
                      messages[index]['date'].year !=
                          messages[index - 1]['date'].year;

                  return Column(
                    crossAxisAlignment: isSent
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (showDateHeader)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: Text(
                              DateFormat('EEEE, MMMM d, yyyy')
                                  .format(messages[index]['date']),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isSent
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isSent) ...[
                            CircleAvatar(
                              backgroundColor: primaryColor,
                              backgroundImage:
                                  // widget.chat['imagePath'].isNotEmpty
                                  //     ? AssetImage(widget.chat['imagePath'])
                                  //     :
                                  null,
                            ),
                            const SizedBox(width: 10),
                          ],
                          Column(
                            crossAxisAlignment: isSent
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.7),
                                decoration: BoxDecoration(
                                  color: isSent
                                      ? Colors.cyan.shade600
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: isImage
                                    ? Image.file(
                                        File(messages[index]['text']),
                                        width: 200,
                                      )
                                    : Text(
                                        messages[index]['text']!,
                                        style: TextStyle(
                                          color: isSent
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.photo, color: Colors.cyan.shade600),
                          onPressed: _attachImage,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.cyan.shade600),
                    onPressed: isSendButtonEnabled ? _sendMessage : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
