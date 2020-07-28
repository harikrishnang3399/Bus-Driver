import 'package:android_intent/android_intent.dart';
import 'package:bus_driver/AppStateNotifier.dart';
import 'package:bus_driver/Report.dart';
import 'package:bus_driver/Settings.dart';
import 'package:bus_driver/SignOut.dart';
import 'package:bus_driver/TheDrawer.dart';
import 'package:bus_driver/ThemeForApp.dart';
import 'package:bus_driver/routes/Routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) => AppStateNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BusDriver(),
      ),
    ),
  );
}

class BusDriver extends StatefulWidget {
  static const String routeName = '/main';
  @override
  _BusDriverState createState() => _BusDriverState();
}

class _BusDriverState extends State<BusDriver> {
  AppStateNotifier appStateNotifier = AppStateNotifier();
  Geolocator geolocator = Geolocator();
  Firestore firestore = Firestore.instance;
  Geoflutterfire geoflutterfire = Geoflutterfire();
  var _selectedBusItem;
  var _selectedRouteItem;

  _start() async {
    print(_selectedBusItem);
    print(_selectedRouteItem);
    showAlert();
    if (!(await geolocator.isLocationServiceEnabled())) {
      _addGeoPoint();
    }
  }

  Future<void> showAlert() async {
    if (!(await geolocator.isLocationServiceEnabled())) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'GPS Location',
              style: TextStyle(
                color:
                    appStateNotifier.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            content: Text(
              'You need to turn on GPS location',
              style: TextStyle(
                color:
                    appStateNotifier.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            backgroundColor: appStateNotifier.isDarkMode
                ? Colors.grey[900]
                : Colors.grey[200],
            actions: [
              FlatButton(
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: appStateNotifier.isDarkMode
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (Theme.of(context).platform == TargetPlatform.android) {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                    await intent.launch();
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<DocumentReference> _addGeoPoint() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
    print(geolocator.isLocationServiceEnabled());
    print(context);
    var pos = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    print(pos);
    GeoFirePoint point =
        geoflutterfire.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore.collection('locations').add({
      'position': point.data,
      'name': 'I can be queried',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (BuildContext context, appState, Widget child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
            drawer: TheDrawer(),
            appBar: AppBar(
              title: Text('Bus Driver'),
            ),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: new Border.all(
                          color:
                              appState.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          child: DropdownButton(
                            value: _selectedBusItem,
                            dropdownColor: appState.isDarkMode
                                ? Colors.grey[900]
                                : Colors.grey[200],
                            hint: Text(
                              'Select Bus',
                              style: TextStyle(
                                fontSize: 16,
                                color: appState.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            items: <String>['Bus 1', 'Bus 2', 'Bus 3', 'Bus 4']
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: TextStyle(
                                    color: appState.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBusItem = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 150,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: new Border.all(
                          color:
                              appState.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: _selectedRouteItem,
                          dropdownColor: appState.isDarkMode
                              ? Colors.grey[900]
                              : Colors.grey[200],
                          hint: Text(
                            'Select Route',
                            style: TextStyle(
                              fontSize: 16,
                              color: appState.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          items: <String>['Punkunnam', 'Swaraj Round']
                              .map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(
                                value,
                                style: TextStyle(
                                  color: appState.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRouteItem = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          padding: EdgeInsets.all(12),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          splashColor: Colors.blueGrey,
                          child: Text('Start'),
                          onPressed: _selectedBusItem != null &&
                                  _selectedRouteItem != null
                              ? _start
                              : null,
                          animationDuration: Duration(milliseconds: 2),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          padding: EdgeInsets.all(12),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          splashColor: Colors.blueGrey,
                          child: Text('Clear'),
                          onPressed: _selectedBusItem != null ||
                                  _selectedRouteItem != null
                              ? () {
                                  print('Button pressed');
                                  setState(() {
                                    _selectedBusItem = null;
                                    _selectedRouteItem = null;
                                  });
                                }
                              : null,
                          animationDuration: Duration(milliseconds: 2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          routes: {
            Routes.main: (context) => BusDriver(),
            Routes.settings: (context) => Settings(),
            Routes.signout: (context) => SignOut(),
            Routes.report: (context) => Report(),
          },
        );
      },
    );
  }
}
