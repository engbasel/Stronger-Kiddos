import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/form_validation.dart';
import '../../../../core/utils/page_rout_builder.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../widgets/baby_question_page.dart';
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

  DateTime? _selectedDate;
  String _selectedGender = '';
  String? _selectedRelationship;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // List of relationships
  final List<String> relationships = [
    'Mother',
    'Father',
    'Grandfather',
    'Grandmother',
    'babysitter',
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      // Upload image
      widget.questionnaireCubit.uploadBabyPhoto(_selectedImage!);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.fabBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date of birth')),
        );
        return;
      }

      if (_selectedGender.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select gender')));
        return;
      }

      if (_selectedRelationship == null || _selectedRelationship!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your relationship to the child'),
          ),
        );
        return;
      }

      widget.questionnaireCubit.updateBasicInfo(
        _nameController.text.trim(),
        _selectedDate!,
        _selectedRelationship!,
      );

      widget.questionnaireCubit.updateGender(_selectedGender);

      Navigator.push(
        context,
        buildPageRoute(
          PrematureQuestionPage(questionnaireCubit: widget.questionnaireCubit),
        ),
      );
    }
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
              // Photo Upload Section - Large Circle
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE0E0E0),
                    border: Border.all(
                      color: const Color(0xFFD3D3D3),
                      width: 2.0,
                    ),
                  ),
                  child:
                      _selectedImage != null
                          ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: 60.0,
                                color: Color(0xFF999da3),
                              ),
                              Positioned(
                                bottom: 10.0,
                                right: 10.0,
                                child: Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFD3D3D3),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xFF757575),
                                    size: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
              ),

              const SizedBox(height: 10.0),

              // Add photo text
              if (_selectedImage == null)
                const Text('Add photo', style: TextStyles.regular16),

              const SizedBox(height: 30.0),

              // Gender Selection - Single Row Design
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: const Color(0xff7c9471),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                    color: const Color(0xFFD3D3D3),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Girl Option
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = 'Girl'),
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            color:
                                _selectedGender == 'Girl'
                                    ? const Color(0xFF3a542e)
                                    : const Color(0xFF7c9471),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.face,
                                size: 18.0,
                                color:
                                    _selectedGender == 'Girl'
                                        ? Colors.white
                                        : const Color(0xFFd0d5dd),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Girl',
                                style: TextStyle(
                                  color:
                                      _selectedGender == 'Girl'
                                          ? Colors.white
                                          : const Color(0xFFd0d5dd),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Boy Option
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = 'Boy'),
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                            color:
                                _selectedGender == 'Boy'
                                    ? const Color(0xFF3a542e)
                                    : const Color(0xFF7c9471),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.face,
                                size: 18.0,
                                color:
                                    _selectedGender == 'Boy'
                                        ? Colors.white
                                        : const Color(0xFFd0d5dd),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Boy',
                                style: TextStyle(
                                  color:
                                      _selectedGender == 'Boy'
                                          ? Colors.white
                                          : const Color(0xFFd0d5dd),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30.0),

              // Name Field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What can we call your baby?',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFFD3D3D3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFFD3D3D3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: AppColors.fabBackgroundColor,
                    ),
                  ),
                ),
                validator: (value) => FormValidation.validateName(value),
              ),

              const SizedBox(height: 24.0),

              // Date of Birth
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date of birth',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 16.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD3D3D3)),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                            : 'Select Date',
                        style: TextStyle(
                          color:
                              _selectedDate != null
                                  ? const Color(0xFF212121)
                                  : const Color(0xFF757575),
                          fontSize: 16.0,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF757575),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // I am the child's - Dropdown Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'I am the child\'s',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD3D3D3)),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRelationship,
                    hint: const Text(
                      'Select your relationship',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 16.0,
                      ),
                    ),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF757575),
                    ),
                    items:
                        relationships.map((String relationship) {
                          return DropdownMenuItem<String>(
                            value: relationship,
                            child: Text(
                              relationship,
                              style: const TextStyle(
                                color: Color(0xFF212121),
                                fontSize: 16.0,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRelationship = newValue;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
