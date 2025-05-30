import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../core/helper/scccess_top_snak_bar.dart';
import '../../../../core/utils/form_validation.dart';
import '../../../../core/utils/page_rout_builder.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_cubit.dart';
import '../manager/baby_questionnaire_cubit/baby_questionnaire_state.dart';
import '../widgets/baby_photo_upload_widget.dart';
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
  String _selectedGender = 'Girl';
  String? _selectedRelationship;
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isUploading = false;
  bool _isUploaded = false;
  bool _dataLoaded = false;

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
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    if (_dataLoaded) return;

    // Load existing data from cubit if available
    final cubit = widget.questionnaireCubit;

    if (cubit.babyName.isNotEmpty) {
      _nameController.text = cubit.babyName;
    }

    if (cubit.dateOfBirth != null) {
      _selectedDate = cubit.dateOfBirth;
    }

    if (cubit.gender.isNotEmpty) {
      _selectedGender = cubit.gender;
    }

    if (cubit.relationship.isNotEmpty) {
      _selectedRelationship = cubit.relationship;
    }

    if (cubit.babyPhotoUrl != null && cubit.babyPhotoUrl!.isNotEmpty) {
      _uploadedImageUrl = cubit.babyPhotoUrl;
      _isUploaded = true;
    }

    _dataLoaded = true;

    // Force UI update
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure data is loaded when the widget is built
    _loadExistingData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BabyQuestionnaireCubit, BabyQuestionnaireState>(
      listener: (context, state) {
        if (state is BabyPhotoUploading) {
          setState(() {
            _isUploading = true;
          });
        } else if (state is BabyPhotoUploaded) {
          succesTopSnackBar(context, 'Baby photo uploaded successfully');
          setState(() {
            _uploadedImageUrl = state.photoUrl;
            _selectedImage = null; // Clear local image after successful upload
            _isUploading = false;
            _isUploaded = true;
          });
        } else if (state is BabyPhotoDeleted) {
          succesTopSnackBar(context, 'Baby photo deleted successfully');
          setState(() {
            _uploadedImageUrl = null;
            _selectedImage = null;
            _isUploading = false;
            _isUploaded = false;
          });
        } else if (state is BabyQuestionnaireError) {
          failuerTopSnackBar(context, state.message);
          setState(() {
            _isUploading = false;
          });
        } else if (state is BabyQuestionnaireReadyToStart) {
          // Reload data when cubit state changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadExistingData();
          });
        }
      },
      child: BabyQuestionPageScaffold(
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
                  uploadedImageUrl: _uploadedImageUrl,
                  isUploading: _isUploading,
                  isUploaded: _isUploaded,
                  onTap: _showImageOptions,
                  onDelete: _deleteBabyPhoto,
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
      ),
    );
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Baby Photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.blue),
                  ),
                  title: const Text('Choose from Gallery'),
                  subtitle: const Text('Select from your photo gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_camera, color: Colors.green),
                  ),
                  title: const Text('Take Photo'),
                  subtitle: const Text('Capture with camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                if (_uploadedImageUrl != null || _selectedImage != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                    title: const Text('Remove Photo'),
                    subtitle: const Text('Delete current photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _deleteBabyPhoto();
                    },
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isUploaded = false;
        });

        // Upload the image immediately
        await widget.questionnaireCubit.uploadBabyPhoto(_selectedImage!);
      }
    } catch (e) {
      if (mounted) {
        failuerTopSnackBar(context, 'Failed to pick image: ${e.toString()}');
      }
    }
  }

  Future<void> _deleteBabyPhoto() async {
    try {
      await widget.questionnaireCubit.deleteBabyPhoto();
    } catch (e) {
      if (mounted) {
        failuerTopSnackBar(context, 'Failed to delete photo: ${e.toString()}');
      }
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
