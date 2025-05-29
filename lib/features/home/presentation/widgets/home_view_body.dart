import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/services/firebase_auth_service.dart';
import 'package:strongerkiddos/core/services/get_it_service.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/new_to_app_card_section.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/search_bar_section.dart';
import 'package:strongerkiddos/features/home/presentation/widgets/welcome_section.dart';
import '../../../questionnaires/domain/entities/baby_questionnaire_entity.dart';
import '../../../questionnaires/domain/repos/baby_questionnaire_repo.dart';
import 'baby_personalized_content_section.dart';

class HomeviewBody extends StatefulWidget {
  const HomeviewBody({super.key});

  @override
  State<HomeviewBody> createState() => _HomeviewBodyState();
}

class _HomeviewBodyState extends State<HomeviewBody> {
  final FirebaseAuthService _authService = getIt<FirebaseAuthService>();
  final BabyQuestionnaireRepo _questionnaireRepo =
      getIt<BabyQuestionnaireRepo>();
  bool _isLoading = true;
  BabyQuestionnaireEntity? _questionnaireData;

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
          WelcomeSection(childName: _questionnaireData?.babyName),
          const SearchBarSection(),
          const SizedBox(height: 16),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_questionnaireData != null)
            BabyPersonalizedContentSection(
              questionnaireData: _questionnaireData!,
            )
          else
            const NewToAppCardSection(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
