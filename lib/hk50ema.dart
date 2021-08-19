import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roubou/screen/ad_state.dart';
import 'package:roubou/my_drawer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screen/ad_state.dart';
import 'package:roubou/main.dart';

class HK50 extends ConsumerWidget {
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
    String text = watch(mobileAppVersionProvider);
    if (text=="free")
    {
      return Scaffold(
        appBar: AppBar(title: Text('HK 50EMA')),
        drawer: MyDrawer(),
        body: Center(child: Text("Sorry, this is only avaialbe on the pro version!")),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(title: Text('HK 50EMA')),
        drawer: MyDrawer(),
        body: _buildBody(context),
      );
    }
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
                stream: FirebaseFirestore.instance.collection('hk50ema')
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
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
            // final freshSnapshot = await transaction.get(record.reference);
            // final fresh = Record.fromSnapshot(freshSnapshot);

            //await transaction
            //     .update(record.reference, {'votes': fresh.votes + 1});
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

  //final int votes;
  final DocumentReference? reference;

  Record.fromMap(Map<String, dynamic>? map, {this.reference})
      : assert(map?['stock'] != null),
        assert(map?['companyName'] != null),
        assert(map?['currentDate'] != null),

  //  assert(map['votes'] != null),
        stock = map?['stock'],
        companyName = map?['companyName'],
        currentDate = map?['currentDate'];
  //  votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot? snapshot)
      : this.fromMap(snapshot?.data(), reference: snapshot?.reference);


}

