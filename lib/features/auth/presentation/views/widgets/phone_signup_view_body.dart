import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:strongerkiddos/core/widgets/custom_button.dart';
import 'package:strongerkiddos/core/widgets/custom_name.dart';
import 'package:strongerkiddos/core/widgets/custom_text_form_field.dart';
import 'package:strongerkiddos/features/auth/presentation/views/otp_vericifaction.dart';
import '../../../../../app_constants.dart';
import '../../../../../core/utils/app_text_style.dart';
import 'or_divider.dart';

class PhoneSignupViewBody extends StatefulWidget {
  const PhoneSignupViewBody({super.key});

  @override
  State<PhoneSignupViewBody> createState() => _PhoneSignupViewBodyState();
}

class _PhoneSignupViewBodyState extends State<PhoneSignupViewBody> {
  final TextEditingController _phoneController = TextEditingController();
  String selectedCountryCode = '+1';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              const Text('Login', style: TextStyles.semiBold32),
              const SizedBox(height: 8),
              Text(
                'Please enter your phone number',
                style: TextStyles.regular16.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 55),
              CustomName(text: 'Phone Number'),
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
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, OtpVerificationView.routeName);
                },
                text: 'Get OTP',
              ),
              const SizedBox(height: 32),
              OrDivider(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  sideColor: Color(0xffe4e7eb),
                  backgroundColor: Color(0xffe4e7eb),
                  color: Colors.black,
                  onPressed: () {},
                  text: 'Login with Email',
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
