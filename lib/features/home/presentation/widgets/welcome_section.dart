import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: Colors.red),
        Column(
          children: [
            Text('Welcome, '),
            Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.grey.shade500,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
