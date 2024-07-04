import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_bloc.dart';
import 'package:tobetoapp/bloc/auth/auth_state.dart';
import 'package:tobetoapp/widgets/drawer/common_drawer.dart';
import 'package:tobetoapp/widgets/drawer/role_based_drawer.dart';

class DrawerManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return CircularProgressIndicator();
        } else if (state is AuthSuccess) {
          return RoleBasedDrawer();
        } else {
          return CommonDrawer();
        }
      },
    );

    /*
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return RoleBasedDrawer();
        } else {
          return CommonDrawer();
        }
      },
    );
  }
*/
  }
}
