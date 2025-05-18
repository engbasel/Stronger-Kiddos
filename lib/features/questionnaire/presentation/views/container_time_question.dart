import 'package:flutter/material.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/option_button.dart';
import '../widgets/question_page.dart';
import 'concern_areas_question.dart';

class ContainerTimeQuestion extends StatefulWidget {
  final QuestionnaireCubit questionnaireCubit;

  const ContainerTimeQuestion({super.key, required this.questionnaireCubit});

  @override
  State<ContainerTimeQuestion> createState() => _ContainerTimeQuestionState();
}

class _ContainerTimeQuestionState extends State<ContainerTimeQuestion> {
  String? selectedTime;

  final List<String> timeOptions = ['Minimal', '1-2 hrs/day', '3+ hrs/day'];

  void _onNext() {
    if (selectedTime != null) {
      // Use widget.questionnaireCubit instead of context.read
      widget.questionnaireCubit.updateContainerTime(selectedTime!);

      // Pass the cubit to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ConcernAreasQuestion(
                questionnaireCubit: widget.questionnaireCubit,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText:
          "How much time does your baby spend in containers (swings, car seats, bouncers)?",
      onNext: _onNext,
      showNextButton: selectedTime != null,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...timeOptions.map((option) {
              return OptionButton(
                text: option,
                isSelected: selectedTime == option,
                onTap: () {
                  setState(() {
                    selectedTime = option;
                  });
                  // Remove auto-navigation
                  // _onNext();
                },
              );
            }),
            const SizedBox(height: 20), // Extra padding at the bottom
          ],
        ),
      ),
    );
  }
}
