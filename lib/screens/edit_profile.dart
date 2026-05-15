import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants.dart';
import '../core/widgets.dart';
import '../core/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  String? _avatarUrl;
  bool _isLoading = false;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() => _isLoading = true);
      try {
        final bytes = await image.readAsBytes();
        final url = await ApiService.uploadFile(bytes, image.name);
        setState(() {
          _avatarUrl = url;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        _showSnackBar(e.toString());
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      await ApiService.updateProfile({
        'name': _nameController.text,
        'location': _locationController.text,
        if (_avatarUrl != null) 'avatar': _avatarUrl,
      });
      if (mounted) {
        Navigator.pop(context);
        _showSnackBar('Cập nhật thành công!');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar(e.toString());
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: const Text('SAVE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _avatarUrl != null 
                              ? NetworkImage(_avatarUrl!) 
                              : const NetworkImage('https://picsum.photos/seed/profile/150'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    labelText: 'Full Name',
                    hintText: 'Enter your name',
                    controller: _nameController,
                  ),
                  CustomTextField(
                    labelText: 'Location',
                    hintText: 'Enter your location',
                    controller: _locationController,
                  ),
                ],
              ),
            ),
    );
  }
}
