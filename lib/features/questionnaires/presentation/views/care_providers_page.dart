import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import '../../../../core/utils/page_rout_builder.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../widgets/baby_question_page.dart';
import 'medical_contraindications_page.dart';

class CareProvidersPage extends StatefulWidget {
  final BabyQuestionnaireCubit questionnaireCubit;

  const CareProvidersPage({super.key, required this.questionnaireCubit});

  @override
  State<CareProvidersPage> createState() => _CareProvidersPageState();
}

class _CareProvidersPageState extends State<CareProvidersPage> {
  final Set<String> selectedProviders = {};

  final List<String> providers = ['physical therapist', 'specialist'];

  void _onNext() {
    widget.questionnaireCubit.updateCareProviders(selectedProviders.toList());

    Navigator.push(
      context,
      buildPageRoute(
        MedicalContraindicationsPage(
          questionnaireCubit: widget.questionnaireCubit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BabyQuestionPageScaffold(
      questionText:
          "Is your baby currently under care of a physical therapist or specialist?",
      onNext: _onNext,
      showNextButton: true,
      child: Column(
        children: [
          const SizedBox(height: 12),
          ...providers.map((provider) {
            final isSelected = selectedProviders.contains(provider);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedProviders.remove(provider);
                    } else {
                      selectedProviders.add(provider);
                    }
                  });
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
                      provider,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:
                            isSelected ? Colors.green.shade700 : Colors.black87,
                      ),
                    ),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (_) {
                        setState(() {
                          if (isSelected) {
                            selectedProviders.remove(provider);
                          } else {
                            selectedProviders.add(provider);
                          }
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ),
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
