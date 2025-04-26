import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String subtitleThree;
  final String subtitletwo;
  final int pageNumber;

  const OnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitleThree,
    required this.subtitletwo,
    required this.subtitle,
    required this.pageNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          ),
          // Apply a dark overlay to improve text readability
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                // Title with shadow for better readability
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle with box decoration for better readability
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.start,

                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xffc4c2c2),
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.start,
                        subtitletwo,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xffc4c2c2),
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.start,
                        subtitleThree,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xffc4c2c2),
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Add some space at the bottom
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
