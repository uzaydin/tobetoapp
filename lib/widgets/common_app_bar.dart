import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/homepage.dart';
import 'package:tobetoapp/utils/theme/constants/constants.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Homepage()));
        },
        child: SizedBox(
          width: AppConstants.screenWidth * 0.5,
          child: Image.asset(
            'assets/logo/tobetologo.PNG',
            fit: BoxFit.contain,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu))),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
