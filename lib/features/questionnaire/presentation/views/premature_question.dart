import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/question_page.dart';
import '../widgets/option_button.dart';
import 'diagnosed_conditions_question.dart';

class PrematureQuestion extends StatefulWidget {
  const PrematureQuestion({super.key});

  @override
  State<PrematureQuestion> createState() => _PrematureQuestionState();
}

class _PrematureQuestionState extends State<PrematureQuestion> {
  bool? wasPremature;
  final TextEditingController _weeksController = TextEditingController();

  @override
  void dispose() {
    _weeksController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (wasPremature != null) {
      int? weeks;
      if (wasPremature == true) {
        weeks = int.tryParse(_weeksController.text.trim());
      }

      context.read<QuestionnaireCubit>().updatePrematureStatus(
        wasPremature!,
        weeks,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DiagnosedConditionsQuestion(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText: "Was your baby born prematurely?",
      onNext: _onNext,
      showNextButton:
          wasPremature != null &&
          (wasPremature == false || _weeksController.text.isNotEmpty),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OptionButton(
                  text: "Yes",
                  isSelected: wasPremature == true,
                  onTap: () {
                    setState(() {
                      wasPremature = true;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OptionButton(
                  text: "No",
                  isSelected: wasPremature == false,
                  onTap: () {
                    setState(() {
                      wasPremature = false;
                    });
                    _onNext();
                  },
                ),
              ),
            ],
          ),
          if (wasPremature == true) ...[
            const SizedBox(height: 24),
            const Text(
              "If yes how many weeks early?",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weeksController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter weeks",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ],
        ],
      ),
    );
  }
}
