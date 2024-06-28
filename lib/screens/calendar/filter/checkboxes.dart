import 'package:flutter/material.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class StatusCheckboxes extends StatefulWidget {
  final List<String> selectedStatuses;
  final Function(String, bool?) onChanged;

  const StatusCheckboxes({
    super.key,
    required this.selectedStatuses,
    required this.onChanged,
  });

  @override
  State<StatusCheckboxes> createState() => _StatusCheckboxesState();
}

class _StatusCheckboxesState extends State<StatusCheckboxes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Eğitim Durumu', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: AppConstants.sizedBoxHeightSmall),
        Wrap(
          children: [
            CheckboxListTile(
              title: Text('Bitmiş Dersler',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: widget.selectedStatuses.contains('Bitmiş Dersler'),
              onChanged: (selected) {
                widget.onChanged('Bitmiş Dersler', selected);
              },
            ),
            CheckboxListTile(
              title: Text('Devam Eden Dersler',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: widget.selectedStatuses.contains('Devam Eden Dersler'),
              onChanged: (selected) {
                widget.onChanged('Devam Eden Dersler', selected);
              },
            ),
            CheckboxListTile(
              title: Text('Başlamamış Dersler',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: widget.selectedStatuses.contains('Başlamamış Dersler'),
              onChanged: (selected) {
                widget.onChanged('Başlamamış Dersler', selected);
              },
            ),
            CheckboxListTile(
              title: Text('Satın Alınmış Dersler',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: widget.selectedStatuses.contains('Satın Alınmış Dersler'),
              onChanged: (selected) {
                widget.onChanged('Satın Alınmış Dersler', selected);
              },
            ),
          ],
        ),
      ],
    );
  }
}
