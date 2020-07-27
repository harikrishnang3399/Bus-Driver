import 'package:bus_driver/AppStateNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TheDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isDark =
        Provider.of<AppStateNotifier>(context, listen: false).isDarkMode;
    return SafeArea(
      child: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Harikrishnan G'),
              accountEmail: Text('hari.krishnan.g.0303@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
//                backgroundImage: AssetImage('images/hari.png'),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.teal,
              ),
              title: Text(
                'Home',
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/main', ModalRoute.withName('/main'));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.blueGrey[400],
              ),
              title: Text(
                'Settings',
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Text(
                'Sign Out',
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, '/signout');
              },
            ),
            Divider(
              color: isDark ? Colors.white : Colors.black,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.brightness_6,
                color: isDark ? Colors.white : Colors.black,
              ),
              title: Text(
                'Dark Mode',
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              trailing: Switch.adaptive(
                value: Provider.of<AppStateNotifier>(context, listen: false)
                    .isDarkMode,
                onChanged: (boolVal) {
                  Provider.of<AppStateNotifier>(context, listen: false)
                      .updateTheme(boolVal);
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.bug_report,
                color: Colors.green,
              ),
              title: Text(
                'Report Issue',
                textScaleFactor: 1.5,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, '/report');
              },
            ),
          ],
        ),
      ),
    );
  }
}
