import 'package:flutter/material.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/option_button.dart';
import '../widgets/question_page.dart';
import 'premature_question.dart';

class GenderQuestion extends StatefulWidget {
  final QuestionnaireCubit questionnaireCubit;

  const GenderQuestion({super.key, required this.questionnaireCubit});

  @override
  State<GenderQuestion> createState() => _GenderQuestionState();
}

class _GenderQuestionState extends State<GenderQuestion> {
  String? selectedGender;

  void _onNext() {
    if (selectedGender != null) {
      // Update gender using the passed cubit
      widget.questionnaireCubit.updateGender(selectedGender!);

      // Navigate to the next screen and pass the same cubit instance
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PrematureQuestion(
                questionnaireCubit: widget.questionnaireCubit,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText: "What is your baby gender?",
      onNext: _onNext,
      showNextButton: selectedGender != null,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your baby gender impacts the baby metrics - we use this data to provide content tailored to you.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            OptionButton(
              text: "Male",
              isSelected: selectedGender == "Male",
              onTap: () {
                setState(() {
                  selectedGender = "Male";
                });
                // No auto-navigation
              },
            ),
            OptionButton(
              text: "Female",
              isSelected: selectedGender == "Female",
              onTap: () {
                setState(() {
                  selectedGender = "Female";
                });
                // No auto-navigation
              },
            ),
            const SizedBox(height: 20), // Extra padding at the bottom
          ],
        ),
      ),
    );
  }
}
