import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/option_button.dart';
import '../widgets/question_page.dart';
import 'premature_question.dart';

class GenderQuestion extends StatefulWidget {
  const GenderQuestion({super.key});

  @override
  State<GenderQuestion> createState() => _GenderQuestionState();
}

class _GenderQuestionState extends State<GenderQuestion> {
  String? selectedGender;

  void _onNext() {
    if (selectedGender != null) {
      context.read<QuestionnaireCubit>().updateGender(selectedGender!);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PrematureQuestion()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText: "What is your baby gender?",
      onNext: _onNext,
      showNextButton: selectedGender != null,
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
              _onNext();
            },
          ),
          OptionButton(
            text: "Female",
            isSelected: selectedGender == "Female",
            onTap: () {
              setState(() {
                selectedGender = "Female";
              });
              _onNext();
            },
          ),
        ],
      ),
    );
  }
}
