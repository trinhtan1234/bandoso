// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'dangnhaptaikhoan.dart';

// class ManHinhDangKy extends StatefulWidget {
//   const ManHinhDangKy({super.key});

//   @override
//   State<ManHinhDangKy> createState() => _ManHinhDangKyState();
// }

// class _ManHinhDangKyState extends State<ManHinhDangKy> {
//   final _formKey = GlobalKey<FormState>();
//   final List<String> scopes = <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ];

//   final TextEditingController _userNameController = TextEditingController();

//   final TextEditingController _passwordController = TextEditingController();

//   final TextEditingController _reppasswordController = TextEditingController();

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Đăng ký tài khoản',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.deepPurple,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: SafeArea(
//             child: Column(
//               children: [
//                 const Padding(padding: EdgeInsets.only(top: 100)),
//                 SizedBox(
//                   width: 300,
//                   height: 50,
//                   child: TextFormField(
//                     controller: _userNameController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       hintText: 'Email',
//                       prefixIcon: const Icon(Icons.search),
//                     ),
//                   ),
//                 ),
//                 const Padding(padding: EdgeInsets.only(top: 10)),
//                 // ignore: sized_box_for_whitespace
//                 Container(
//                   width: 300,
//                   height: 50,
//                   child: TextFormField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       hintText: 'Mật khẩu',
//                       prefixIcon: const Icon(Icons.password),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Vui lòng nhập email";
//                       }
//                       if (value.contains('@')) {
//                         return "email không hợp lệ";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//                 const Padding(padding: EdgeInsets.only(top: 10)),

//                 SizedBox(
//                   width: 300,
//                   height: 50,
//                   child: TextFormField(
//                     controller: _reppasswordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       hintText: 'Nhập lại mật khẩu',
//                       prefixIcon: const Icon(Icons.password),
//                     ),
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Vui lòng nhập mật khẩu";
//                       }
//                       if (value.length < 6) {
//                         return "Mật khẩu phải có ít nhất 6 ký tự";
//                       }
//                       return null;
//                     },
//                   ),
//                 ),

//                 const Padding(padding: EdgeInsets.only(top: 10)),
//                 TextButton(
//                   onPressed: () {},
//                   child: Center(
//                     child: Container(
//                       // margin: const EdgeInsets.all(20),
//                       height: 50,
//                       width: 300,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.black),
//                       ),
//                       child: Center(
//                           child: TextButton(
//                         onPressed: () async {
//                           // print('Đăng ký');

//                           try {
//                             // ignore: unused_local_variable
//                             final res =
//                                 await _auth.createUserWithEmailAndPassword(
//                                     email: _userNameController.text,
//                                     password: _passwordController.text);
//                             // print(res);

//                             Navigator.push(
//                               // ignore: use_build_context_synchronously
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       const LoginScreen()),
//                             );
//                           } catch (error) {
//                             // print(error);
//                           }
//                         },
//                         child: const Text(
//                           'Đăng ký',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                       )),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
