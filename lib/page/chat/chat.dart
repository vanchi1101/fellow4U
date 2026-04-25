import 'package:flutter/material.dart';
import 'package:sign_up_in/page/chat/chat_detail_page.dart';
import 'package:sign_up_in/services/api_service.dart';
import 'package:sign_up_in/services/session_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<List<dynamic>> _chatFuture;

  @override
  void initState() {
    super.initState();
    _chatFuture = _loadChats();
  }

  Future<List<dynamic>> _loadChats() async {
    final userId = await SessionService.getUserId();
    if (userId == null) {
      throw Exception('Chua dang nhap.');
    }
    return ApiService.getChats(userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _chatFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Text('Khong the tai danh sach chat.\n${snapshot.error}'),
            ),
          );
        }

        final chatUsers = List<Map<String, dynamic>>.from(snapshot.data!);
        return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            centerTitle: true,
            pinned: false,
            expandedHeight: 170,
            clipBehavior: Clip.none,
            floating: true,
            flexibleSpace: Stack(
              clipBehavior: Clip.none,
              children: [
                FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/explore_header.png',
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                "Chat",
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Icon(Icons.search, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: TextStyle(color: Color(0xffF5F5F5)),
                decoration: InputDecoration(
                  hintText: "Search Chat",

                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
              child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                final chatUser = chatUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      chatUser['avatarImage'] as String,
                    ),
                  ),
                  title: Text(
                    chatUser['name'] as String,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chatUser['lastMessage'] as String),
                  trailing: Text(chatUser['time'] as String),
                  shape: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailPage(
                          name: chatUser['name'] as String,
                          avatarImage: chatUser['avatarImage'] as String,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
        );
      },
    );
  }
}
