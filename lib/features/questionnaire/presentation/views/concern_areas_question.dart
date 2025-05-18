import 'package:flutter/material.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/checkbox_option.dart';
import '../widgets/question_page.dart';

class ConcernAreasQuestion extends StatefulWidget {
  final QuestionnaireCubit questionnaireCubit;

  const ConcernAreasQuestion({super.key, required this.questionnaireCubit});

  @override
  State<ConcernAreasQuestion> createState() => _ConcernAreasQuestionState();
}

class _ConcernAreasQuestionState extends State<ConcernAreasQuestion> {
  final List<String> concernOptions = [
    'Tummy Time',
    'Torticollis Flat Head / Plagiocephaly',
    'Rolling',
    'Sitting',
    'Crawling',
    'Standing / Cruising / Walking',
    'My baby seems behind overall',
    'I\'m not sure – I want a general check',
  ];

  final Set<String> selectedConcerns = {};

  void _onNext() {
    // Use widget.questionnaireCubit instead of context.read
    widget.questionnaireCubit.updateConcernAreas(selectedConcerns.toList());

    // Submit the questionnaire using the widget's cubit
    widget.questionnaireCubit.submitQuestionnaire(context);
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText: "What milestone or concern would you like help with today?",
      onNext: _onNext,
      isLastQuestion: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...concernOptions.map((option) {
              return CheckboxOption(
                text: option,
                isSelected: selectedConcerns.contains(option),
                onChanged: (selected) {
                  setState(() {
                    if (selected) {
                      selectedConcerns.add(option);
                    } else {
                      selectedConcerns.remove(option);
                    }
                  });
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
