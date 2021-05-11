import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:roubou/component/style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyDrawer extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //final _auth = watch(authServicesProvider);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
           decoration: BoxDecoration(
              //color: myTheme.primaryColor,
            ),
          ),
          ListTile(
          leading: Icon(FontAwesomeIcons.balanceScale),
          title: Text('200EMA'),
          onTap: () {
          Navigator.pushNamed(context, '/myHomePage');
          },),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.dragon),
            title: Text('Dragon 50EMA'),
            onTap: () {
              Navigator.pushNamed(context, '/dragon');
            },
          ),
        ],
      ),
    );
  }
}