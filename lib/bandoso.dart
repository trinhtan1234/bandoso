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
  List<Marker> _filteredMarkers = [];
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('features');

  bool _showLopDuLieu = true;

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
    return Scaffold(
      body: Stack(
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
              if (_showLopDuLieu)
                MarkerLayer(
                  markers:
                      _filteredMarkers.isNotEmpty ? _filteredMarkers : _markers,
                )
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(30.0),
              child: TextField(
                onChanged: _filterMarkers,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm cầu...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.close),
                ),
              ),
            ),
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
            bottom: 200,
            right: 10,
            child: Container(
              // height: 200,
              // width: 200,
              color: Colors.cyanAccent,
              child: Column(
                children: [
                  const Text(
                    'Lớp dữ liệu không gian',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Checkbox(
                        value: _showLopDuLieu,
                        onChanged: (bool? value) {
                          setState(() {
                            _showLopDuLieu = value ?? true;
                          });
                        },
                      ),
                      const Text('Cầu')
                    ],
                  ),
                ],
              ),
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
      ),
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
      // print('Error loading markers: $error');
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
                  const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 20.0,
                  ),
                  Text(
                    tenCau,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Ensure text does not overflow
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _filterMarkers(String query) {
    setState(() {
      _filteredMarkers = _markers.where((marker) {
        final child = marker.child;
        if (child is GestureDetector) {
          final container = child.child;
          if (container is Container) {
            final column = container.child;
            if (column is Column) {
              if (column.children.length > 1) {
                final textWidget = column.children[1];
                if (textWidget is Text && textWidget.data != null) {
                  return textWidget.data!
                      .toLowerCase()
                      .contains(query.toLowerCase());
                }
              }
            }
          }
        }
        return false;
      }).toList();
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
    final TextEditingController loTuyenController =
        TextEditingController(text: lotuyen);
    final TextEditingController diaDanhController =
        TextEditingController(text: diaDanh);
    final TextEditingController chieuDaiController =
        TextEditingController(text: chieuDai);
    final TextEditingController viDoController =
        TextEditingController(text: latitude?.toString());
    final TextEditingController kinhDoController =
        TextEditingController(text: longitude?.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông tin cầu'),
          content: SingleChildScrollView(
            child: Column(
              children: [
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
                ),
                TextField(
                  controller: kinhDoController,
                  decoration: const InputDecoration(labelText: 'Kinh độ'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final index = _markers.indexWhere((marker) {
                    final child = marker.child;
                    if (child is GestureDetector) {
                      final container = child.child;
                      if (container is Container) {
                        final column = container.child;
                        if (column is Column) {
                          if (column.children.length > 1) {
                            final textWidget = column.children[1];
                            if (textWidget is Text &&
                                textWidget.data == tenCau) {
                              return true;
                            }
                          }
                        }
                      }
                    }
                    return false;
                  });
                  if (index != -1) {
                    final marker = _markers[index];
                    _markers[index] = Marker(
                      width: 150.0,
                      height: 50.0,
                      point: marker.point,
                      child: GestureDetector(
                        onTap: () {
                          _showBridgeInfoDialog(
                            tenCauController.text,
                            tenSongController.text,
                            lyTrinhController.text,
                            loTuyenController.text,
                            diaDanhController.text,
                            chieuDaiController.text,
                            double.parse(viDoController.text),
                            double.parse(kinhDoController.text),
                          );
                        },
                        child: Container(
                          width: 150.0,
                          height: 50.0,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 20.0,
                              ),
                              Text(
                                tenCauController.text,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}
