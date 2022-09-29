import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/google_signin.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);

    return Drawer(
      child: Container(
        color: const Color.fromRGBO(50, 75, 205, 1),
        child: Column(children: [
          HeaderNavBar(user: user),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              color: Colors.white,
              thickness: 1,
            ),
          ),
          SingleNavItem(
            text: 'Investment',
            icon: Icons.money,
            voidCallback: () {},
          ),
          SingleNavItem(
            text: 'Logout',
            icon: Icons.logout,
            voidCallback: () {
              provider.logout();
            },
          ),
        ]),
      ),
    );
  }
}

class SingleNavItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback voidCallback;
  const SingleNavItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.voidCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: voidCallback,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
          ),
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderNavBar extends StatelessWidget {
  const HeaderNavBar({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              user.displayName!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              user.email!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
