// lib/features/questionnaire/presentation/views/concern_areas_question.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/checkbox_option.dart';
import '../widgets/question_page.dart';

class ConcernAreasQuestion extends StatefulWidget {
  const ConcernAreasQuestion({super.key});

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
    context.read<QuestionnaireCubit>().updateConcernAreas(
      selectedConcerns.toList(),
    );
    context.read<QuestionnaireCubit>().submitQuestionnaire(context);
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
          children:
              concernOptions.map((option) {
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
              }).toList(),
        ),
      ),
    );
  }
}
