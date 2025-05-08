import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/form_validation.dart';
import '../manager/questionnaire_cubit/questionnaire_cubit.dart';
import '../widgets/question_page.dart';
import 'gender_question.dart';

class ChildInfoQuestion extends StatefulWidget {
  const ChildInfoQuestion({super.key});

  @override
  State<ChildInfoQuestion> createState() => _ChildInfoQuestionState();
}

class _ChildInfoQuestionState extends State<ChildInfoQuestion> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final age = int.tryParse(_ageController.text.trim()) ?? 0;

      context.read<QuestionnaireCubit>().updateChildInfo(name, age);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GenderQuestion()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuestionPageScaffold(
      questionText: "Tell us about your child",
      onNext: _onNext,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What can we call your baby?",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) => FormValidation.validateName(value),
            ),
            const SizedBox(height: 24),
            const Text(
              "How old is your baby (in months)?",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Age",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your baby\'s age';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "choose an avatar for your child",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAvatarOption('assets/images/png/avatar_boy.png'),
                const SizedBox(width: 24),
                _buildAvatarOption('assets/images/png/avatar_girl.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(String imagePath) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) =>
                  const Icon(Icons.person, size: 40),
        ),
      ),
    );
  }
}
