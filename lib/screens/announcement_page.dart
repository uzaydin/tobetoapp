import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/announcements/announcement_bloc.dart';
import 'package:tobetoapp/bloc/announcements/announcement_event.dart';
import 'package:tobetoapp/bloc/announcements/announcement_state.dart';
import 'package:tobetoapp/models/announcement_model.dart';
import 'package:tobetoapp/models/class_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/add_announcement.dart';
import 'package:tobetoapp/screens/announcement_detail.dart';
import 'package:tobetoapp/theme/constants/constants.dart';

class AnnouncementsPage extends StatefulWidget {
  final UserRole? role;
  final List<String>? classIds;

  const AnnouncementsPage({super.key, required this.role, this.classIds});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  void initState() {
    super.initState();
    // Duyurularin sinifa ve role gore on yuklenme durumu
    context
        .read<AnnouncementBloc>()
        .add(LoadAnnouncements(widget.classIds, widget.role));
  }

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
    // AppConstants'ı başlat
    AppConstants.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tobeto'),
        centerTitle: true,
        actions: widget.role == UserRole.admin
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddAnnouncementPage(),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          // Sabit Banner
          SizedBox(
            width: double.infinity,
            height: 150, // Banner yüksekliği
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/logo/general_banner.png', // Banner resmi
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(AppConstants.paddingMedium),
                    child: Text(
                      "Duyurularım", // Banner içindeki yazı
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Duyurular Listesi
          Expanded(
            child: BlocConsumer<AnnouncementBloc, AnnouncementState>(
              listener: (context, state) {
                if (state is AnnouncementOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Operation Successful')));
                } else if (state is AnnouncementOperationFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Operation Failed')));
                      return;
                }
              },
              builder: (context, state) {
                if (state is AnnouncementsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AnnouncementsLoaded) {
                  if (state.announcements.isEmpty) {
                    return const Center(
                        child: Text('No announcements available.'));
                  } else {
                    return ListView.builder(
                      itemCount: state.announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = state.announcements[index];
                        final formattedDate = announcement.createdAt != null
                            ? DateFormat('dd.MM.yyyy')
                                .format(announcement.createdAt!)
                            : 'No date';
                        return Card(
                          color:Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.br16),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _showAnnouncementDetails(context, announcement);
                            },
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              size: 16.0),
                                          SizedBox(width: AppConstants.sizedBoxWidthSmall),
                                          Text(formattedDate, style: TextStyle(color: Colors.black,fontSize: 15),),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _showAnnouncementDetails(
                                              context, announcement);
                                        },
                                        child: const Text('Detaylar'),
                                      ),
                                      if (widget.role == UserRole.admin)
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            context
                                                .read<AnnouncementBloc>()
                                                .add(DeleteAnnouncement(
                                                    widget.classIds,
                                                    announcement.id!,
                                                    widget.role!));
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
                  return const Center(
                      child: Text('Failed to load announcements'));
                } else {
                 return const Center(
                      child: Text('Failed to load announcements'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}