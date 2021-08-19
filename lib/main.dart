import 'dart:async';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roubou/screen/IAP.dart';
//import 'package:roubou/screen/ad_state.dart';
import 'package:roubou/screen/setting/themes.dart';
import 'package:roubou/my_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roubou/dragon.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '1000ema.dart';
import 'br1000ema.dart';
import 'br200ema.dart';
import 'br50ema.dart';
import 'hk1000ema.dart';
import 'hk200ema.dart';
import 'hk50ema.dart';
import 'screen/ad_state.dart';

/// Run first apps open
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();}
  runApp(
      ProviderScope(child: MyApp()
    ),
  );
}

final hellowWorldProvider = Provider<String>((ref) => "PVSRA SCREENER");
// here the developer will write free or pro
final mobileAppVersionProvider = Provider<String>((ref) => "free");

class MyApp extends StatelessWidget {

  /// Create _themeBloc for double theme (Dark and White theme)
  ThemeBloc _themeBloc= ThemeBloc();

  @override
  Widget build(BuildContext context) {
    /// To set orientation always portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// StreamBuilder for themeBloc
    return StreamBuilder<ThemeData>(
      initialData: _themeBloc.initialTheme().data,
      stream: _themeBloc.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          title: 'Crypto Apps',
          theme: snapshot.data,
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),

          /// Move splash screen to onBoarding Layout
          /// Routes
          ///
          routes: <String, WidgetBuilder>{
            "/myHomePage": (BuildContext context) => MyHomePage(),
            "/dragon": (BuildContext context) => Dragon(),
            "/1000ema": (BuildContext context) => EMA1000(),
            "/iap": (BuildContext context) => IAP(),
            "/br200ema":(BuildContext context) => Br200(),
            "/br50ema":(BuildContext context) => Br50(),
            "/br1000ema":(BuildContext context) => Br1000(),
            "/hk200ema":(BuildContext context) => HK200(),
            "/hk50ema":(BuildContext context) => HK50(),
            "/hk1000ema":(BuildContext context) => HK1000(),
          },
        );
      },
    );
  }
}

class MyHomePage extends ConsumerWidget {

  @override
  void initState() {
    //super.initState();
  }
    final BannerAd _bannerAd = BannerAd(
      adUnitId: AdState.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(),
    )..load();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String text = watch(hellowWorldProvider);
    return Scaffold(
      appBar: AppBar(title: Text(text)),
      drawer: MyDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    var today = new DateTime.now();
    DateTime threedaysAgo = today.subtract(const Duration(days: 18));


    return
      Column(
          children: [
            Container(
                height: 50,
                width: 320,
                child: AdWidget(ad: _bannerAd,)),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('200ema')
                    .where('currentDate', isGreaterThanOrEqualTo: threedaysAgo)
                    .orderBy('currentDate', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  return _buildList(context, snapshot.data?.docs);
                },
              ),
            ),
          ]
      );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot!=null?snapshot.map((data) => _buildListItem(context, data)).toList():[Text("")],
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot? data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.stock),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.stock, softWrap: false,),
          subtitle: Text(timeago.format(record.currentDate.toDate()), softWrap: false,),
          trailing: SizedBox(width: 200.0, child:Text(record.companyName.toString()),),
          onTap: () => FirebaseFirestore.instance.runTransaction((transaction) async {
          }),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _bannerAd.dispose();
    // super.dispose();
  }
  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

}

class Record {
  final String stock;
  final String companyName;
  final Timestamp currentDate;
  final DocumentReference? reference;

  Record.fromMap(Map<String, dynamic>? map, {required this.reference})
      : assert(map?['stock'] != null),
        assert(map?['companyName'] != null),
        assert(map?['currentDate'] != null),

        stock = map?['stock'],
        companyName = map?['companyName'],
        currentDate = map?['currentDate'];

  Record.fromSnapshot(DocumentSnapshot? snapshot)
      : this.fromMap(snapshot?.data(), reference: snapshot?.reference);
}