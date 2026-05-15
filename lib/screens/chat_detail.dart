import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/api_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  final String name;
  final String avatar;

  const ChatDetailScreen({super.key, required this.conversationId, required this.name, required this.avatar});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final data = await ApiService.getMessages(widget.conversationId);
      if (mounted) {
        setState(() {
          _messages = data;
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    try {
      await ApiService.sendMessage(widget.conversationId, text);
      _fetchMessages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: textColor), onPressed: () => Navigator.pop(context)),
        title: Row(children: [CircleAvatar(radius: 16, backgroundImage: NetworkImage(widget.avatar)), const SizedBox(width: 10), Text(widget.name, style: const TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold))]),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: primaryColor))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      // Backend trả về senderId, cần so sánh với userId của mình (tạm thời giả định isMe dựa trên logic backend)
                      // Để chính xác hơn cần lưu userId khi đăng nhập vào SharedPreferences
                      bool isMe = msg['senderId'] != null; // Logic tạm thời
                      return _buildMessageItem(msg['text'], isMe);
                    },
                  ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(String text, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) CircleAvatar(radius: 15, backgroundImage: NetworkImage(widget.avatar)),
          if (!isMe) const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? Colors.white : primaryColor,
                border: isMe ? Border.all(color: Colors.grey.shade300) : null,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(text, style: TextStyle(color: isMe ? textColor : Colors.white, fontSize: 14)),
            ),
          ),
          if (isMe) const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)), child: TextField(controller: _messageController, decoration: const InputDecoration(hintText: 'Type message', border: InputBorder.none)))),
            const SizedBox(width: 15),
            GestureDetector(onTap: _sendMessage, child: Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle), child: const Icon(Icons.send, color: Colors.white, size: 18))),
          ],
        ),
      ),
    );
  }
}
