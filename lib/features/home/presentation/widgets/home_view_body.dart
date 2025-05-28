import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/services/firebase_auth_service.dart';
import 'package:strongerkiddos/core/services/get_it_service.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/new_to_app_card_section.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/search_bar_section.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/welcome_section.dart';
import 'package:strongerkiddos/features/questionnaire/domain/repos/questionnaire_repo.dart';

import '../../../questionnaire/domain/entities/questionnaire_entity.dart';
import 'personalized_content_section.dart';

class HomeviewBody extends StatefulWidget {
  const HomeviewBody({super.key});

  @override
  State<HomeviewBody> createState() => _HomeviewBodyState();
}

class _HomeviewBodyState extends State<HomeviewBody> {
  final FirebaseAuthService _authService = getIt<FirebaseAuthService>();
  final QuestionnaireRepo _questionnaireRepo = getIt<QuestionnaireRepo>();
  bool _isLoading = true;
  QuestionnaireEntity? _questionnaireData;

  @override
  void initState() {
    super.initState();
    _loadQuestionnaireData();
  }

  Future<void> _loadQuestionnaireData() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      final result = await _questionnaireRepo.getQuestionnaireData(
        userId: userId,
      );
      result.fold(
        (failure) {
          // Handle error - data not found
          setState(() {
            _isLoading = false;
          });
        },
        (data) {
          setState(() {
            _questionnaireData = data;
            _isLoading = false;
          });
        },
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          WelcomeSection(childName: _questionnaireData?.childName),

          // Search Bar Section
          const SearchBarSection(),

          const SizedBox(height: 16),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_questionnaireData != null)
            // Personalized content based on questionnaire data
            PersonalizedContentSection(questionnaireData: _questionnaireData!)
          else
            // Default content for users who haven't completed the questionnaire
            const NewToAppCardSection(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }


}
