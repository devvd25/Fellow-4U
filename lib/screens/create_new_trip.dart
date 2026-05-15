import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/api_service.dart';

class CreateNewTripScreen extends StatefulWidget {
  const CreateNewTripScreen({super.key});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  int _travelerCount = 1;
  bool _isLoading = false;

  Future<void> _handleCreateTrip() async {
    if (_locationController.text.isEmpty || _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền địa điểm và ngày')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ApiService.createTrip({
        'title': 'Trip to ${_locationController.text}',
        'location': _locationController.text,
        'date': _dateController.text, // Backend mong đợi định dạng ISO hoặc chuỗi hợp lệ
        'time': _timeController.text,
        'travelers': _travelerCount,
      });
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tạo chuyến đi thành công!'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: textColor, size: 28), onPressed: () => Navigator.pop(context)),
        title: const Text('Create New Trip', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabeledTextField(label: 'Where you want to explore', hint: 'Danang, Vietnam', icon: Icons.location_on_outlined, controller: _locationController),
                  const SizedBox(height: 20),
                  _buildLabeledTextField(label: 'Date', hint: 'yyyy-mm-dd', icon: Icons.calendar_today_outlined, controller: _dateController),
                  const SizedBox(height: 20),
                  _buildLabeledTextField(label: 'Time', hint: '13:00 - 15:00', icon: Icons.access_time, controller: _timeController),
                  const SizedBox(height: 25),
                  const Text('Number of travelers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildCounterButton(Icons.arrow_drop_down, () { if (_travelerCount > 1) setState(() => _travelerCount--); }),
                      Container(width: 50, alignment: Alignment.center, decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))), child: Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('$_travelerCount', style: const TextStyle(fontSize: 16)))),
                      _buildCounterButton(Icons.arrow_drop_up, () { setState(() => _travelerCount++); }),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _handleCreateTrip, style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), child: const Text('DONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
    );
  }

  Widget _buildLabeledTextField({required String label, required String hint, required IconData icon, required TextEditingController controller}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)), TextField(controller: controller, decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: hintColor, size: 20), enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 0.5)), focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)), isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 10)))]);
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)), child: Icon(icon, color: primaryColor, size: 24)));
  }
}
