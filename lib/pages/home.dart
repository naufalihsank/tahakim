import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahakim/models/wadahutama.dart';
import 'package:tahakim/scoped-models/connecting-class.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tahakim/widgets/chart.dart';
import 'package:tahakim/widgets/side_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  MainModel modelLocal;
  dynamic ketinggianWU = 0;
  dynamic ketinggianP1 = 0;
  dynamic ketinggianP2 = 0;
  dynamic ketinggianAliran1 = 0;
  dynamic ketinggianAliran2 = 0;
  bool isGate1 = false;
  bool isGate2 = false;
  bool statusModeKontrol = false;
  bool statusGate1 = false;
  bool statusGate2 = false;
  bool isSiaga1 = false;
  bool isSiaga2 = false;
  bool isSiaga3 = false;
  bool isSiaga4 = false;

  FirebaseApp app;
  DatabaseReference itemRefWU;
  DatabaseReference itemRefP1;
  DatabaseReference itemRefP2;
  DatabaseReference itemRefAliran1;
  DatabaseReference itemRefAliran2;
  DatabaseReference itemRefGate1;
  DatabaseReference itemRefGate2;
  DatabaseReference itemRefModeKontrol;

  @override
  void initState() {
    super.initState();
    modelLocal = ScopedModel.of(context);
    getFirebase();
    // fetchKetinggian();
  }

  void getFirebase() async {
    app = await FirebaseApp.configure(
      name: "tahakim",
      options: FirebaseOptions(
        googleAppID: "1:220406972004:android:71ea559181ee1ea890e971",
        apiKey: "AIzaSyAZAXo-YV2-VHNeHpRCmrAyHTSfXSo_SHU",
        databaseURL: "https://cobalagilagi6969.firebaseio.com",
      ),
    );
    final FirebaseDatabase database = FirebaseDatabase(app: app);
    itemRefWU = database.reference().child('ketinggian1/wadahutama');
    itemRefWU.onChildAdded.listen(_onEntryChangedWU);
    itemRefWU.onChildChanged.listen(_onEntryChangedWU);
    itemRefP1 = database.reference().child('ketinggian2/saluran1');
    itemRefP1.onChildAdded.listen(_onEntryChangedP1);
    itemRefP1.onChildChanged.listen(_onEntryChangedP1);
    itemRefP2 = database.reference().child('ketinggian3/saluran2');
    itemRefP2.onChildAdded.listen(_onEntryChangedP2);
    itemRefP2.onChildChanged.listen(_onEntryChangedP2);
    itemRefAliran1 = database.reference().child('debit1/buangan1');
    itemRefAliran1.onChildAdded.listen(_onEntryChangedAliran1);
    itemRefAliran1.onChildChanged.listen(_onEntryChangedAliran1);
    itemRefAliran2 = database.reference().child('debit2/buangan2');
    itemRefAliran2.onChildAdded.listen(_onEntryChangedAliran2);
    itemRefAliran2.onChildChanged.listen(_onEntryChangedAliran2);
    itemRefGate1 = database.reference().child('gerbang1');
    itemRefGate1.onChildAdded.listen(_onEntryChangedGate1);
    itemRefGate1.onChildChanged.listen(_onEntryChangedGate1);
    itemRefGate2 = database.reference().child('gerbang2');
    itemRefGate2.onChildAdded.listen(_onEntryChangedGate2);
    itemRefGate2.onChildChanged.listen(_onEntryChangedGate2);
    itemRefGate2 = database.reference().child('controltab');
    itemRefGate2.onChildAdded.listen(_onEntryChangedKontrolTab);
    itemRefGate2.onChildChanged.listen(_onEntryChangedKontrolTab);
  }

  _onEntryChangedWU(Event event) {
    setState(() {
      ketinggianWU = WadahUtama.fromSnapShot(event.snapshot).value;
      modelLocal.addKetinggianWU(ketinggianWU);
      // print(modelLocal.getlistKetinggianWU.length);
      // print('keganti live');
      if (ketinggianWU >= 0 && ketinggianWU < 3.25) {
        isSiaga1 = false;
        isSiaga2 = false;
        isSiaga3 = false;
        isSiaga4 = true;
      } else if (ketinggianWU >= 3.25 && ketinggianWU < 6.5) {
        isSiaga1 = false;
        isSiaga2 = false;
        isSiaga3 = true;
        isSiaga4 = false;
      } else if (ketinggianWU >= 6.5 && ketinggianWU < 9.75) {
        isSiaga1 = false;
        isSiaga2 = true;
        isSiaga3 = false;
        isSiaga4 = false;
      } else if (ketinggianWU >= 9.75) {
        isSiaga1 = true;
        isSiaga2 = false;
        isSiaga3 = false;
        isSiaga4 = false;
      }
    });
  }

  _onEntryChangedP1(Event event) {
    setState(() {
      ketinggianP1 = WadahUtama.fromSnapShot(event.snapshot).value;
      modelLocal.addKetinggianSaluran1(ketinggianP1);
    });
  }

  _onEntryChangedP2(Event event) {
    setState(() {
      ketinggianP2 = WadahUtama.fromSnapShot(event.snapshot).value;
      modelLocal.addKetinggianSaluran2(ketinggianP2);
    });
  }

  _onEntryChangedAliran1(Event event) {
    setState(() {
      ketinggianAliran1 = WadahUtama.fromSnapShot(event.snapshot).value;
      modelLocal.addKetinggianAliran1(ketinggianAliran1);
    });
  }

  _onEntryChangedAliran2(Event event) {
    setState(() {
      ketinggianAliran2 = WadahUtama.fromSnapShot(event.snapshot).value;
      modelLocal.addKetinggianAliran2(ketinggianAliran2);
    });
  }

  _onEntryChangedGate1(Event event) {
    setState(() {
      isGate1 = WadahUtama.fromSnapShot(event.snapshot).value;
    });
  }

  _onEntryChangedGate2(Event event) {
    setState(() {
      isGate2 = WadahUtama.fromSnapShot(event.snapshot).value;
    });
  }

  _onEntryChangedKontrolTab(Event event) {
    setState(() {
      statusModeKontrol = WadahUtama.fromSnapShot(event.snapshot).value;
    });
  }

  // void fetchKetinggian() async {
  //   ketinggian = await modelLocal.fetchData();
  //   // print('Ketinggian : ' + ketinggian.toString());
  //   if (ketinggian >= 0 && ketinggian < 3.25) {
  //     isSiaga1 = false;
  //     isSiaga2 = false;
  //     isSiaga3 = false;
  //     isSiaga4 = true;
  //   } else if (ketinggian >= 3.25 && ketinggian < 6.5) {
  //     isSiaga1 = false;
  //     isSiaga2 = false;
  //     isSiaga3 = true;
  //     isSiaga4 = false;
  //   } else if (ketinggian >= 6.5 && ketinggian < 9.75) {
  //     isSiaga1 = false;
  //     isSiaga2 = true;
  //     isSiaga3 = false;
  //     isSiaga4 = false;
  //   } else if (ketinggian >= 9.75) {
  //     isSiaga1 = true;
  //     isSiaga2 = false;
  //     isSiaga3 = false;
  //     isSiaga4 = false;
  //   }
  // }

  Widget _buildLogoImage() {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(deviceWidth * 0.02),
      child: Image.asset('assets/logo.png'),
      // width: 0.6 * deviceWidth,
    );
  }

  Widget _buildBarPercentage(String title, double percentage, Color color) {
    final deviceWidth = MediaQuery.of(context).size.width;
    // print("INI BAR PERCENT");
    // print(percentage);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        SizedBox(
          height: deviceWidth * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            LinearPercentIndicator(
              width: deviceWidth * 0.65,
              lineHeight: 14.0,
              percent: percentage,
              backgroundColor: Colors.grey.withOpacity(0.2),
              progressColor: color,
            ),
            Text(
              (percentage * 100).toStringAsFixed(1) + '%',
              style: TextStyle(
                fontSize: deviceWidth * 0.03,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGate(String gateNumber, bool isGate) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Text('Gate $gateNumber'),
        SizedBox(
          height: deviceWidth * 0.01,
        ),
        Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor:
                  isGate ? Colors.green : Colors.grey.withOpacity(0.2),
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.01,
            ),
            CircleAvatar(
              backgroundColor:
                  isGate ? Colors.grey.withOpacity(0.2) : Colors.red,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGateRow() {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildGate('1', isGate1),
        _buildGate('2', isGate2),
      ],
    );
  }

  Widget _buildMainCard() {
    final deviceWidth = MediaQuery.of(context).size.width;
    // print("ini ketinggian WU");
    // print(ketinggianWU);
    return Card(
      child: Container(
        padding: EdgeInsets.all(deviceWidth * 0.05),
        width: deviceWidth,
        // color: Colors.red,
        child: Column(
          children: <Widget>[
            Text('MAIN'),
            Divider(),
            SizedBox(
              height: deviceWidth * 0.05,
            ),
            _buildBarPercentage(
                'Bendung Utama',
                double.parse((ketinggianWU / 30).toStringAsFixed(2)),
                Colors.red),
            _buildBarPercentage(
                'Level Saluran Pembuangan 1',
                double.parse((ketinggianP1 / 30).toStringAsFixed(2)),
                Colors.yellow),
            _buildBarPercentage(
                'Level Saluran Pembuangan 2',
                double.parse((ketinggianP2 / 30).toStringAsFixed(2)),
                Colors.blue),
            SizedBox(
              height: deviceWidth * 0.05,
            ),
            _buildGateRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlTab() {
    final deviceWidth = MediaQuery.of(context).size.width;

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Card(
        child: Container(
          padding: EdgeInsets.all(deviceWidth * 0.05),
          width: deviceWidth,
          child: Column(
            children: <Widget>[
              Text('CONTROL TAB'),
              Divider(),
              Text('Mode Kontrol'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Auto'),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        model.postModeKontrol(true);
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text('Manual'),
                    textColor: Colors.white,
                    color: Color(0xfff8b739),
                    onPressed: () {
                      setState(() {
                        model.postModeKontrol(false);
                      });
                    },
                  ),
                ],
              ),
              Text('Status : ${statusModeKontrol ? "Auto" : "Manual"}'),
              Divider(),
              Text('Manual Gate 1'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Open'),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      if (statusModeKontrol) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('An Error Occurred !'),
                                content: Text(
                                    'Anda sedang berada pada mode kontrol auto.'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Okay'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        model.postManualGate('1', true);
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text('Close'),
                    textColor: Colors.white,
                    color: Color(0xfff8b739),
                    onPressed: () {
                      if (statusModeKontrol) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('An Error Occurred !'),
                                content: Text(
                                    'Anda sedang berada pada mode kontrol auto.'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Okay'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        model.postManualGate('1', false);
                      }
                    },
                  ),
                ],
              ),
              Text('Status : ${statusModeKontrol ? "-" : isGate1 == true ? "Open" : "Close"}'),
              Divider(),
              Text('Manual Gate 2'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Open'),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      if (statusModeKontrol) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('An Error Occurred !'),
                                content: Text(
                                    'Anda sedang berada pada mode kontrol auto.'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Okay'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        model.postManualGate('2', true);
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text('Close'),
                    textColor: Colors.white,
                    color: Color(0xfff8b739),
                    onPressed: () {
                      if (statusModeKontrol) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('An Error Occurred !'),
                                content: Text(
                                    'Anda sedang berada pada mode kontrol auto.'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Okay'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        model.postManualGate('2', false);
                      }
                    },
                  ),
                ],
              ),
              Text('Status : ${statusModeKontrol ? "-": isGate2 == true ? "Open" : "Close"}'),
            ],
          ),
        ),
      );
    });
  }

  _buildSiagaCard(String title, Color color, bool isOn) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: isOn ? color : Colors.grey.withOpacity(0.4),
      ),
      padding: EdgeInsets.all(deviceWidth * 0.05),
      width: deviceWidth * 0.4,
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'MontserratBold',
        ),
      ),
    );
  }

  Widget _buildSiagaGrid() {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildSiagaCard('SIAGA 1', Color(0xffc70d3a), isSiaga1),
            _buildSiagaCard('SIAGA 2', Color(0xfff8b739), isSiaga2),
          ],
        ),
        SizedBox(
          height: deviceWidth * 0.03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildSiagaCard('SIAGA 3', Colors.blue, isSiaga3),
            _buildSiagaCard('SIAGA 4', Colors.green, isSiaga4),
          ],
        )
      ],
    );
  }

  Widget _buildInfoCardBendungUtama(String title, String value, Color color) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.025),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFaaaaaa),
            offset: Offset(5.0, 5.0),
            blurRadius: 5.0,
          )
        ],
      ),
      width: deviceWidth * 0.4,
      padding: EdgeInsets.all(deviceWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'TitilliumWebSemiBold',
                  // fontSize:
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            minRadius: 25,
            child: SvgPicture.asset(
              'assets/dam.svg',
              color: color,
              width: deviceWidth * 0.08,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color, String icon) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFaaaaaa),
            offset: Offset(3.0, 3.0),
            blurRadius: 5.0,
          )
        ],
      ),
      width: deviceWidth * 0.415,
      // color: color,
      padding: EdgeInsets.all(deviceWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color,
            minRadius: 18,
            child: SvgPicture.asset(
              'assets/$icon.svg',
              color: Colors.white,
              width: deviceWidth * 0.08,
            ),
          ),
          Container(
            color: Colors.white,
            width: deviceWidth,
            height: deviceWidth * 0.001,
          ),
          SizedBox(
            height: deviceWidth * 0.03,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',

              // fontSize: 11,
            ),
          ),
          SizedBox(
            height: deviceWidth * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'TitilliumWebSemiBold',
                      ),
                    ),
                  ),
                  // title == 'Aliran 1' || title == 'Aliran 2'
                  //     ? Text(
                  //         'ml/menit',
                  //         style: TextStyle(color: Colors.white),
                  //       )
                  //     : Container(),
                ],
              ),
              // CircleAvatar(
              //   backgroundColor: Colors.white,
              //   minRadius: 25,
              //   child: SvgPicture.asset(
              //     'assets/$icon.svg',
              //     color: color,
              //     width: deviceWidth * 0.08,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageContent() {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _buildMainCard(),
          modelLocal.getUser.email == 'maulanahs69@gmail.com'
              ? _buildControlTab()
              : Container(),
          SizedBox(
            height: deviceWidth * 0.02,
          ),
          _buildSiagaGrid(),
          SizedBox(
            height: deviceWidth * 0.02,
          ),
          _buildInfoCardBendungUtama(
              'Bendung Utama',
              '${ketinggianWU.toStringAsFixed(2)} cm',
              Theme.of(context).primaryColor),
          SizedBox(
            height: deviceWidth * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildInfoCard(
                  'Level Saluran Pembuangan 1',
                  '${ketinggianP1.toStringAsFixed(2)} cm',
                  Color(0xff589167),
                  'height'),
              _buildInfoCard(
                  'Level Saluran Pembuangan 2',
                  '${ketinggianP2.toStringAsFixed(2)} cm',
                  Color(0xff5893d4),
                  'height'),
            ],
          ),
          SizedBox(
            height: deviceWidth * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildInfoCard(
                  'Aliran 1',
                  '${ketinggianAliran1.toStringAsFixed(2)} liter',
                  Color(0xfff8b739),
                  'sea'),
              _buildInfoCard(
                  'Aliran 2',
                  '${ketinggianAliran2.toStringAsFixed(2)} liter',
                  Color(0xfff8b739),
                  'sea'),
            ],
          ),
          SizedBox(
            height: deviceWidth * 0.1,
          ),
          Chart('Bendung Utama', 'ketinggian1/wadahutama'),
          SizedBox(
            height: deviceWidth * 0.1,
          ),
          Chart('Level Saluran Pembuangan 1', 'ketinggian2/saluran1'),
          SizedBox(
            height: deviceWidth * 0.1,
          ),
          Chart('Level Saluran Pembuangan 2', 'ketinggian3/saluran2'),
          SizedBox(
            height: deviceWidth * 0.1,
          ),
          Chart('Aliran 1', 'debit1/buangan1'),
          SizedBox(
            height: deviceWidth * 0.1,
          ),
          Chart('Aliran 2', 'debit2/buangan2'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        drawer: SideDrawer('/home'),
        appBar: AppBar(
          title: Text('Kiro Dam Interface'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // fetchKetinggian();
          },
          child: model.getIsLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _pageContent(),
        ),
      );
    });
  }
}
