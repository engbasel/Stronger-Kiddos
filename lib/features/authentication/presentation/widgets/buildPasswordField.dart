// import 'package:flutter/material.dart';

// Widget buildPasswordField() {
//   final FocusNode _focusNode = FocusNode();

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Text(
//         'Password',
//         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//       ),
//       const SizedBox(height: 8),
//       TextField(
//         controller: _passwordController,
//         obscureText: _obscureText,
//         focusNode: _focusNode,
//         decoration: InputDecoration(
//           hintText: '••••••••••••',
//           hintStyle: TextStyle(color: Colors.grey.shade400),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 12,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.grey.shade300),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Color(0xFF4B5768)),
//           ),
//           suffixIcon: IconButton(
//             icon: Icon(
//               _obscureText
//                   ? Icons.visibility_outlined
//                   : Icons.visibility_off_outlined,
//               color: Colors.grey,
//             ),
//             onPressed: () {
//               setState(() {
//                 _obscureText = !_obscureText;
//               });
//             },
//           ),
//         ),
//       ),
//     ],
//   );
// }
