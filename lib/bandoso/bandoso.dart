import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';


class BanDoSo extends StatefulWidget {
  const BanDoSo({super.key});

  @override
  State<BanDoSo> createState() => _BanDoSoState();
}

class _BanDoSoState extends State<BanDoSo> {
  LatLng? center;
  Position? _currentPosition;
  late Position position;
  String long = "";
  String lat = "";

  final List<Marker> _markers = [];
  List<Marker> _filteredMarkers = [];
  final DatabaseReference _cau =
      FirebaseDatabase.instance.ref().child('features');
  int _selectedIndex = -1;
  final List<Map<String, dynamic>> _layers = [
    {'name': 'Cầu', 'isChecked': true},
    {'name': 'Cột km', 'isChecked': false},
    {'name': 'Cột h', 'isChecked': false},
    {'name': 'Biển báo', 'isChecked': false},
    {'name': 'Biển báo', 'isChecked': false},
    {'name': 'Biển báo', 'isChecked': false},
    {'name': 'Biển báo', 'isChecked': false},
    {'name': 'Biển báo', 'isChecked': false},
    {'name': 'Biển báo', 'isChecked': false},
    {'name': 'Biển báo', 'isChecked': false},
    {'name': 'Biển báo', 'isChecked': false},
    {'name': 'Biển báo', 'isChecked': false},
  ];

  @override
  void initState() {
    _loadMarkers();
    _requestLocationPermission();
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
              initialCenter: LatLng(19.78207088297697, 105.00311687432979),
              initialZoom: 9,
              
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              if (_layers.any((layer) => layer['isChecked']))
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
              child: Column(
                children: [
                  TextField(
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
                ],
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 20,
            right: 20,
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _layers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _layers[index]['isChecked'] =
                            !_layers[index]['isChecked'];
                        _selectedIndex = index; // Update selected index
                        _filterMarkers('');
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: _selectedIndex == index
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _layers[index]['isChecked'],
                            onChanged: (bool? value) {
                              setState(() {
                                _layers[index]['isChecked'] = value ?? false;
                                _selectedIndex = index; // Update selected index
                                _filterMarkers('');
                              });
                            },
                          ),
                          Text(
                            _layers[index]['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
        ],
      ),
    );
  }

  Future<void> _loadMarkers() async {
    _cau.get().then((DataSnapshot snapshot) {
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
              width: 300.0,
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
                                color: Colors.deepPurple,
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

  // Location GPS

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.denied) {
      _showLocationPermissionDeniedDialog();
    } else if (status == PermissionStatus.permanentlyDenied) {
      _showLocationPermissionPermanentlyDeniedDialog();
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _showLocationPermissionDeniedDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quyền truy cập vị trí bị từ chối'),
          content: const Text(
              'Vui lòng cho phép ứng dụng truy cập vị trí trong cài đặt.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLocationPermissionPermanentlyDeniedDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quyền truy cập vị trí bị từ chối vĩnh viễn'),
          content: const Text(
              'Vui lòng mở cài đặt ứng dụng và cấp quyền truy cập vị trí.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    final LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      _showLocationPermissionDeniedDialog();
    } else {
      _currentPosition = (await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      )) as Position?;
      if (_currentPosition != null) {
        setState(() {
          center =
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
        });
      }
    }
  }

//Thêm cầu
  // void _onBridgeAdded(DatabaseEvent event) {
  //   final bridge = event.snapshot.value as Map<dynamic, dynamic>;
  //   final coordinates = bridge['geometry']['coordinates'];
  //   final properties = bridge['properties'];

  //   setState(() {
  //     _markers.add(Marker(
  //       point: LatLng(coordinates[1], coordinates[0]),
  //       child: const Icon(Icons.location_on, color: Colors.blue),
  //       width: 80,
  //       height: 80,
  //     ));
  //   });
  // }
}
