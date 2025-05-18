import 'package:flutter/material.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/option_button.dart';
import '../widgets/question_page.dart';
import 'floor_time_question.dart';

class MedicalContraindicationsQuestion extends StatefulWidget {
  final QuestionnaireCubit questionnaireCubit;

  const MedicalContraindicationsQuestion({
    super.key,
    required this.questionnaireCubit,
  });

  @override
  State<MedicalContraindicationsQuestion> createState() =>
      _MedicalContraindicationsQuestionState();
}

class _MedicalContraindicationsQuestionState
    extends State<MedicalContraindicationsQuestion> {
  bool? hasContraindications;
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (hasContraindications != null) {
      String? details;
      if (hasContraindications == true && _detailsController.text.isNotEmpty) {
        details = _detailsController.text.trim();
      }

      // Use widget.questionnaireCubit instead of context.read
      widget.questionnaireCubit.updateMedicalContraindications(
        hasContraindications!,
        details,
      );

      // Pass the cubit to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => FloorTimeQuestion(
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
          "Does your baby have any medical contraindications to movement or exercise?",
      onNext: _onNext,
      showNextButton:
          hasContraindications != null &&
          (hasContraindications == false || _detailsController.text.isNotEmpty),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: OptionButton(
                    text: "Yes",
                    isSelected: hasContraindications == true,
                    onTap: () {
                      setState(() {
                        hasContraindications = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OptionButton(
                    text: "No",
                    isSelected: hasContraindications == false,
                    onTap: () {
                      setState(() {
                        hasContraindications = false;
                      });
                      // Remove auto-navigation
                      // _onNext();
                    },
                  ),
                ),
              ],
            ),
            if (hasContraindications == true) ...[
              const SizedBox(height: 24),
              const Text(
                "If yes please describe",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(
                  hintText:
                      "e.g., cardiac issues, hip instability, seizures, etc.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
                maxLines: 3,
              ),
            ],
            const SizedBox(height: 20), // Extra padding at the bottom
          ],
        ),
      ),
    );
  }
}
