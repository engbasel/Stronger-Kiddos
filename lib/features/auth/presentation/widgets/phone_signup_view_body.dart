import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_name.dart';
import 'package:strongerkiddos/core/widgets/custom_text_form_field.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/signup_cubit/signup_cubit.dart';
import 'package:strongerkiddos/features/auth/presentation/manager/signup_cubit/signup_state.dart';
import 'package:strongerkiddos/features/auth/presentation/views/login_view.dart';
import 'package:strongerkiddos/features/auth/presentation/views/otp_vericifaction.dart';
import 'package:strongerkiddos/core/helper/failuer_top_snak_bar.dart';
import 'package:strongerkiddos/core/helper/scccess_top_snak_bar.dart';
import '../../../../app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/widgets/custom_progrss_hud.dart';
import 'or_divider.dart';

class PhoneSignupViewBody extends StatefulWidget {
  const PhoneSignupViewBody({super.key});

  @override
  State<PhoneSignupViewBody> createState() => _PhoneSignupViewBodyState();
}

class _PhoneSignupViewBodyState extends State<PhoneSignupViewBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String selectedCountryCode = '+1';

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Handle getting OTP
  void _getOTP() {
    if (_formKey.currentState!.validate()) {
      final phoneNumber = '$selectedCountryCode${_phoneController.text.trim()}';
      final signupCubit = context.read<SignupCubit>();

      signupCubit.verifyPhoneNumber(phoneNumber: phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is PhoneVerificationSent) {
          succesTopSnackBar(context, 'OTP sent successfully');
          Navigator.pushNamed(
            context,
            OtpVerificationView.routeName,
            arguments: {
              'verificationId': state.verificationId,
              'phoneNumber':
                  '$selectedCountryCode${_phoneController.text.trim()}',
              'name': _nameController.text.trim(),
            },
          );
        } else if (state is SignupFailure) {
          failuerTopSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
          isLoading: state is SignupLoading,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.kHorizintalPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35),
                    const Text(
                      'Phone Verification',
                      style: TextStyles.semiBold32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please enter your phone number and name',
                      style: TextStyles.regular16.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 35),

                    // Name field
                    const CustomName(text: 'Your Name'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Enter your name',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Phone field
                    const CustomName(text: 'Phone Number'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintText: 'Phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      prefixIcon: CountryCodePicker(
                        onChanged: (countryCode) {
                          setState(() {
                            selectedCountryCode = countryCode.dialCode ?? '+1';
                          });
                        },
                        initialSelection: 'US',
                        favorite: const ['+1', 'US'],
                        showCountryOnly: false,
                        showFlag: true,
                        showFlagDialog: true,
                        alignLeft: false,
                        textStyle: const TextStyle(color: Colors.black),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 65),

                    // Get OTP button
                    CustomButton(onPressed: _getOTP, text: 'Get OTP'),

                    const SizedBox(height: 32),
                    const OrDivider(),
                    const SizedBox(height: 32),

                    // Login with Email button
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        sideColor: const Color(0xffe4e7eb),
                        backgroundColor: const Color(0xffe4e7eb),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            LoginView.routeName,
                          );
                        },
                        text: 'Login with Email',
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
