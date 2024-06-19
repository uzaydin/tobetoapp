import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';

class ClassDetailsPage extends StatelessWidget {
  final String classId;

  const ClassDetailsPage({required this.classId, super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AdminBloc>().add(LoadClassDetails(classId));

    return PopScope(
      onPopInvoked: (popped) {
        if (popped) {
          context.read<AdminBloc>().add(LoadClasses());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Class Details'),
        ),
        body: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ClassDetailsLoaded) {
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Users'),
                        Tab(text: 'Lessons'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              return ListTile(
                                title: Text('${user.firstName} ${user.lastName}'),
                                subtitle: Text('Email: ${user.email}'),
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: state.lessons.length,
                            itemBuilder: (context, index) {
                              final lesson = state.lessons[index];
                              return ListTile(
                                title: Text(lesson.title!),
                                subtitle: Text('Description: ${lesson.description}'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is AdminError) {
              return Center(child: Text('Failed to load class details: ${state.message}'));
            } else {
              return Center(child: Text('No class details found'));
            }
          },
        ),
      ),
    );
  }
}