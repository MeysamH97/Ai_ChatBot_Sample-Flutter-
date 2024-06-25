import 'dart:convert';
import 'package:ai_test/ai_response_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:ai_test/methods.dart';
import 'package:ai_test/screens/login_screen.dart';
import 'package:ai_test/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<MessageStruct> _messages = [];
  late String _apiKey = '';
  int? selectedMessage;
  bool aiIsTyping = false;
  ScrollController scrollController = ScrollController();

  var _client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 20,
            color: Colors.white,
          ),
          Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: selectedMessage != null
                      ? [
                          Colors.white,
                          Colors.indigo[300]!.withOpacity(0.5),
                        ]
                      : [Colors.transparent, Colors.black.withOpacity(0.05)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              height: 75,
              child: selectedMessage != null
                  ? Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedMessage = null;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.info_outline),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.restore_from_trash_outlined),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoogleSearchPage(
                                  searchQuery:
                                      _messages[selectedMessage!].content!,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.g_mobiledata_sharp,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.push_pin_outlined),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.copy),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            logOut();
                          },
                          icon: const Icon(Icons.arrow_back_ios_sharp),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                          child: Text(
                            'Chat AI',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.lock_clock),
                        ),
                      ],
                    ),
            ),
          ),
          (_messages.isEmpty)
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(35),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purple[50],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(
                                  0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Icon(
                          Iconsax.magicpen,
                          size: 50,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Start chat with AI',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Fill in the App to see the result! Introduction',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.25)),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      bool isMe = _messages[index].role != 'assistant';
                      return Column(
                        children: [
                          InkWell(
                            onLongPress: () {
                              setState(() {
                                selectedMessage = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isMe
                                      ? selectedMessage == index
                                          ? [
                                              Colors.indigo[300]!
                                                  .withOpacity(0.5),
                                              Colors.indigo[300]!
                                                  .withOpacity(0.5),
                                            ]
                                          : [Colors.white, Colors.purple[50]!]
                                      : selectedMessage == index
                                          ? [
                                              Colors.indigo[300]!
                                                  .withOpacity(0.5),
                                              Colors.indigo[300]!
                                                  .withOpacity(0.5),
                                            ]
                                          : [Colors.white, Colors.grey[100]!],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      !isMe
                                          ? Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 15,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Image.asset(
                                                        'assets/logo.png'),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const Text(
                                                  "AI :",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Text(
                                              "You :",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: isMe
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: MarkdownBody(
                                          data: _messages[index].content ?? '',
                                          styleSheet: MarkdownStyleSheet(
                                            codeblockDecoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            codeblockPadding:
                                                const EdgeInsets.all(10),
                                            code: const TextStyle(
                                              backgroundColor:
                                                  Colors.transparent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          selectable: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  _messages[index].time != null
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                getTime(_messages[index].time!),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black
                                                        .withOpacity(0.35)),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      maxLines: null,
                      controller: _controller,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.purple[800]!.withOpacity(0.1),
                        hintText: 'What is in your mind?...',
                        hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.35)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async{
                      if (!aiIsTyping) {
                        if (_controller.text.isNotEmpty) {
                         await _sendMessage(_controller.text);
                        }
                      } else {
                        setState(() {
                          aiIsTyping = false;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: aiIsTyping
                              ? [Colors.red, Colors.purple[200]!]
                              : [Colors.blueAccent, Colors.purple[200]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        aiIsTyping ? Iconsax.stop : Iconsax.send_24,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _sendMessage(String message) async {
    MessageStruct newMessage = MessageStruct(
      role: 'user',
      content: message,
      time: DateTime.now(),
    );

    List<dynamic> jsonBody = [
      {
        'role': 'user',
        'content': message,
      }
    ];
    _messages.add(
      newMessage,
    );
    _controller.clear();
    aiIsTyping = true;
    callbackAction();
    await streamApiResponse(jsonBody);
  }

  Future streamApiResponse(
    List<dynamic> jsonBody,
  ) async {
    _client = http.Client();
    _apiKey = 'sk-53d828d222954513808110662b5b21b7';
    const url = 'https://api.deepseek.com/chat/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
    String body = getApiBody(jsonBody);

    var request = http.Request('POST', Uri.parse(url))..headers.addAll(headers);
    request.body = body;

    final http.StreamedResponse response = await _client.send(request);

    if (aiIsTyping) {
      setState(() {
        _messages.add(
          MessageStruct(
            role: 'assistant',
            content: '',
            time: null,
          ),
        );
      });
      response.stream.listen((List<int> value) {
        if(aiIsTyping){
          var str = utf8.decode(value);
          if (str.contains("data: [DONE]")) {
            setState(() {
              _messages[_messages.length - 1].time = DateTime.now();
              aiIsTyping = false;
            });
          }
          if (str.contains("data:")) {
            String data = str.split('data: ')[1];
            addToChatHistory(data);
          }
        }
      });
    }
  }

  addToChatHistory(String data) {
    if (data.contains('content')) {
      ContentResponse contentResponse =
          ContentResponse.fromJson(jsonDecode(data));
      if (contentResponse.choices != null &&
          contentResponse.choices![0].delta != null &&
          contentResponse.choices![0].delta!.content != null) {
        String content = contentResponse.choices![0].delta!.content!;
        _messages[_messages.length - 1].content =
            _messages[_messages.length - 1].content! + content;
        callbackAction();
      }
    }
  }

  getApiBody(dynamic jsonBody) {
    return jsonEncode(
      {
        "model": "deepseek-chat",
        "messages": jsonBody,
        "stream": true,
      },
    );
  }

  callbackAction() {
    setState(() {});
    if(_messages.length !=1) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  String getTime(DateTime messageTime) {
    int time = DateTime.now().difference(messageTime).inMinutes;
    if (time == 0) {
      return 'Now';
    } else if (time >= 1 && time <= 59) {
      return '${time.toInt()} min ago';
    } else if (time >= 60 && time <= 1439) {
      return '${time ~/ 60} hours ago';
    } else if (time >= 1440 && time <= 10079) {
      return '${time ~/ (60 * 24)} days ago';
    } else if (time >= 10080 && time <= 43199) {
      return '${time ~/ (60 * 24 * 7)} weeks ago';
    } else if (time >= 43200 && time <= 129600) {
      return '${time ~/ (60 * 24 * 30)} month ago';
    } else {
      return 'A long time ago';
    }
  }

  void logOut() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        title: const SizedBox(
          height: 10,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Are you sure you want log out?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.1),
                    surfaceTintColor: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.sizeOf(context).width / 3,
                        padding: const EdgeInsets.all(20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Material(
                    color: Colors.red.withOpacity(0.5),
                    surfaceTintColor: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        auth.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.sizeOf(context).width / 3,
                        padding: const EdgeInsets.all(20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
