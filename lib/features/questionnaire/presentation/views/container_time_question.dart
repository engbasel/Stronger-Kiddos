import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/option_button.dart';
import '../widgets/question_page.dart';
import 'concern_areas_question.dart';

class ContainerTimeQuestion extends StatefulWidget {
  const ContainerTimeQuestion({super.key});

  @override
  State<ContainerTimeQuestion> createState() => _ContainerTimeQuestionState();
}

class _ContainerTimeQuestionState extends State<ContainerTimeQuestion> {
  String? selectedTime;

  final List<String> timeOptions = ['Minimal', '1-2 hrs/day', '3+ hrs/day'];

  void _onNext() {
    if (selectedTime != null) {
      context.read<QuestionnaireCubit>().updateContainerTime(selectedTime!);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConcernAreasQuestion()),
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
