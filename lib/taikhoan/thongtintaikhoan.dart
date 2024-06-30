import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


import '../menu_home.dart';

class ThongTinTaiKhoan extends StatefulWidget {
  const ThongTinTaiKhoan({super.key});

  @override
  State<ThongTinTaiKhoan> createState() => _ThongTinTaiKhoanState();
}

class _ThongTinTaiKhoanState extends State<ThongTinTaiKhoan> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController imageUrlsController;

  final user = FirebaseAuth.instance.currentUser;

  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;
  List<Uint8List> pickedImagesInBytes = [];

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    imageUrlsController = TextEditingController();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';

      imageUrlsController.text = user.photoURL ?? '';
    }
    super.initState();
  }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _emailController.dispose();
  //   imageUrlsController.dispose();
  //   super.dispose();
  // }

  Future<void> _dangXuat() async {
    try {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MenuKhungApp(),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi đăng xuất: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin tài khoản'),
        actions: [
          IconButton(
            onPressed: _dangXuat,
            icon: const Row(
              children: [
                Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.red),
                ),
                Padding(padding: EdgeInsets.only(right: 5)),
                Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên tài khoản'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              children: [
                _buildImageCarousel(),
                if (_imageFile != null)
                  Image.file(
                    _imageFile!,
                    height: 100,
                    width: 100,
                  ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: imageUrlsController.text.isNotEmpty
                      ? Image.network(imageUrlsController.text)
                      : const Placeholder(),
                ),
                TextButton(
                  onPressed: _pickImage,
                  child: const Text('Thay ảnh'),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              onPressed: _uploadImageAndUpdateInfo,
              child: const Text('Cập Nhật Thông Tin'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    //check quyen truy cap thu vien
    await checkAndRequestPermission();
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> checkAndRequestPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      child: pickedImagesInBytes.isEmpty
          ? const Center(child: Text(''))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pickedImagesInBytes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: Image.memory(pickedImagesInBytes[index]),
                );
              },
            ),
    );
  }

  Future<void> _uploadImageAndUpdateInfo() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrlsController;
        // check if an image was picked
        if (_imageFile != null) {
          // Upload the image and get the Url
          imageUrlsController = await _uploadImageToStorage(_imageFile!);
        }

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updateDisplayName(_nameController.text);
          // await user.updateEmail(_emailController.text);

          if (imageUrlsController != null) {
            await user.updatePhotoURL(imageUrlsController);
          }

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MenuKhungApp()));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thông tin tài khoản được cập nhật'),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.message}')),
        );
      }
    }
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    final ref = FirebaseStorage.instance.ref().child('${user!.uid}.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
