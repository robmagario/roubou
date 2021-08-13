//import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:roubou/component/style.dart';
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
            },),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.handHoldingUsd),
            title: Text('1000EMA'),
            onTap: () {
              Navigator.pushNamed(context, '/1000ema');
            },),
          ListTile(
            leading: Icon(FontAwesomeIcons.coins),
            title: Text('Brazil 200EMA'),
            onTap: () {
              Navigator.pushNamed(context, '/br200ema');
            },),
          ListTile(
            leading: Icon(FontAwesomeIcons.searchDollar),
            title: Text('Brazil 50EMA'),
            onTap: () {
              Navigator.pushNamed(context, '/br50ema');
            },),
          ListTile(
            leading: Icon(FontAwesomeIcons.commentDollar),
            title: Text('Hong Kong 200EMA'),
            onTap: () {
              Navigator.pushNamed(context, '/hk200ema');
            },),
          ListTile(
            leading: Icon(FontAwesomeIcons.dollarSign),
            title: Text('Hong Kong 50EMA'),
            onTap: () {
              Navigator.pushNamed(context, '/br50ema');
            },),
        ],
      ),
    );
  }
}