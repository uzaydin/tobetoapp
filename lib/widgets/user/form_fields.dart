import 'package:flutter/material.dart';

class FormFields {
  static Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
      validator: isRequired
          ? (value) => (value == null || value.isEmpty)
              ? 'Doldurulması zorunlu alan'
              : null
          : null,
    );
  }

  static Widget buildDateField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    BuildContext? context,
    IconData? icon,
    bool enabled = true, // Added enabled parameter
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
      validator: isRequired
          ? (value) => (value == null || value.isEmpty)
              ? 'Doldurulması zorunlu alan'
              : null
          : null,
      onTap: enabled // Make onTap work only if enabled is true
          ? () async {
              DateTime? pickedDate = await showDatePicker(
                context: context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                controller.text = "${pickedDate.toLocal()}".split(' ')[0];
              }
            }
          : null,
      readOnly: true, // Make the field read-only to avoid manual input
      enabled: enabled, // Enable or disable the field
    );
  }

  static Widget buildDropdownField<T>({
    required T? value,
    required String label,
    required List<T> items,
    required void Function(T?) onChanged,
    bool isRequired = false,
    IconData? icon,
    String Function(T)? itemLabel,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child:
                    Text(itemLabel != null ? itemLabel(item) : item.toString()),
              ))
          .toList(),
      validator: isRequired
          ? (value) => (value == null) ? 'Doldurulması zorunlu alan' : null
          : null,
    );
  }
}
