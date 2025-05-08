import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/checkbox_option.dart';
import '../widgets/question_page.dart';
import 'medical_contraindications_question.dart';

class SpecialistQuestion extends StatefulWidget {
  const SpecialistQuestion({super.key});

  @override
  State<SpecialistQuestion> createState() => _SpecialistQuestionState();
}

class _SpecialistQuestionState extends State<SpecialistQuestion> {
  final Set<String> selectedSpecialists = {};

  void _onNext() {
    context.read<QuestionnaireCubit>().updateSpecialists(
      selectedSpecialists.toList(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MedicalContraindicationsQuestion(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText:
          "Is your baby currently under care of a physical therapist or specialist?",
      onNext: _onNext,
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
        ],
      ),
    );
  }
}
