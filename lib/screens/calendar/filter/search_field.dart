import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/calendar_bloc/calendar.state.dart';
import 'package:tobetoapp/bloc/calendar_bloc/calendar_bloc.dart';

import 'package:tobetoapp/bloc/calendar_bloc/calendar_event.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/utils/theme/light/light_theme.dart';

class SearchField extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;

  const SearchField({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        List<String> suggestions = [];
        if (state is EventEducationSearchLoaded) {
          suggestions = state.suggestions;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eğitim Arama',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: AppConstants.sizedBoxHeightSmall),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return suggestions.where((String suggestion) {
                  return suggestion
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                }).toList();
              },
              onSelected: (String selection) {
                widget.searchController.text = selection;
                widget.onSearch();
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                fieldTextEditingController.addListener(() {
                  widget.onSearch();
                  context
                      .read<CalendarBloc>()
                      .add(SearchEducations(fieldTextEditingController.text));
                });
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Eğitim Arayın...',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.tobetoMoru),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        fieldTextEditingController.clear();
                        widget.searchController.clear();
                        widget.onSearch();
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
