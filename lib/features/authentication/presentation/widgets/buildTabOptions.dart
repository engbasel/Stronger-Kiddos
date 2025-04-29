// import 'package:flutter/material.dart';

// Widget buildTabOptions() {
//   return Row(
//     children: [
//       Expanded(
//         child: GestureDetector(
//           onTap: () => _changeTab(LoginTabOption.email),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Email',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color:
//                       _selectedTab == LoginTabOption.email
//                           ? Colors.orange
//                           : Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Divider(
//                 color:
//                     _selectedTab == LoginTabOption.email
//                         ? Colors.orange
//                         : Colors.grey.withOpacity(0.3),
//                 thickness: 2,
//               ),
//             ],
//           ),
//         ),
//       ),
//       const SizedBox(width: 16),
//       Expanded(
//         child: GestureDetector(
//           onTap: () => _changeTab(LoginTabOption.phone),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Phone Number',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color:
//                       _selectedTab == LoginTabOption.phone
//                           ? Colors.orange
//                           : Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Divider(
//                 color:
//                     _selectedTab == LoginTabOption.phone
//                         ? Colors.orange
//                         : Colors.grey.withOpacity(0.3),
//                 thickness: 2,
//               ),
//             ],
//           ),
//         ),
//       ),
//     ],
//   );
// }

import 'package:flutter/material.dart';

class TabOption {
  final String label;
  final dynamic value;

  TabOption({required this.label, required this.value});
}

class TabSelector extends StatelessWidget {
  final dynamic selectedTab;
  final List<TabOption> tabs;
  final ValueChanged<dynamic> onTabSelected;

  const TabSelector({
    Key? key,
    required this.selectedTab,
    required this.tabs,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          tabs.map((tab) {
            final isSelected = selectedTab == tab.value;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(tab.value),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.orange : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Divider(
                      color:
                          isSelected
                              ? Colors.orange
                              : Colors.grey.withOpacity(0.3),
                      thickness: 2,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
