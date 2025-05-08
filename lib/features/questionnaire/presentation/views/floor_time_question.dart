import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/question_page.dart';
import '../widgets/option_button.dart';
import 'container_time_question.dart';

class FloorTimeQuestion extends StatefulWidget {
  const FloorTimeQuestion({super.key});

  @override
  State<FloorTimeQuestion> createState() => _FloorTimeQuestionState();
}

class _FloorTimeQuestionState extends State<FloorTimeQuestion> {
  String? selectedTime;

  final List<String> timeOptions = [
    'Less than 15 min',
    '15-30 min daily',
    '30-60 min',
    'Over 1 hour',
  ];

  void _onNext() {
    if (selectedTime != null) {
      context.read<QuestionnaireCubit>().updateFloorTime(selectedTime!);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContainerTimeQuestion()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText:
          "How much time does your baby spend on the floor daily (awake)?",
      onNext: _onNext,
      showNextButton: selectedTime != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            timeOptions.map((option) {
              return OptionButton(
                text: option,
                isSelected: selectedTime == option,
                onTap: () {
                  setState(() {
                    selectedTime = option;
                  });
                  _onNext();
                },
              );
            }).toList(),
      ),
    );
  }
}
