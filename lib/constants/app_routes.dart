import 'package:flutter/material.dart';
import 'package:roubou/main.dart';
import 'package:roubou/dragon.dart';
import 'package:roubou/screen/IAP.dart';

import '../1000ema.dart';
import '../br1000ema.dart';
import '../br200ema.dart';
import '../br50ema.dart';
import '../hk1000ema.dart';
import '../hk200ema.dart';
import '../hk50ema.dart';


var appRoutes = <String, WidgetBuilder>{
 // '/': (context) => MyApp(),
  '/dragon': (context) => Dragon(),
  '/1000ema': (context) => EMA1000(),
  '/iap': (context) => IAP(),
  '/br200ema':(context) => Br200(),
  '/br50ema':(context) => Br50(),
  '/br1000ema':(context) => Br1000(),
  '/hk200ema':(context) => HK200(),
  '/hk50ema':(context) => HK50(),
  '/hk1000ema':(context) => HK1000(),
};

//