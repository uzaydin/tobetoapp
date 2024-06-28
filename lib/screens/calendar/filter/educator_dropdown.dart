import 'package:flutter/material.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';

class EducatorDropdown extends StatefulWidget {
  final List<String> selectedEducators;
  final List<String> educators;
  final ValueChanged<List<String>> onChanged;

  const EducatorDropdown({
    super.key,
    required this.selectedEducators,
    required this.educators,
    required this.onChanged,
  });

  @override
  State<EducatorDropdown> createState() => _EducatorDropdownState();
}

class _EducatorDropdownState extends State<EducatorDropdown> {
  List<String> _selectedEducators = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedEducators = List.from(widget.selectedEducators);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Eğitmen',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.tobetoMoru,
                    decorationThickness: 2,
                  ),
            ),
          ),
        ),
        SizedBox(height: AppConstants.sizedBoxHeightSmall),
        if (_isDropdownOpen)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.educators.map((educator) {
              bool isSelected = _selectedEducators.contains(educator);
              return Padding(
                padding:
                    EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedEducators.remove(educator);
                      } else {
                        _selectedEducators.add(educator);
                      }
                    });
                    widget.onChanged(_selectedEducators);
                  },
                  child: Text(
                    educator,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color:
                              isSelected ? AppColors.tobetoMoru : Colors.black,
                          decoration: isSelected
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
