import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roubou/screen/setting/themes.dart';
import 'package:roubou/my_drawer.dart';


class Dragon extends StatefulWidget {
  //Dragon({Key key, this.title}) : super(key: key);
 // final String title;

  @override
  _DragonState createState() => _DragonState();
}

class _DragonState extends State<Dragon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PVSRA Stock Screener')),
      drawer: MyDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    var today = new DateTime.now();
    DateTime threedaysAgo = today.subtract(const Duration(days: 3));

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('50ema')
          .where('currentDate', isGreaterThanOrEqualTo: threedaysAgo)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data?.docs);
      },
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
          title: Text(record.stock + record.currentDate.toString()),
          trailing: Text(record.companyName.toString()),
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