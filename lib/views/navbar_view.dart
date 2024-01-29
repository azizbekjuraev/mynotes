import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../utils/signout_dialog.dart';
import '../data/user_data.dart';

class DrowerWidgets {
  Widget appBarDrow(BuildContext context) {
    final userEmail = UserData.getUserEmail();
    final displayName = UserData.getDisplayName();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Row(
              children: [
                if (displayName != null) Text(displayName),
              ],
            ),
            accountEmail: Text(userEmail as String),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            otherAccountsPictures: [
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Friends'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {},
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Request'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Policies'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Exit'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () async {
              try {
                showSignOutConfirmationDialog(context);
              } catch (e) {
                print("$e");
              }
            },
          ),
        ],
      ),
    );
  }
}
