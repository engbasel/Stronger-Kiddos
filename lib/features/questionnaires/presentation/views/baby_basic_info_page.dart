import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/form_validation.dart';
import '../../../../core/utils/page_rout_builder.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../widgets/baby_basic_info_page.dart';
import '../widgets/baby_question_page.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/gender_selection_widget.dart';
import '../widgets/custom_date_picker_widget.dart';
import '../widgets/custom_dropdown_widget.dart';
import 'premature_question_page.dart';

class BabyBasicInfoPage extends StatefulWidget {
  final BabyQuestionnaireCubit questionnaireCubit;

  const BabyBasicInfoPage({super.key, required this.questionnaireCubit});

  @override
  State<BabyBasicInfoPage> createState() => _BabyBasicInfoPageState();
}

class _BabyBasicInfoPageState extends State<BabyBasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  DateTime? _selectedDate;
  String _selectedGender = '';
  String? _selectedRelationship;
  File? _selectedImage;

  static const List<String> _relationships = [
    'Mother',
    'Father',
    'Grandfather',
    'Grandmother',
    'Babysitter',
    'Aunt',
    'Uncle',
    'Development Professional',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BabyQuestionPageScaffold(
      questionText: "Tell us about your baby",
      onNext: _onNext,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BabyPhotoUploadWidget(
                selectedImage: _selectedImage,
                onTap: _pickImage,
              ),
              const SizedBox(height: 30.0),
              GenderSelectionWidget(
                selectedGender: _selectedGender,
                onGenderSelected: (gender) {
                  setState(() {
                    _selectedGender = gender;
                  });
                },
              ),
              const SizedBox(height: 30.0),
              CustomTextFieldWidget(
                controller: _nameController,
                label: 'What can we call your baby?',
                placeholder: 'Name',
                validator: FormValidation.validateName,
              ),
              const SizedBox(height: 24.0),
              CustomDatePickerWidget(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                label: 'Date of birth',
              ),
              const SizedBox(height: 24.0),
              CustomDropdownWidget(
                selectedValue: _selectedRelationship,
                items: _relationships,
                onChanged: (value) {
                  setState(() {
                    _selectedRelationship = value;
                  });
                },
                label: 'I am the child\'s',
                placeholder: 'Select your relationship',
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      await widget.questionnaireCubit.uploadBabyPhoto(_selectedImage!);
    }
  }

  void _onNext() {
    if (!_validateForm()) return;

    _updateQuestionnaireData();
    _navigateToNextPage();
  }

  bool _validateForm() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (_selectedDate == null) {
      _showSnackBar('Please select date of birth');
      return false;
    }

    if (_selectedGender.isEmpty) {
      _showSnackBar('Please select gender');
      return false;
    }

    if (_selectedRelationship == null || _selectedRelationship!.isEmpty) {
      _showSnackBar('Please select your relationship to the child');
      return false;
    }

    return true;
  }

  void _updateQuestionnaireData() {
    widget.questionnaireCubit.updateBasicInfo(
      _nameController.text.trim(),
      _selectedDate!,
      _selectedRelationship!,
    );
    widget.questionnaireCubit.updateGender(_selectedGender);
  }

  void _navigateToNextPage() {
    Navigator.push(
      context,
      buildPageRoute(
        PrematureQuestionPage(questionnaireCubit: widget.questionnaireCubit),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
