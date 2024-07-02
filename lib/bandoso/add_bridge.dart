import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddBridgeScreen extends StatefulWidget {
  const AddBridgeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddBridgeScreenState createState() => _AddBridgeScreenState();
}

class _AddBridgeScreenState extends State<AddBridgeScreen> {
  // ignore: non_constant_identifier_names
  final _FidController = TextEditingController();
  final chieuDaiController = TextEditingController();
  final _diaDanhController = TextEditingController();
  final _lotuyenController = TextEditingController();
  final _lyTrinhController = TextEditingController();
  final _maDoiTuongController = TextEditingController();
  final _tenCauController = TextEditingController();
  final _tenSongController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('features');

  void _saveBridge() {
    if (_validateInputs()) {
      final newBridge = {
        'geometry': {
          'coordinates': [
            double.parse(_longitudeController.text),
            double.parse(_latitudeController.text)
          ],
          'type': 'Point',
        },
        'id': int.parse(_FidController.text),
        'properties': {
          'FID': int.parse(_FidController.text),
          'chieuDai': chieuDaiController.text,
          'diaDanh': _diaDanhController.text,
          'lo_tuyen': _lotuyenController.text,
          'lyTrinh': _lyTrinhController.text,
          'maDoiTuong': int.parse(_maDoiTuongController.text),
          'tenCau': _tenCauController.text,
          'tenSong': _tenSongController.text,
        },
        'type': 'Feature',
      };

      _databaseRef.push().set(newBridge).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bridge added successfully!')));
        _clearForm();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add bridge: $error')));
      });
    }
  }

  bool _validateInputs() {
    try {
      int.parse(_FidController.text);
      double.parse(_longitudeController.text);
      double.parse(_latitudeController.text);
      int.parse(_maDoiTuongController.text);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid numbers in the FID, Longitude, Latitude, and Ma Doi Tuong fields.')));
      return false;
    }
  }

  void _clearForm() {
    _FidController.clear();
    chieuDaiController.clear();
    _diaDanhController.clear();
    _lotuyenController.clear();
    _lyTrinhController.clear();
    _maDoiTuongController.clear();
    _tenCauController.clear();
    _tenSongController.clear();
    _longitudeController.clear();
    _latitudeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Bridge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _FidController,
                decoration: const InputDecoration(labelText: 'FID'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: chieuDaiController,
                decoration: const InputDecoration(labelText: 'Chiều dài'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _diaDanhController,
                decoration: const InputDecoration(labelText: 'Địa danh'),
              ),
              TextField(
                controller: _lotuyenController,
                decoration: const InputDecoration(labelText: 'Lộ tuyến'),
              ),
              TextField(
                controller: _lyTrinhController,
                decoration: const InputDecoration(labelText: 'Lý trình'),
              ),
              TextField(
                controller: _maDoiTuongController,
                decoration: const InputDecoration(labelText: 'Mã đối tượng'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _tenCauController,
                decoration: const InputDecoration(labelText: 'Tên cầu'),
              ),
              TextField(
                controller: _tenSongController,
                decoration: const InputDecoration(labelText: 'Tên sông'),
              ),
              TextField(
                controller: _longitudeController,
                decoration: const InputDecoration(labelText: 'Kinh độ'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _latitudeController,
                decoration: const InputDecoration(labelText: 'Vĩ độ'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBridge,
                child: const Text('Add Bridge'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _FidController.dispose();
    chieuDaiController.dispose();
    _diaDanhController.dispose();
    _lotuyenController.dispose();
    _lyTrinhController.dispose();
    _maDoiTuongController.dispose();
    _tenCauController.dispose();
    _tenSongController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    super.dispose();
  }
}