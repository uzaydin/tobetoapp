import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/announcements/announcement_bloc.dart';
import 'package:tobetoapp/bloc/announcements/announcement_event.dart';
import 'package:tobetoapp/models/announcement_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcements announcement;
  final UserRole role;
  final List<String> classIds;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.role,
    required this.classIds,
  });

  void _showAnnouncementDetails(BuildContext context, Announcements announcement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(announcement.title!),
            content: Text(announcement.content!),
            actions: [
              TextButton(
                child: const Text("Kapat"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = announcement.createdAt != null
        ? DateFormat('dd.MM.yyyy').format(announcement.createdAt!)
        : 'No date';

    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.br16),
      ),
      child: GestureDetector(
        onTap: () => _showAnnouncementDetails(context, announcement),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duyuru',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'İstanbul Kodluyor',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              Text(
                announcement.title!,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: AppConstants.sizedBoxHeightSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16.0),
                      SizedBox(width: AppConstants.sizedBoxWidthSmall),
                      Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _showAnnouncementDetails(context, announcement),
                    child: const Text('Detaylar'),
                  ),
                  if (role == UserRole.admin)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<AnnouncementBloc>().add(DeleteAnnouncement(classIds, announcement.id!, role));
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}