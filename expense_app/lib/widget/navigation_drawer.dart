import 'package:expense_app/provider/auth.dart';
import 'package:expense_app/screens/SavingScreen.dart';
import 'package:expense_app/screens/SavingsCategory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/google_signin.dart';
import '../screens/InvesmentCategory.dart';
import '../screens/LoginScreen.dart';

class NavigationDrawerWidget extends StatefulWidget {
  NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  var user;

  @override
  Widget build(BuildContext context) {
    try {
      user = FirebaseAuth.instance.currentUser!;
    } catch (e) {
      print(e);
    }

    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(children: [
          user == null ? Container() : HeaderNavBar(user: user),
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
            voidCallback: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => InvestmentCategory(),
                ),
              );
            },
          ),
          SingleNavItem(
            text: 'Savings',
            icon: Icons.savings,
            voidCallback: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => SavingsCategory(),
                ),
              );
            },
          ),
          SingleNavItem(
            text: 'Logout',
            icon: Icons.logout,
            voidCallback: () {
              setState(() {
                user == null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => LoginScreen(),
                        ),
                      )
                    : provider.logout();
              });
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
        padding: const EdgeInsets.only(left: 8),
        child: ListTile(
          leading: Icon(
            icon,
            //#
            color: const Color(0xff9BA3DA),
          ),
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xff4B57A3),
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
    print('User: $user');
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: const Color(0xff4B57A3),
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
      ),
    );
  }
}
