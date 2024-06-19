import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_bloc.dart';
import 'package:tobetoapp/bloc/admin/admin_event.dart';
import 'package:tobetoapp/bloc/admin/admin_state.dart';
import 'package:tobetoapp/models/userModel.dart';
import 'package:tobetoapp/models/user_enum.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadUserData());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.toLowerCase();
    final adminBlocState = context.read<AdminBloc>().state;
    if (adminBlocState is UsersDataLoaded) {
      setState(() {
        _filteredUsers = adminBlocState.users.where((user) {
          final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
          return fullName.contains(searchQuery);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Yönetimi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<AdminBloc, AdminState>(
              builder: (context, state) {
                if (state is AdminLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is UsersDataLoaded) {
                  final usersToDisplay = _searchController.text.isEmpty
                      ? state.users
                      : _filteredUsers;

                  return ListView.builder(
                    itemCount: usersToDisplay.length,
                    itemBuilder: (context, index) {
                      final user = usersToDisplay[index];
                      final userClassNames = user.classIds
                              ?.map((id) => state.classNames[id] ?? 'Unknown')
                              .join(', ') ??
                          'No class';

                      return ListTile(
                        title: Text('${user.firstName} ${user.lastName}'),
                        subtitle: Text(
                            'Email: ${user.email}\nRole: ${user.role?.name ?? ''}\nClass: $userClassNames'),
                        onLongPress: () => _showUserActions(context, user),
                      );
                    },
                  );
                } else if (state is AdminError) {
                  return Center(
                      child: Text('Failed to load users: ${state.message}'));
                } else {
                  return Center(child: Text('No users found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUserActions(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Add/Remove Role'),
              onTap: () {
                Navigator.pop(context);
                _showRoleDialog(context, user);
              },
            ),
            ListTile(
              leading: Icon(Icons.class_),
              title: Text('Add/Remove Class'),
              onTap: () {
                Navigator.pop(context);
                _showClassDialog(context, user);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete User'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(context, user);
              },
            ),
          ],
        );
      },
    );
  }

  void _showRoleDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rol Ekle/Çıkar'),
          content: DropdownButtonFormField<UserRole>(
            value: user.role,
            onChanged: (newRole) {
              if (newRole != null) {
                context
                    .read<AdminBloc>()
                    .add(UpdateUser(user.copyWith(role: newRole)));
              }
            },
            items: UserRole.values.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(role.name),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showClassDialog(BuildContext context, UserModel user) {
    context.read<AdminBloc>().add(LoadClassNamesForUser(user));

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            if (state is ClassNamesForUserLoaded) {
              return AlertDialog(
                title: Text('Add/Remove Class'),
                content: DropdownSearch<String>.multiSelection(
                  items: state.classNames.values.toList(),
                  selectedItems: user.classIds
                          ?.map((id) => state.classNames[id] ?? 'Unknown')
                          .toList() ??
                      [],
                  onChanged: (List<String> selectedItems) {
                    final selectedIds = selectedItems
                        .map((name) => state.classNames.entries
                            .firstWhere((entry) => entry.value == name)
                            .key)
                        .toList();
                    context
                        .read<AdminBloc>()
                        .add(UpdateUser(user.copyWith(classIds: selectedIds)));
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AdminBloc>().add(
                          LoadUserData()); // UI'ı güncellemek için eklenen satır
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            } else if (state is AdminLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AdminError) {
              return Center(
                  child: Text('Failed to load classes: ${state.message}'));
            } else {
              return Center(child: Text('No classes found'));
            }
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AdminBloc>().add(DeleteUser(user.id!));
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}