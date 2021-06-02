import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roubou/screen/setting/themes.dart';
import 'package:roubou/my_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roubou/dragon.dart';

/// Run first apps open
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()),
  );
}

final hellowWorldProvider = Provider<String>((ref) => "PVSRA SCREENER");

class MyApp extends StatelessWidget {
 // final Widget child;

 // MyApp({Key key, this.child}) : super(key: key);

 // _MyAppState createState() => _MyAppState();
//}

//class _MyAppState extends State<MyApp> {
  /// Create _themeBloc for double theme (Dark and White theme)
  ThemeBloc _themeBloc= ThemeBloc();

  //@override
 // void initState() {
    // TODO: implement initState
    //super.initState();
 //   _themeBloc = ThemeBloc();
 // }

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
          },
        );
      },
    );
  }
}


/*
/// Component UI
class SplashScreen extends StatefulWidget {
  final ThemeBloc themeBloc;
  SplashScreen({this.themeBloc});
  @override
  _SplashScreenState createState() => _SplashScreenState(themeBloc);
}

/// Component UI
class _SplashScreenState extends State<SplashScreen> {
  ThemeBloc themeBloc;
  _SplashScreenState(this.themeBloc);
  //@override

  /// Setting duration in splash screen
  startTime() async {
    return new Timer(Duration(milliseconds: 4500), navigatorPage);
  }

  /// To navigate layout change
  void navigatorPage() {
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
                image: AssetImage('assets/image/launch_screen.png'),
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
*/
class MyHomePage extends ConsumerWidget {

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


    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('200ema')
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
          title: Text(record.stock),
          trailing: Text(record.companyName.toString()),
          onTap: () => FirebaseFirestore.instance.runTransaction((transaction) async {
          //  final freshSnapshot = await transaction.get(record.reference);
          //  final fresh = Record.fromSnapshot(freshSnapshot);

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

  //final int votes;
  final DocumentReference? reference;


  Record.fromMap(Map<String, dynamic>? map, {required this.reference})
      : assert(map?['stock'] != null),
        assert(map?['companyName'] != null),
  //  assert(map['votes'] != null),
        stock = map?['stock'],
        companyName = map?['companyName'];
  //  votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot? snapshot)
      : this.fromMap(snapshot?.data(), reference: snapshot?.reference);
}