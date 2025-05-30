import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helper/failuer_top_snak_bar.dart';
import '../../../../core/helper/scccess_top_snak_bar.dart';
import '../../../../core/services/get_it_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_progrss_hud.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../auth/domain/repos/auth_repo.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../questionnaires/domain/repos/baby_questionnaire_repo.dart'; // إضافة
import '../../../../core/services/firebase_auth_service.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => ProfileCubit(
            authRepo: getIt<AuthRepo>(),
            authService: getIt<FirebaseAuthService>(),
            questionnaireRepo: getIt<BabyQuestionnaireRepo>(), // إضافة
          )..loadUserProfile(),
      child: const ProfileViewBody(),
    );
  }
}

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          failuerTopSnackBar(context, state.message);
        } else if (state is ProfilePhotoUploaded) {
          succesTopSnackBar(context, 'Photo updated successfully');
          // إعلام المستخدم بأن صورة الطفل تم تحديثها أيضاً
          _showPhotoSyncInfo(context);
        } else if (state is ProfilePhotoDeleted) {
          succesTopSnackBar(context, 'Photo deleted successfully');
          _showPhotoSyncInfo(context);
        } else if (state is ProfileUpdated) {
          succesTopSnackBar(context, 'Profile updated successfully');
        } else if (state is ProfileLoaded) {
          _populateFields(state.user);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // زر لمزامنة صور الطفل
              IconButton(
                icon: const Icon(Icons.sync, color: Colors.grey),
                onPressed: () {
                  context.read<ProfileCubit>().refreshProfile();
                  _showSyncMessage(context);
                },
                tooltip: 'Sync with baby photos',
              ),
            ],
          ),
          body: CustomProgrssHud(
            isLoading: _isLoading(state),
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  bool _isLoading(ProfileState state) {
    return state is ProfileLoading ||
        state is ProfilePhotoUploading ||
        state is ProfilePhotoDeleting ||
        state is ProfileUpdating;
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    if (state is ProfileLoaded ||
        state is ProfilePhotoUploaded ||
        state is ProfilePhotoDeleted ||
        state is ProfileUpdated) {
      UserEntity user;
      if (state is ProfileLoaded) {
        user = state.user;
      } else if (state is ProfilePhotoUploaded) {
        user = state.user;
      } else if (state is ProfilePhotoDeleted) {
        user = state.user;
      } else {
        user = (state as ProfileUpdated).user;
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildUserPhoto(context, user),
              const SizedBox(height: 16),
              // رسالة توضيحية
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your profile photo is shared with your baby\'s photo',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildUserInfoForm(user),
              const SizedBox(height: 32),
              _buildUpdateButton(context),
            ],
          ),
        ),
      );
    }

    if (state is ProfileError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.message}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            CustomButton(
              onPressed: () {
                context.read<ProfileCubit>().loadUserProfile();
              },
              text: 'Retry',
            ),
          ],
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildUserPhoto(BuildContext context, UserEntity user) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                border: Border.all(
                  color: AppColors.fabBackgroundColor,
                  width: 3,
                ),
              ),
              child: ClipOval(child: _buildPhotoWidget(user)),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.fabBackgroundColor,
                ),
                child: IconButton(
                  onPressed: () => _showPhotoOptions(context, user),
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildPhotoWidget(UserEntity user) {
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      return Image.network(
        user.photoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderIcon();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return _buildPlaceholderIcon();
  }

  Widget _buildPlaceholderIcon() {
    return Icon(Icons.person, size: 60, color: Colors.grey.shade400);
  }

  Widget _buildUserInfoForm(UserEntity user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _nameController,
          hintText: 'Enter your name',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: _phoneController,
          hintText: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            // Phone number is optional
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return CustomButton(
      onPressed: () => _updateProfile(context),
      text: 'Update Profile',
    );
  }

  void _populateFields(UserEntity user) {
    _nameController.text = user.name;
    _phoneController.text = user.phoneNumber ?? '';
  }

  void _updateProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().updateUserInfo(
        name: _nameController.text.trim(),
        phoneNumber:
            _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
      );
    }
  }

  void _showPhotoOptions(BuildContext context, UserEntity user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Update Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'This will update both your profile and baby photo',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                textAlign: TextAlign.center,
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
                subtitle: const Text('Select from your photos'),
                onTap: () {
                  Navigator.pop(context);
                  _pickPhoto(ImageSource.gallery);
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
                  _pickPhoto(ImageSource.camera);
                },
              ),
              if (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  title: const Text('Remove Photo'),
                  subtitle: const Text('Delete current photo'),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ProfileCubit>().deleteUserPhoto();
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        if (mounted) {
          context.read<ProfileCubit>().uploadUserPhoto(imageFile);
        }
      }
    } catch (e) {
      if (mounted) {
        failuerTopSnackBar(context, 'Failed to pick photo');
      }
    }
  }

  void _showPhotoSyncInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.sync, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text('Baby photo updated automatically')),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSyncMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.sync, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(child: Text('Syncing with baby photos...')),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
