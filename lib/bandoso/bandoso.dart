import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class BanDoSo extends StatefulWidget {
  const BanDoSo({super.key});

  @override
  State<BanDoSo> createState() => _BanDoSoState();
}

class _BanDoSoState extends State<BanDoSo> {
  final List<Marker> _markers = [];
  List<Marker> _filteredMarkers = [];
  DatabaseReference _cau = FirebaseDatabase.instance.ref().child('features'); // Initialize with default value
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
  int _selectedIndex = -1;

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
                tileProvider: CancellableNetworkTileProvider(),
              ),
              if (_layers.any((layer) => layer['isChecked']))
                MarkerLayer(
                  markers: _filteredMarkers.isNotEmpty ? _filteredMarkers : _markers,
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
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _filterMarkers('');
                    },
                  ),
                ),
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
                        _selectedIndex = index;
                        // Update _cau based on _selectedIndex
                        _cau = _getDatabaseReference(index);
                        _loadMarkers();
                        _filterMarkers('');
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: _selectedIndex == index ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.room_outlined,
                            ),
                            Text(
                              _layers[index]['name'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _selectedIndex == index ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
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
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.explore),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadMarkers() async {
    try {
      final snapshot = await _cau.get();
      var data = snapshot.value;
      _markers.clear(); // Clear existing markers before loading new ones
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
    } catch (error) {
      print('Error loading markers: $error');
    }
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

    setState(() {
      _markers.add(
        Marker(
          width: 150.0,
          height: 50.0,
          point: position,
          child:  GestureDetector(
            onTap: () {
              _showBridgeInfoDialog(properties); // Pass properties to dialog
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
                    overflow: TextOverflow.ellipsis,
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
          if (column is Column && column.children.length > 1) {
            final textWidget = column.children[1];
            if (textWidget is Text && textWidget.data != null) {
              // Check if marker should be visible based on filter and layer selection
              final bool shouldShow = _layers[_selectedIndex]['isChecked'] &&
                  textWidget.data!
                      .toLowerCase()
                      .contains(query.toLowerCase());
              return shouldShow;
            }
          }
        }
      }
      return false;
    }).toList();
  });
}


  void _showBridgeInfoDialog(Map<String, dynamic> properties) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            properties['tenCau'] ?? 'Unknown',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Tên sông: ${properties['tenSong'] ?? 'Unknown'}'),
                Text('Lý trình: ${properties['lyTrinh'] ?? 'Unknown'}'),
                Text('Lộ tuyến: ${properties['lo_tuyen'] ?? 'Unknown'}'),
                Text('Địa danh: ${properties['diaDanh'] ?? 'Unknown'}'),
                Text('Chiều dài: ${properties['chieuDai'] ?? 'Unknown'}'),
                Text('Vĩ độ: ${properties['coordinates']?[1] ?? 'Unknown'}'),
                Text('Kinh độ: ${properties['coordinates']?[0] ?? 'Unknown'}'),
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
                _editBridgeInfo(properties);
              },
              child: const Text('Sửa'),
            ),
          ],
        );
      },
    );
  }

  void _editBridgeInfo(Map<String, dynamic> properties) {
    // Implement editing functionality here
  }

  DatabaseReference _getDatabaseReference(int index) {
    switch (index) {
      case 0:
        return FirebaseDatabase.instance.ref().child('features');
      case 1:
        // Return appropriate DatabaseReference for other layers
        return FirebaseDatabase.instance.ref().child('other_layer');
      default:
        return FirebaseDatabase.instance.ref().child('default_layer');
    }
  }
}
