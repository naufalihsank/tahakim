// AKUN FIREBASE
// maulanahs69@gmail.com
// uye993it86



import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/rendering.dart';
import 'package:tahakim/pages/about.dart';
// import 'pages/chart.dart';
import 'package:tahakim/pages/home.dart';
import 'package:tahakim/scoped-models/connecting-class.dart';
import 'pages/login.dart';


void main() {
  // debugPaintSizeEnabled = true;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'DataPohon',
        theme: ThemeData(
            primaryColor: Color(0xff373a6d),
            accentColor: Color(0xffFFAF06),
            fontFamily: 'Montserrat'),
        debugShowCheckedModeBanner: false,
        // home: LoginPage(),
        routes: {
          '/': (BuildContext context) =>LoginPage(_model),
          '/home': (BuildContext context) => HomePage(),
          '/about': (BuildContext context) => AboutPage(),
          // '/chart': (BuildContext context) => ChartPage(),
          // '/lot': (BuildContext context) =>
          //     LotPage() // Ini sama juga kayak propety homenya MaterialApp
        },
      ),
    );
  }
}
