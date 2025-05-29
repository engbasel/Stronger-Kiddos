import 'package:flutter/material.dart';

import '../../../questionnaires/domain/entities/baby_questionnaire_entity.dart';

class BabyPersonalizedContentSection extends StatelessWidget {
  final BabyQuestionnaireEntity questionnaireData;

  const BabyPersonalizedContentSection({
    super.key,
    required this.questionnaireData,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBabySummaryCard(),
            const SizedBox(height: 20),
            _buildRecommendedActivitiesSection(),
            const SizedBox(height: 20),
            _buildCareAreasCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildBabySummaryCard() {
    final age = DateTime.now().difference(questionnaireData.dateOfBirth).inDays;
    final ageInMonths = (age / 30).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (questionnaireData.babyPhotoUrl != null)
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    questionnaireData.babyPhotoUrl!,
                  ),
                )
              else
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange.withValues(alpha: .2),
                  child: Icon(
                    questionnaireData.gender == 'Boy' ? Icons.boy : Icons.girl,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${questionnaireData.babyName}'s Profile",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${questionnaireData.gender} • $ageInMonths months old",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileRow(
            icon: Icons.cake,
            label: "Born",
            value:
                "${questionnaireData.dateOfBirth.day}/${questionnaireData.dateOfBirth.month}/${questionnaireData.dateOfBirth.year}",
          ),
          if (questionnaireData.wasPremature &&
              questionnaireData.weeksPremature != null)
            _buildProfileRow(
              icon: Icons.access_time,
              label: "Premature",
              value: "${questionnaireData.weeksPremature} weeks early",
            ),
          _buildProfileRow(
            icon: Icons.schedule,
            label: "Floor Time",
            value: questionnaireData.floorTimeDaily,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.orange),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildRecommendedActivitiesSection() {
    final activities = _getRecommendedActivities();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommended Activities",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return _buildActivityCard(
                title: activities[index]['title'],
                description: activities[index]['description'],
                icon: activities[index]['icon'],
              );
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getRecommendedActivities() {
    final age = DateTime.now().difference(questionnaireData.dateOfBirth).inDays;
    final ageInMonths = (age / 30).round();
    final List<Map<String, dynamic>> activities = [];

    // Age-appropriate activities
    if (ageInMonths <= 3) {
      activities.add({
        'title': 'Tummy Time',
        'description': 'Start with short sessions to build neck strength',
        'icon': Icons.pregnant_woman,
      });
    } else if (ageInMonths <= 6) {
      activities.add({
        'title': 'Roll Practice',
        'description': 'Help your baby learn to roll front to back',
        'icon': Icons.rotate_90_degrees_ccw,
      });
    } else if (ageInMonths <= 9) {
      activities.add({
        'title': 'Sitting Practice',
        'description': 'Support your baby in sitting position',
        'icon': Icons.chair,
      });
    } else {
      activities.add({
        'title': 'Crawling Games',
        'description': 'Encourage movement with toys just out of reach',
        'icon': Icons.directions_walk,
      });
    }

    // Condition-specific activities
    if (questionnaireData.diagnosedConditions.contains('Torticollis')) {
      activities.add({
        'title': 'Neck Stretches',
        'description': 'Gentle stretches to improve neck mobility',
        'icon': Icons.fitness_center,
      });
    }

    if (questionnaireData.diagnosedConditions.contains('Plagiocephaly')) {
      activities.add({
        'title': 'Repositioning',
        'description': 'Techniques to prevent flat spots on the head',
        'icon': Icons.share_location,
      });
    }

    return activities;
  }

  Widget _buildActivityCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCareAreasCards() {
    if (questionnaireData.diagnosedConditions.isEmpty ||
        questionnaireData.diagnosedConditions.contains('None')) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Focus Areas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...questionnaireData.diagnosedConditions.take(3).map((condition) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: .1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: .1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getConditionIcon(condition),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        condition,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Tap to view activities and tips",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  IconData _getConditionIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'torticollis':
        return Icons.accessibility_new;
      case 'plagiocephaly':
        return Icons.child_care;
      case 'down syndrome':
        return Icons.favorite;
      case 'cp':
        return Icons.wheelchair_pickup;
      case 'developmental delay':
        return Icons.timeline;
      default:
        return Icons.medical_services;
    }
  }
}
