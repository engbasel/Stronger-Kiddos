import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/services/firebase_auth_service.dart';
import 'package:strongerkiddos/core/services/get_it_service.dart';
import 'package:strongerkiddos/core/utils/app_text_style.dart';
import 'package:strongerkiddos/features/auth/presentation/views/login_view.dart';
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

          const Spacer(),

          // Logout Button
          _buildLogoutButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(color: Colors.red.shade300, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          await _authService.signOut();
          if (!context.mounted) return;
          Navigator.pushReplacementNamed(context, LoginView.routeName);
        },
        child: Text(
          'Logout',
          style: TextStyles.bold16.copyWith(color: Colors.red.shade700),
        ),
      ),
    );
  }
}
