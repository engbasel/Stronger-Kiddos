// lib/features/questionnaire/presentation/views/medical_contraindications_question.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/option_button.dart';
import '../widgets/question_page.dart';
import 'floor_time_question.dart';

class MedicalContraindicationsQuestion extends StatefulWidget {
  const MedicalContraindicationsQuestion({super.key});

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

      context.read<QuestionnaireCubit>().updateMedicalContraindications(
        hasContraindications!,
        details,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FloorTimeQuestion()),
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
                    _onNext();
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
        ],
      ),
    );
  }
}
