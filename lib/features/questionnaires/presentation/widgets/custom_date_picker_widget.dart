import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class CustomDatePickerWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String label;
  final String placeholder;

  const CustomDatePickerWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.label,
    this.placeholder = 'Select Date',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => _selectDate(context),
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
                  selectedDate != null
                      ? _formatDate(selectedDate!)
                      : placeholder,
                  style: TextStyle(
                    color:
                        selectedDate != null
                            ? const Color(0xFF212121)
                            : const Color(0xFF757575),
                    fontSize: 16.0,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF757575)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate ?? DateTime.now().subtract(const Duration(days: 365)),
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
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
