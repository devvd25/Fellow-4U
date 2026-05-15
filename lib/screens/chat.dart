import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/api_service.dart';
import 'chat_detail.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<dynamic> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    try {
      final data = await ApiService.getConversations();
      if (mounted) {
        setState(() {
          _conversations = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: primaryColor))
                : RefreshIndicator(
                    onRefresh: _fetchConversations,
                    color: primaryColor,
                    child: _buildChatList(context),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Image.network('https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=800', height: 140, width: double.infinity, fit: BoxFit.cover),
        Container(height: 140, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent]))),
        SafeArea(bottom: false, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Chat', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.search, color: Colors.white, size: 28), onPressed: () {})]))),
      ],
    );
  }

  Widget _buildChatList(BuildContext context) {
    if (_conversations.isEmpty) {
      return const Center(child: Text('Chưa có hội thoại nào', style: TextStyle(color: hintColor)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conv = _conversations[index];
        final otherUser = conv['Users'][0]; // Lấy user đầu tiên (tạm thời)
        final lastMsg = conv['Messages'] != null && conv['Messages'].isNotEmpty ? conv['Messages'][0]['text'] : 'No messages yet';
        
        return _buildChatItem(
          context,
          id: conv['id'].toString(),
          name: otherUser['name'],
          message: lastMsg,
          time: 'Today',
          avatar: otherUser['avatar'] ?? 'https://picsum.photos/seed/${otherUser['id']}/150',
        );
      },
    );
  }

  Widget _buildChatItem(BuildContext context, {required String id, required String name, required String message, required String time, required String avatar}) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailScreen(conversationId: id, name: name, avatar: avatar))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            CircleAvatar(radius: 25, backgroundImage: NetworkImage(avatar)),
            const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 5), Text(message, style: const TextStyle(color: hintColor, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)])),
            Text(time, style: const TextStyle(color: hintColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
