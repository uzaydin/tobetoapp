import 'package:flutter/material.dart';
import 'package:tobetoapp/screens/homepage.dart';

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
          width: 200.0,
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
