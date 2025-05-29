import 'package:flutter/material.dart';
import 'package:strongerkiddos/core/utils/app_colors.dart';
import '../../../../core/utils/page_rout_builder.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../widgets/baby_question_page.dart';
import 'floor_time_page.dart';

class MedicalContraindicationsPage extends StatefulWidget {
  final BabyQuestionnaireCubit questionnaireCubit;

  const MedicalContraindicationsPage({
    super.key,
    required this.questionnaireCubit,
  });

  @override
  State<MedicalContraindicationsPage> createState() =>
      _MedicalContraindicationsPageState();
}

class _MedicalContraindicationsPageState
    extends State<MedicalContraindicationsPage> {
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

      widget.questionnaireCubit.updateMedicalContraindications(
        hasContraindications!,
        details,
      );

      Navigator.push(
        context,
        buildPageRoute(
          FloorTimePage(questionnaireCubit: widget.questionnaireCubit),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BabyQuestionPageScaffold(
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
            const SizedBox(height: 350),
            Row(
              children: [
                Expanded(
                  child: _buildSelectableTile(
                    "Yes",
                    hasContraindications == true,
                    () {
                      setState(() {
                        hasContraindications = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSelectableTile(
                    "No",
                    hasContraindications == false,
                    () {
                      setState(() {
                        hasContraindications = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (hasContraindications == true) ...[
              const SizedBox(height: 24),
              const Text(
                "If yes please describe",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(
                  hintText:
                      "e.g., cardiac issues, hip instability, seizures, etc.",
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
                onChanged: (_) => setState(() {}),
                maxLines: 3,
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
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
          color:
              isSelected ? AppColors.fabBackgroundColor : Colors.grey.shade300,
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
            color: isSelected ? AppColors.fabBackgroundColor : Colors.black87,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        trailing:
            isSelected
                ? const Icon(
                  Icons.check_circle,
                  color: AppColors.fabBackgroundColor,
                )
                : null,
      ),
    );
  }
}
