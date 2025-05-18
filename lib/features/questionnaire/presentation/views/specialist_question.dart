import 'package:flutter/material.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/checkbox_option.dart';
import '../widgets/question_page.dart';
import 'medical_contraindications_question.dart';

class SpecialistQuestion extends StatefulWidget {
  final QuestionnaireCubit questionnaireCubit;

  const SpecialistQuestion({super.key, required this.questionnaireCubit});

  @override
  State<SpecialistQuestion> createState() => _SpecialistQuestionState();
}

class _SpecialistQuestionState extends State<SpecialistQuestion> {
  final Set<String> selectedSpecialists = {};

  void _onNext() {
    // Use widget.questionnaireCubit instead of context.read
    widget.questionnaireCubit.updateSpecialists(selectedSpecialists.toList());

    // Pass the cubit to the next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MedicalContraindicationsQuestion(
              questionnaireCubit: widget.questionnaireCubit,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText:
          "Is your baby currently under care of a physical therapist or specialist?",
      onNext: _onNext,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxOption(
              text: "Physical Therapist",
              isSelected: selectedSpecialists.contains("Physical Therapist"),
              onChanged: (selected) {
                setState(() {
                  if (selected) {
                    selectedSpecialists.add("Physical Therapist");
                  } else {
                    selectedSpecialists.remove("Physical Therapist");
                  }
                });
              },
            ),
            CheckboxOption(
              text: "Specialist",
              isSelected: selectedSpecialists.contains("Specialist"),
              onChanged: (selected) {
                setState(() {
                  if (selected) {
                    selectedSpecialists.add("Specialist");
                  } else {
                    selectedSpecialists.remove("Specialist");
                  }
                });
              },
            ),
            const SizedBox(height: 20), // Extra padding at the bottom
          ],
        ),
      ),
    );
  }
}
