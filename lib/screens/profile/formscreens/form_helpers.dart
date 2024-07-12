import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

Widget buildTextFormField(
  TextEditingController controller,
  String label,
  IconData icon, {
  bool isOptional = false,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding:
        EdgeInsets.symmetric(vertical: AppConstants.verticalPaddingSmall / 2),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isOptional ? label : '$label *',
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.br8),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
    ),
  );
}

// girilen URL'yi URL deseni ile karşılaştırma
bool isValidSocialMediaUrl(String url, SocialMediaPlatform platform) {
  final urlPattern = platform.urlPattern;
  return RegExp(urlPattern).hasMatch(url);
}

Widget buildDateFormField(
    TextEditingController controller, String label, IconData icon,
    {bool isDisabled = false, bool isOptional = false}) {
  return Padding(
    padding:
        EdgeInsets.symmetric(vertical: AppConstants.verticalPaddingSmall / 2),
    child: Builder(
      builder: (context) => TextFormField(
        controller: controller,
        readOnly: true,
        enabled: !isDisabled,
        decoration: InputDecoration(
          labelText: isOptional ? label : '$label *',
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.br8),
          ),
        ),
        onTap: !isDisabled
            ? () async {
                Locale myLocale = Localizations.localeOf(context);
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  locale: myLocale,
                );
                controller.text = DateFormat('dd/MM/yyyy').format(pickedDate!);
                            }
            : null,
        validator: (value) {
          if (!isOptional && !isDisabled && (value == null || value.isEmpty)) {
            return 'Lütfen $label giriniz';
          }
          return null;
        },
      ),
    ),
  );
}

Widget buildDropdown<T>(String label, T? selectedValue, List<T> items,
    ValueChanged<T?> onChanged, String Function(T) itemLabel, IconData icon,
    {bool isOptional = false}) {
  return Padding(
    padding:
        EdgeInsets.symmetric(vertical: AppConstants.verticalPaddingSmall / 2),
    child: FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: isOptional ? label : '$label *',
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.br8),
            ),
            errorText: state.hasError ? state.errorText : null,
          ),
          isEmpty: selectedValue == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: selectedValue,
              isExpanded: true,
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                );
              }).toList(),
              onChanged: (T? newValue) {
                state.didChange(newValue);
                onChanged(newValue);
              },
            ),
          ),
        );
      },
      validator: (value) {
        if (!isOptional && (value == null)) {
          return 'Lütfen $label seçiniz';
        }
        return null;
      },
      initialValue: selectedValue,
    ),
  );
}
