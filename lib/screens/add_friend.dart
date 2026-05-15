import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/api_service.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final data = await ApiService.getUsers();
      if (mounted) {
        setState(() {
          _users = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: textColor), onPressed: () => Navigator.pop(context)),
        title: const Text('Add Friends', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('DONE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)))],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
                    child: Row(children: const [Icon(Icons.search, color: hintColor), SizedBox(width: 10), Expanded(child: TextField(decoration: InputDecoration(hintText: 'Search Friend', border: InputBorder.none)))]),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(radius: 25, backgroundImage: NetworkImage(user['avatar'] ?? 'https://picsum.photos/seed/${user['id']}/150')),
                        title: Text(user['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        trailing: Icon(Icons.person_add_alt_1, color: primaryColor),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
