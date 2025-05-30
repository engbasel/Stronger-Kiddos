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
        } else if (state is ProfileImageUploaded) {
          succesTopSnackBar(context, 'Profile image updated successfully');
        } else if (state is ProfileImageDeleted) {
          succesTopSnackBar(context, 'Profile image deleted successfully');
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
        state is ProfileImageUploading ||
        state is ProfileImageDeleting ||
        state is ProfileUpdating;
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    if (state is ProfileLoaded ||
        state is ProfileImageUploaded ||
        state is ProfileImageDeleted ||
        state is ProfileUpdated) {
      UserEntity user;
      if (state is ProfileLoaded) {
        user = state.user;
      } else if (state is ProfileImageUploaded) {
        user = state.user;
      } else if (state is ProfileImageDeleted) {
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
              _buildProfileImage(context, user),
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

  Widget _buildProfileImage(BuildContext context, UserEntity user) {
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
              child: ClipOval(child: _buildImageWidget(user)),
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
                  onPressed: () => _showImageOptions(context),
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

  Widget _buildImageWidget(UserEntity user) {
    final imageUrl = user.bestAvailableImageUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
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

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensure the sheet can expand if needed
      builder: (BuildContext sheetContext) {
        return BlocProvider.value(
          value: context.read<ProfileCubit>(), // Pass the existing cubit
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _pickImage(ImageSource.camera);
                  },
                ),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (sheetContext, state) {
                    if (state is ProfileLoaded ||
                        state is ProfileImageUploaded ||
                        state is ProfileUpdated) {
                      UserEntity user;
                      if (state is ProfileLoaded) {
                        user = state.user;
                      } else if (state is ProfileImageUploaded) {
                        user = state.user;
                      } else {
                        user = (state as ProfileUpdated).user;
                      }

                      if (user.bestAvailableImageUrl != null) {
                        return ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Remove Photo'),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            sheetContext
                                .read<ProfileCubit>()
                                .deleteProfileImage();
                          },
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
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
        final File imageFile = File(image.path);
        if (mounted) {
          context.read<ProfileCubit>().uploadProfileImage(imageFile);
        }
      }
    } catch (e) {
      if (mounted) {
        failuerTopSnackBar(context, 'Failed to pick image');
      }
    }
  }
}
