import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../widgets/baby_question_page.dart';

class ContainerTimePage extends StatefulWidget {
  final BabyQuestionnaireCubit questionnaireCubit;

  const ContainerTimePage({super.key, required this.questionnaireCubit});

  @override
  State<ContainerTimePage> createState() => _ContainerTimePageState();
}

class _ContainerTimePageState extends State<ContainerTimePage> {
  String? selectedTime;

  final List<String> timeOptions = ['Minimal', '1-2 hrs/day', '3+ hrs/day'];

  void _onNext() {
    if (selectedTime != null) {
      widget.questionnaireCubit.updateContainerTime(selectedTime!);
      widget.questionnaireCubit.submitQuestionnaire(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BabyQuestionPageScaffold(
      questionText:
          "How much time does your baby spend in containers (swings, car seats, bouncers)?",
      onNext: _onNext,
      showNextButton: selectedTime != null,
      isLastQuestion: true,
      child: Column(
        children: [
          const SizedBox(height: 275),
          ...timeOptions.map((option) {
            final isSelected = selectedTime == option;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
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
                  title: Text(
                    option,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? Colors.green.shade700 : Colors.black87,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedTime = option;
                    });
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  trailing:
                      isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
