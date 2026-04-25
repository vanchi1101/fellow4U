import 'package:flutter/material.dart';
import 'package:sign_up_in/data/chatdata/chat_data.dart';
import 'package:sign_up_in/models/chat_model.dart';
import 'chat_detail_page.dart';

// ─── Add Friends to Group Bottom Sheet ───────────────────────────────────────
class AddToGroupSheet extends StatefulWidget {
  final List<ChatUser> allUsers;

  const AddToGroupSheet({super.key, required this.allUsers});

  @override
  State<AddToGroupSheet> createState() => _AddToGroupSheetState();
}

class _AddToGroupSheetState extends State<AddToGroupSheet> {
  final Set<int> _selectedIndexes = {};
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.allUsers
        .asMap()
        .entries
        .where((e) => e.value.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Thêm vào nhóm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_selectedIndexes.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      final selected = _selectedIndexes
                          .map((i) => widget.allUsers[i])
                          .toList();
                      Navigator.pop(context, selected);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF3DD9C5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Text("Tạo nhóm (${_selectedIndexes.length})"),
                  ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: "Tìm kiếm bạn bè...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          // Selected chips
          if (_selectedIndexes.isNotEmpty)
            SizedBox(
              height: 64,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: _selectedIndexes.map((i) {
                  final user = widget.allUsers[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: AssetImage(user.avatarImage),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedIndexes.remove(i)),
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.name.split(' ').first,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

          const Divider(height: 1),

          // User list
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final entry = filtered[idx];
                final originalIndex = entry.key;
                final user = entry.value;
                final isSelected = _selectedIndexes.contains(originalIndex);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user.avatarImage),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    user.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  trailing: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xFF3DD9C5)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF3DD9C5)
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedIndexes.remove(originalIndex);
                      } else {
                        _selectedIndexes.add(originalIndex);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Updated Chat Page ────────────────────────────────────────────────────────
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  void _openAddToGroup(BuildContext context) async {
    final result = await showModalBottomSheet<List<ChatUser>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddToGroupSheet(allUsers: chatUsers),
    );

    if (result != null && result.isNotEmpty && context.mounted) {
      final names = result.map((u) => u.name).join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã tạo nhóm với: $names'),
          backgroundColor: const Color(0xFF3DD9C5),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
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
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
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
                            Row(
                              children: [
                                const Icon(Icons.search, color: Colors.white),
                                const SizedBox(width: 12),
                                // ── "+" button để thêm bạn vào nhóm ────
                                GestureDetector(
                                  onTap: () => _openAddToGroup(context),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white54,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Search bar ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                style: const TextStyle(color: Color(0xFF333333)),
                decoration: InputDecoration(
                  hintText: "Search Chat",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
            ),
          ),

          // ── Chat list ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // ── Nhấn vào -> mở ChatDetailPage ───────────────────────
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailPage(
                          name: chatUsers[index].name,
                          avatarImage: chatUsers[index].avatarImage,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(chatUsers[index].avatarImage),
                  ),
                  title: Text(
                    chatUsers[index].name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chatUsers[index].lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  trailing: Text(
                    chatUsers[index].time,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                  shape: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
