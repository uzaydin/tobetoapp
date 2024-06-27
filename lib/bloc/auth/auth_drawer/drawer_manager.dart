import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tobetoapp/bloc/auth/auth_drawer/auth_provider_drawer.dart';
import 'package:tobetoapp/repository/auth_repo.dart';
import 'package:tobetoapp/widgets/drawer/admin_drawer.dart';
import 'package:tobetoapp/widgets/drawer/common_drawer.dart';
import 'package:tobetoapp/widgets/drawer/student_drawer.dart';
import 'package:tobetoapp/widgets/drawer/teacher_drawer.dart';

class DrawerManager extends StatelessWidget {
  const DrawerManager({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderDrawer>(context, listen: true);
    final authRepository = AuthRepository();
    final user = authRepository.getCurrentUser();

    return Consumer<AuthProviderDrawer>(
      builder: (context, authProvider, _) {
        if (!authProvider.isLoggedIn) {
          return const CommonDrawer();
        } else {
          return FutureBuilder<String?>(
            future: authRepository.getUserRole(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const CommonDrawer();
              } else {
                final userRole = snapshot.data ?? 'student';

                switch (userRole) {
                  case 'teacher':
                    return const TeacherDrawer();
                  case 'admin':
                    return const AdminDrawer();
                  case 'student':
                  default:
                    return const StudentDrawer();
                }
              }
            },
          );
        }
      },
    );

/*
    return Consumer<AuthProviderDrawer>(
      builder: (context, authProvider, _) {
        if (!authProvider.isLoggedIn) {
          return const CommonDrawer();
        } else {
          return FutureBuilder<String?>(
            future: authRepository.getUserRole(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const CommonDrawer();
              } else if (!snapshot.hasData) {
                return const CommonDrawer();
              } else {
                final userRole = snapshot.data;
                switch (userRole) {
                  case 'teacher':
                    return const TeacherDrawer();
                  case 'admin':
                    return const AdminDrawer();
                  case 'student':
                  default:
                    return const CommonUserDrawer();
                }
              }
            },
          );
        }
      },
    );
  */
/*
    return authProvider.isLoggedIn
        ? FutureBuilder<String?>(
            future: authRepository.getUserRole(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const CommonDrawer();
              } else {
                final userRole = snapshot.data;
                switch (userRole) {
                  case 'teacher':
                    return const TeacherDrawer();
                  case 'admin':
                    return const AdminDrawer();
                  case 'student':
                  default:
                    return const CommonUserDrawer();
                }
              }
            },
          )
        : const CommonDrawer();
*/
/*
    if (!authProvider.isLoggedIn) {
      return const CommonDrawer();
    } else {
      switch (authProvider.userRole) {
        case 'teacher':
          return const TeacherDrawer();
        case 'admin':
          return const AdminDrawer();
        case 'student':
        default:
          return const CommonUserDrawer();
      }
    }
    */
  }
}
