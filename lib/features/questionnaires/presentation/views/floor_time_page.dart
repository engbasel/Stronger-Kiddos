import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import '../../../../core/utils/page_rout_builder.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../widgets/baby_question_page.dart';
import 'container_time_page.dart';

class FloorTimePage extends StatefulWidget {
  final BabyQuestionnaireCubit questionnaireCubit;

  const FloorTimePage({super.key, required this.questionnaireCubit});

  @override
  State<FloorTimePage> createState() => _FloorTimePageState();
}

class _FloorTimePageState extends State<FloorTimePage> {
  String? selectedTime;

  final List<String> timeOptions = [
    'Less than 15 min',
    '15-30 min Delay',
    '30-60 min',
    'Over 1 hour',
  ];

  void _onNext() {
    if (selectedTime != null) {
      widget.questionnaireCubit.updateFloorTime(selectedTime!);

      Navigator.push(
        context,
        buildPageRoute(
          ContainerTimePage(questionnaireCubit: widget.questionnaireCubit),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BabyQuestionPageScaffold(
      questionText:
          "How much time does your baby spend on the floor daily (awake)?",
      onNext: _onNext,
      showNextButton: selectedTime != null,
      child: Column(
        children: [
          const SizedBox(height: 230),
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
