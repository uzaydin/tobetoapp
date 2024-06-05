import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/announcements/announcement_bloc.dart';
import 'package:tobetoapp/bloc/announcements/announcement_event.dart';
import 'package:tobetoapp/bloc/announcements/announcement_state.dart';
import 'package:tobetoapp/models/class_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/add_announcement.dart';
import 'package:tobetoapp/screens/announcement_detail.dart';


class AnnouncementsPage extends StatelessWidget {
  final UserRole? role;
  final List<ClassModel>? classModels;

  const AnnouncementsPage({super.key, required this.role, this.classModels});

  @override
  Widget build(BuildContext context) {
    // Duyurularin sinifa ve role gore on yuklenme durumu
    context.read<AnnouncementBloc>().add(LoadAnnouncements(classModels, role));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        actions: role == UserRole.admin
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAnnouncementPage(),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: BlocConsumer<AnnouncementBloc, AnnouncementState>(
        listener: (context, state) {
          if (state is AnnouncementOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Operation Successful')));
          } else if (state is AnnouncementOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Operation Failed')));
          }
        },
        builder: (context, state) {
          if (state is AnnouncementsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnnouncementsLoaded) {
            if (state.announcements.isEmpty) {
              return const Center(child: Text('No announcements available.'));
            } else {
              final reversedAnnouncements =
                  state.announcements.reversed.toList();
              return ListView.builder(
                itemCount: reversedAnnouncements.length,
                itemBuilder: (context, index) {
                  final announcement = reversedAnnouncements[index];
                  final formattedDate = announcement.createdAt != null
                      ? DateFormat('dd.MM.yyyy').format(announcement.createdAt!)
                      : 'No date';
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnouncementDetailPage(
                              announcement: announcement,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Announcement',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              announcement.title!,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16.0),
                                    const SizedBox(width: 4.0),
                                    Text(formattedDate),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AnnouncementDetailPage(
                                          announcement: announcement,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Details'),
                                ),
                                if (role == UserRole.admin)
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      context.read<AnnouncementBloc>().add(
                                          DeleteAnnouncement(classModels,
                                              announcement.id!, role!));
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else if (state is AnnouncementOperationFailure) {
            return const Center(child: Text('Failed to load announcements'));
          } else {
            return const Center(child: Text('Failed to load announcements'));
          }
        },
      ),
    );
  }
}


