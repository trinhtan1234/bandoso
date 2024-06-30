import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddMarker extends StatefulWidget {
  const AddMarker(data, int i, {super.key});

  @override
  State<AddMarker> createState() => _AddMarkerState();
}

class _AddMarkerState extends State<AddMarker> {
  final DatabaseReference _cau =
      FirebaseDatabase.instance.ref().child('features');
  final tenCauController = TextEditingController();
  final tenSongController = TextEditingController();
  final lyTrinhController = TextEditingController();
  final loTuyenController = TextEditingController();
  final diaDanhController = TextEditingController();
  final chieuDaiController = TextEditingController();
  final viDoController = TextEditingController();
  final kinhDoController = TextEditingController();
  final maDoiTuongController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm cầu'),
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
            TextField(
              controller: maDoiTuongController,
              decoration: const InputDecoration(labelText: 'Mã đối tượng'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addBridge,
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  void _addBridge() {
    final newBridge = {
      'geometry': {
        'type': 'Point',
        'coordinates': [
          double.parse(kinhDoController.text),
          double.parse(viDoController.text)
        ],
      },
      'id': int.parse(maDoiTuongController.text),
      'properties': {
        'FID': int.parse(maDoiTuongController.text),
        'chieuDai': chieuDaiController.text,
        'diaDanh': diaDanhController.text,
        'lo_tuyen': loTuyenController.text,
        'lyTrinh': lyTrinhController.text,
        'maDoiTuong': maDoiTuongController.text,
        'tenCau': tenCauController.text,
        'tenSong': tenSongController.text,
        'type': 'Feature'
      },
    };

    _cau.push().set(newBridge).then((_) {
      Navigator.of(context).pop();
    }).catchError((error) {
      // print('Failed to add bridge: $error');
    });
  }
}
