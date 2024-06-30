import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DeleteBridgeScreen extends StatefulWidget {
  final String bridgeKey;

  const DeleteBridgeScreen({required this.bridgeKey, super.key});

  @override
  State<DeleteBridgeScreen> createState() => _DeleteBridgeScreenState();
}

class _DeleteBridgeScreenState extends State<DeleteBridgeScreen> {
  final DatabaseReference _cau =
      FirebaseDatabase.instance.ref().child('features');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xóa cầu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text('Bạn có chắc chắn muốn xóa cầu này?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteBridge,
              child: const Text('Xóa'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteBridge() {
    _cau.child(widget.bridgeKey).remove().then((_) {
      Navigator.of(context).pop();
    });
  }
}
