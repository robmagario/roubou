import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roubou/screen/setting/themes.dart';

/// Run first apps open
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myApp());
}

class myApp extends StatefulWidget {
  final Widget child;

  myApp({Key key, this.child}) : super(key: key);

  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  /// Create _themeBloc for double theme (Dark and White theme)
  ThemeBloc _themeBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _themeBloc = ThemeBloc();
  }

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
          home: SplashScreen(
            themeBloc: _themeBloc,
          ),

          /// Move splash screen to onBoarding Layout
          /// Routes
          ///
          routes: <String, WidgetBuilder>{
            "myHomePage": (BuildContext context) =>
                MyHomePage(title: 'PVSRA Stock Screener')
          },
        );
      },
    );
  }
}

/// Component UI
class SplashScreen extends StatefulWidget {
  ThemeBloc themeBloc;
  SplashScreen({this.themeBloc});
  @override
  _SplashScreenState createState() => _SplashScreenState(themeBloc);
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  ThemeBloc themeBloc;
  _SplashScreenState(this.themeBloc);
  @override

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 4500), NavigatorPage);
  }

  /// To navigate layout change
  void NavigatorPage() {
    Navigator.of(context).pushReplacementNamed("myHomePage");
  }

  /// Declare startTime to InitState
  @override
  void initState() {
    super.initState();
    startTime();
  }

  /// Code Create UI Splash Screen
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        /// Set Background image in splash screen layout (Click to open code)
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/splash_screen.png'),
                fit: BoxFit.cover)),
        child: Container(
          /// Set gradient black in image splash screen (Click to open code)
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.1),
                    Color.fromRGBO(0, 0, 0, 0.1)
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter)),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/image/logo.png", height: 35.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 17.0, top: 7.0),
                        child: Text(
                          "PVSRA Screener",
                          style: TextStyle(
                              fontFamily: "Sans",
                              color: Colors.white,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 3.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PVSRA Stock Screener')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    // return _buildList(context, dummySnapshot);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('stocks').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
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
          title: Text(record.stock),
          trailing: Text(record.stock.toString()),
          onTap: () => FirebaseFirestore.instance.runTransaction((transaction) async {
            final freshSnapshot = await transaction.get(record.reference);
            final fresh = Record.fromSnapshot(freshSnapshot);

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

  //final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Stock'] != null),
  //  assert(map['votes'] != null),
        stock = map['Stock'];

  //  votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
 // @override
 // String toString() => "Record<$name:$votes>";




/*
class _MyHomePageState extends State<MyHomePage> {
 // final dbRef = FirebaseDatabase.instance.reference().child("Stocks");
 // var lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Stock Screener",
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 30,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic)),
                  FutureBuilder(
                      future: dbRef.once(),
                      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          lists.clear();
                          Map<dynamic, dynamic> values = snapshot.data.value;
                          values.forEach((key, values) {
                            lists.add(values);
                          });
                          return new ListView.builder(
                              shrinkWrap: true,
                              itemCount: lists.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Stock:" + lists[index]['Stock']),

                                    ],
                                  ),
                                );
                              });
                        }
                        return CircularProgressIndicator();
                      })
                ]),
          )),
    );
  }
}
*/