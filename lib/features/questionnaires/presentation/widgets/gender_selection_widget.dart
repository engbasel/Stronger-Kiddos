import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderSelected;

  const GenderSelectionWidget({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: const Color(0xff7c9471),
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(color: const Color(0xFFD3D3D3), width: 1.0),
      ),
      child: Row(
        children: [
          _GenderOption(
            gender: 'Girl',
            icon: Icons.face,
            isSelected: selectedGender == 'Girl',
            onTap: () => onGenderSelected('Girl'),
          ),
          _GenderOption(
            gender: 'Boy',
            icon: Icons.face,
            isSelected: selectedGender == 'Boy',
            onTap: () => onGenderSelected('Boy'),
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String gender;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.gender,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFF3a542e) : const Color(0xFF7c9471),
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.0,
                color: isSelected ? Colors.white : const Color(0xFFd0d5dd),
              ),
              const SizedBox(width: 8.0),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFd0d5dd),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
