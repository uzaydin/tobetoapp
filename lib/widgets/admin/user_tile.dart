import 'package:flutter/material.dart';
import 'package:tobetoapp/models/userModel.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final String userClassNames;
  final Function(BuildContext, UserModel) onLongPress;

  const UserTile({
    super.key,
    required this.user,
    required this.userClassNames,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('${user.firstName} ${user.lastName}'),
          subtitle: Text(
              'Email: ${user.email}\nRol: ${user.role?.name ?? ''}\nSınıf: $userClassNames'),
          onLongPress: () => onLongPress(context, user),
        ),
        const Divider(
          thickness: 1, // Çizginin kalınlığı
          color: Colors.grey, // Çizginin rengi
        ),
      ],
    );
  }
}