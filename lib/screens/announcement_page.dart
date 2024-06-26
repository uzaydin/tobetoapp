import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tobetoapp/bloc/announcements/announcement_bloc.dart';
import 'package:tobetoapp/bloc/announcements/announcement_event.dart';
import 'package:tobetoapp/bloc/announcements/announcement_state.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/models/announcement_model.dart';
import 'package:tobetoapp/models/user_enum.dart';
import 'package:tobetoapp/screens/add_announcement.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';
import 'package:tobetoapp/widgets/announcement_card.dart';
import 'package:tobetoapp/widgets/banner_widget.dart';

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
    context
        .read<AnnouncementBloc>()
        .add(LoadAnnouncements(widget.classIds, widget.role));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tobeto'),
        centerTitle: true,
        actions:
            widget.role == UserRole.admin || widget.role == UserRole.teacher
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
      drawer: const DrawerManager(),
      body: Column(
        children: [
          const BannerWidget(
            imagePath: 'assets/logo/general_banner.png',
            text: 'Duyurularım',
          ),
          Expanded(
            child: BlocBuilder<AnnouncementBloc, AnnouncementState>(
              builder: (context, state) {
                if (state is AnnouncementsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AnnouncementsLoaded) {
                  if (state.announcements.isEmpty) {
                    return const Center(
                        child: Text('Henüz bir duyuru eklenmemiştir.'));
                  } else {
                    return ListView.builder(
                      itemCount: state.announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = state.announcements[index];
                        return AnnouncementCard(
                          announcement: announcement,
                          role: widget.role!,
                          classIds: widget.classIds!,
                        );
                      },
                    );
                  }
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
