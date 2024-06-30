import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditBridgeScreen extends StatefulWidget {
  final String bridgeKey;
  final Map<String, dynamic> bridgeData;

  const EditBridgeScreen(
      {required this.bridgeKey, required this.bridgeData, super.key});

  @override
  State<EditBridgeScreen> createState() => _EditBridgeScreenState();
}

class _EditBridgeScreenState extends State<EditBridgeScreen> {
  final DatabaseReference _cau =
      FirebaseDatabase.instance.ref().child('features');
  late TextEditingController tenCauController;
  late TextEditingController tenSongController;
  late TextEditingController lyTrinhController;
  late TextEditingController loTuyenController;
  late TextEditingController diaDanhController;
  late TextEditingController chieuDaiController;
  late TextEditingController viDoController;
  late TextEditingController kinhDoController;

  @override
  void initState() {
    super.initState();
    tenCauController = TextEditingController(text: widget.bridgeData['tenCau']);
    tenSongController =
        TextEditingController(text: widget.bridgeData['tenSong']);
    lyTrinhController =
        TextEditingController(text: widget.bridgeData['lyTrinh']);
    loTuyenController =
        TextEditingController(text: widget.bridgeData['loTuyen']);
    diaDanhController =
        TextEditingController(text: widget.bridgeData['diaDanh']);
    chieuDaiController =
        TextEditingController(text: widget.bridgeData['chieuDai']);
    viDoController =
        TextEditingController(text: widget.bridgeData['viDo'].toString());
    kinhDoController =
        TextEditingController(text: widget.bridgeData['kinhDo'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa cầu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: tenCauController,
              decoration: const InputDecoration(labelText: 'Tên cầu'),
            ),
            TextField(
              controller: tenSongController,
              decoration: const InputDecoration(labelText: 'Tên sông'),
            ),
            TextField(
              controller: lyTrinhController,
              decoration: const InputDecoration(labelText: 'Lý trình'),
            ),
            TextField(
              controller: loTuyenController,
              decoration: const InputDecoration(labelText: 'Lộ tuyến'),
            ),
            TextField(
              controller: diaDanhController,
              decoration: const InputDecoration(labelText: 'Địa danh'),
            ),
            TextField(
              controller: chieuDaiController,
              decoration: const InputDecoration(labelText: 'Chiều dài'),
            ),
            TextField(
              controller: viDoController,
              decoration: const InputDecoration(labelText: 'Vĩ độ'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: kinhDoController,
              decoration: const InputDecoration(labelText: 'Kinh độ'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateBridge,
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateBridge() {
    final updatedBridge = {
      'tenCau': tenCauController.text,
      'tenSong': tenSongController.text,
      'lyTrinh': lyTrinhController.text,
      'loTuyen': loTuyenController.text,
      'diaDanh': diaDanhController.text,
      'chieuDai': chieuDaiController.text,
      'viDo': double.parse(viDoController.text),
      'kinhDo': double.parse(kinhDoController.text),
    };
    _cau.child(widget.bridgeKey).update(updatedBridge).then((_) {
      Navigator.of(context).pop();
    });
  }
}
