import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BanDoSo extends StatefulWidget {
  const BanDoSo({super.key});

  @override
  State<BanDoSo> createState() => _BanDoSoState();
}

class _BanDoSoState extends State<BanDoSo> {
  final List<Marker> _markers = [];
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('features');

  @override
  void initState() {
    _loadMarkers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(18.74055282323523, 105.48521581831663),
            initialZoom: 10,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayer(markers: _markers)
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.explore),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              onPressed: _hienThiThongTin,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loadMarkers() async {
    _databaseReference.get().then((DataSnapshot snapshot) {
      var data = snapshot.value;
      if (data is List) {
        for (var i = 0; i < data.length; i++) {
          _addMarker(data[i], i);
        }
      } else if (data is Map) {
        int index = 0;
        data.forEach((key, value) {
          _addMarker(value, index);
          index++;
        });
      }
    }).catchError((error) {
      print('Error loading markers: $error');
    });
  }

  void _addMarker(dynamic value, int index) {
    if (value == null) return;
    final geometry = value['geometry'];
    if (geometry == null) return;
    final coordinates = geometry['coordinates'];
    if (coordinates == null) return;
    final properties = value['properties'] ?? {};
    final LatLng position = LatLng(coordinates[1], coordinates[0]);
    final String tenCau = properties['tenCau'] ?? 'Unknown';
    final String tenSong = properties['tenSong'] ?? 'Unknown';
    final String lyTrinh = properties['lyTrinh'] ?? 'Unknown';
    final String loTuyen = properties['lo_tuyen'] ?? 'Unknown';
    final String diaDanh = properties['diaDanh'] ?? 'Unknown';
    final String chieuDai = properties['chieuDai'] ?? 'Unknown';

    setState(() {
      _markers.add(
        Marker(
          width: 150.0,
          height: 50.0,
          point: position,
          child: GestureDetector(
            onTap: () {
              _showBridgeInfoDialog(tenCau, tenSong, lyTrinh, loTuyen, diaDanh,
                  chieuDai, coordinates[1], coordinates[0]);
            },
            child: Container(
              width: 150.0,
              height: 50.0,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tenCau,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 40.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showBridgeInfoDialog(
      String tenCau,
      String tenSong,
      String lyTrinh,
      String loTuyen,
      String diaDanh,
      String chieuDai,
      double latitude,
      double longitude) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            tenCau,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          content: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Tên sông: $tenSong'),
                Text('Lý trình: $lyTrinh'),
                Text('Lộ tuyến: $loTuyen'),
                Text('Địa danh: $diaDanh'),
                Text('Chiều dài: $chieuDai'),
                Text('Vĩ độ: $latitude'),
                Text('Kinh độ: $longitude'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _hienThiThongTin(
                  tenCau: tenCau,
                  tenSong: tenSong,
                  lyTrinh: lyTrinh,
                  lotuyen: loTuyen,
                  diaDanh: diaDanh,
                  chieuDai: chieuDai,
                  latitude: latitude,
                  longitude: longitude,
                );
              },
              child: const Text('Sửa'),
            ),
          ],
        );
      },
    );
  }

  void _hienThiThongTin({
    String? tenCau,
    String? tenSong,
    String? lyTrinh,
    String? lotuyen,
    String? diaDanh,
    String? chieuDai,
    double? latitude,
    double? longitude,
  }) {
    final TextEditingController tenCauController =
        TextEditingController(text: tenCau);
    final TextEditingController tenSongController =
        TextEditingController(text: tenSong);
    final TextEditingController lyTrinhController =
        TextEditingController(text: lyTrinh);
    final TextEditingController loTuyencontroller =
        TextEditingController(text: lotuyen);
    final TextEditingController diaDanhController =
        TextEditingController(text: diaDanh);
    final TextEditingController chieuDaiController =
        TextEditingController(text: chieuDai);
    final TextEditingController latController =
        TextEditingController(text: latitude?.toString());
    final TextEditingController lngController =
        TextEditingController(text: longitude?.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sửa thông tin cầu'),
          content: SingleChildScrollView(
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
                  controller: loTuyencontroller,
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
                  controller: latController,
                  decoration: const InputDecoration(labelText: 'Kinh độ'),
                ),
                TextField(
                  controller: lngController,
                  decoration: const InputDecoration(labelText: 'Vĩ độ'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                _updateBridgeDetails(
                  tenCauController.text,
                  tenSongController.text,
                  lyTrinhController.text,
                  loTuyencontroller.text,
                  diaDanhController.text,
                  chieuDaiController.text,
                  double.parse(latController.text),
                  double.parse(lngController.text),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  void _updateBridgeDetails(
    String tenCau,
    String tenSong,
    String lyTrinh,
    String loTuyen,
    String diaDanh,
    String chieuDai,
    double lat,
    double lng,
  ) {
    _databaseReference.push().set({
      'geometry': {
        'coordinates': [0.0, 0.0],
      },
      'properties': {
        'tenCau': tenCau,
        'tenSong': tenSong,
        'lyTrinh': lyTrinh,
        'lo_tuyen': loTuyen,
        'diaDanh': diaDanh,
        'chieuDai': chieuDai,
      },
    }).then((_) {
      // Handle success if needed
    }).catchError((error) {
      print('Error updating bridge details: $error');
    });
  }
}
