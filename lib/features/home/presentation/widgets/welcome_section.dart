// lib/features/home/presentation/widgets/welcome_section.dart
import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  final String? childName;

  const WelcomeSection({super.key, this.childName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/images/png/profieminage.png'),
        ),
        SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, Welcome  🎉'),
            Text(
              childName != null ? '$childName\'s Parent' : 'Parent',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
