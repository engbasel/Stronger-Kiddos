import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/page_rout_builder.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../widgets/baby_question_page.dart';
import 'care_providers_page.dart';

class DiagnosedConditionsPage extends StatefulWidget {
  final BabyQuestionnaireCubit questionnaireCubit;

  const DiagnosedConditionsPage({super.key, required this.questionnaireCubit});

  @override
  State<DiagnosedConditionsPage> createState() =>
      _DiagnosedConditionsPageState();
}

class _DiagnosedConditionsPageState extends State<DiagnosedConditionsPage> {
  final Set<String> selectedConditions = {};
  final TextEditingController _otherController = TextEditingController();
  bool showOtherField = false;

  final List<String> conditions = [
    'Torticollis',
    'Down syndrome',
    'CP',
    'Plagiocephaly',
    'Developmental Delay',
    'None',
    'Other',
  ];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _onNext() {
    final List<String> finalConditions = List.from(selectedConditions);
    if (showOtherField && _otherController.text.isNotEmpty) {
      finalConditions.add('Other: ${_otherController.text.trim()}');
    }

    widget.questionnaireCubit.updateDiagnosedConditions(finalConditions);

    Navigator.push(
      context,
      buildPageRoute(
        CareProvidersPage(questionnaireCubit: widget.questionnaireCubit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BabyQuestionPageScaffold(
      questionText: "Does your baby have any diagnosed conditions?",
      onNext: _onNext,
      showNextButton: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            ...conditions.map((condition) {
              final isSelected = selectedConditions.contains(condition);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    _handleSelection(condition, !isSelected);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green.shade50 : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: AppColors.arcColor,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        condition,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color:
                              isSelected
                                  ? Colors.green.shade700
                                  : Colors.black87,
                        ),
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged:
                            (selected) =>
                                _handleSelection(condition, selected!),
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                ),
              );
            }),

            if (showOtherField) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _otherController,
                decoration: InputDecoration(
                  hintText: "Please specify",
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _handleSelection(String condition, bool selected) {
    setState(() {
      if (condition == 'None') {
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
          selectedConditions.remove('None');
        } else {
          selectedConditions.remove(condition);
          showOtherField = false;
        }
      } else {
        if (selected) {
          selectedConditions.add(condition);
          selectedConditions.remove('None');
        } else {
          selectedConditions.remove(condition);
        }
      }
    });
  }
}
