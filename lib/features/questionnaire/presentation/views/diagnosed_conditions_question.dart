import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/question_page.dart';
import '../widgets/checkbox_option.dart';
import 'specialist_question.dart';

class DiagnosedConditionsQuestion extends StatefulWidget {
  const DiagnosedConditionsQuestion({super.key});

  @override
  State<DiagnosedConditionsQuestion> createState() =>
      _DiagnosedConditionsQuestionState();
}

class _DiagnosedConditionsQuestionState
    extends State<DiagnosedConditionsQuestion> {
  final List<String> conditions = [
    'Torticollis',
    'Down syndrome',
    'CP',
    'Plagiocephaly',
    'Developmental Delay',
    'None',
    'Other',
  ];

  final Set<String> selectedConditions = {};
  final TextEditingController _otherController = TextEditingController();
  bool showOtherField = false;

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _onNext() {
    final List<String> finalConditions = List.from(selectedConditions);

    // Add "Other" text if provided
    if (showOtherField && _otherController.text.isNotEmpty) {
      finalConditions.add('Other: ${_otherController.text.trim()}');
    }

    context.read<QuestionnaireCubit>().updateDiagnosedConditions(
      finalConditions,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SpecialistQuestion()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText: "Does your baby have any diagnosed conditions?",
      onNext: _onNext,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...conditions.map((condition) {
              return CheckboxOption(
                text: condition,
                isSelected: selectedConditions.contains(condition),
                onChanged: (selected) {
                  setState(() {
                    if (condition == 'None') {
                      // If "None" is selected, clear all other selections
                      if (selected) {
                        selectedConditions.clear();
                        selectedConditions.add('None');
                        showOtherField = false;
                      } else {
                        selectedConditions.remove('None');
                      }
                    } else if (condition == 'Other') {
                      if (selected) {
                        selectedConditions.add(condition);
                        showOtherField = true;
                        // Remove "None" if "Other" is selected
                        selectedConditions.remove('None');
                      } else {
                        selectedConditions.remove(condition);
                        showOtherField = false;
                      }
                    } else {
                      if (selected) {
                        selectedConditions.add(condition);
                        // Remove "None" if any condition is selected
                        selectedConditions.remove('None');
                      } else {
                        selectedConditions.remove(condition);
                      }
                    }
                  });
                },
              );
            }),

            if (showOtherField) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _otherController,
                decoration: InputDecoration(
                  hintText: "Please specify",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
