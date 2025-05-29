import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/page_rout_builder.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../widgets/baby_question_page.dart';
import 'diagnosed_conditions_page.dart';

class PrematureQuestionPage extends StatefulWidget {
  final BabyQuestionnaireCubit questionnaireCubit;

  const PrematureQuestionPage({super.key, required this.questionnaireCubit});

  @override
  State<PrematureQuestionPage> createState() => _PrematureQuestionPageState();
}

class _PrematureQuestionPageState extends State<PrematureQuestionPage> {
  bool? wasPremature;
  int selectedWeeks = 7;

  final List<int> weeksOptions = [6, 7, 8];

  void _onNext() {
    if (wasPremature != null) {
      int? weeks = wasPremature == true ? selectedWeeks : null;
      widget.questionnaireCubit.updatePrematureStatus(wasPremature!, weeks);

      Navigator.push(
        context,
        buildPageRoute(
          DiagnosedConditionsPage(
            questionnaireCubit: widget.questionnaireCubit,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BabyQuestionPageScaffold(
      questionText: "Was your baby born prematurely ?",
      onNext: _onNext,
      showNextButton:
          wasPremature != null && (wasPremature == false || selectedWeeks > 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSelectableTile("Yes", wasPremature == true, () {
                  setState(() {
                    wasPremature = true;
                  });
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSelectableTile("No", wasPremature == false, () {
                  setState(() {
                    wasPremature = false;
                  });
                }),
              ),
            ],
          ),
          if (wasPremature == true) ...[
            const SizedBox(height: 24),
            const Text(
              "If yes how many weeks early?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: weeksOptions.indexOf(selectedWeeks),
                ),
                itemExtent: 36,
                useMagnifier: true,
                magnification: 1.1,
                squeeze: 1.2,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedWeeks = weeksOptions[index];
                  });
                },
                children:
                    weeksOptions
                        .map(
                          (week) => Center(
                            child: Text(
                              '$week',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSelectableTile(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return AnimatedContainer(
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
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.green.shade700 : Colors.black87,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        trailing:
            isSelected
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
      ),
    );
  }
}
