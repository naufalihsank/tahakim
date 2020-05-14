import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahakim/models/data.dart';
import 'package:tahakim/scoped-models/connecting-class.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Chart extends StatefulWidget {
  String title;
  String kodeGerbang;

  Chart(this.title, this.kodeGerbang);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChartState();
  }
}

class _ChartState extends State<Chart> {
  MainModel modelLocal;
  List<dynamic> listKetinggian = [];
  List<Data> listKetinggianLast150 =
      []; // hanya 150 detik terakhir data saja, karena data bisa > 150 row
  List<Data> dataPoints = [];
  var lineChart;
  var series;

  FirebaseApp app;
  DatabaseReference itemRefWU;

  @override
  void initState() {
    super.initState();
    modelLocal = ScopedModel.of(context);
    // print(modelLocal.getlistKetinggianWU);
    getFirebase();
    // fetchData();
    // print(listKetinggianLast150);
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
    itemRefWU = database.reference().child(widget.kodeGerbang);
    itemRefWU.onChildAdded.listen(_onEntryChangedWU);
    itemRefWU.onChildChanged.listen(_onEntryChangedWU);
  }

  _onEntryChangedWU(Event event) {
    setState(() {
      fetchData();
      // if (widget.kodeGerbang == 'ketinggian1/wadahutama') {
      //   print(
      //       'Ketinggian Wadah Utama : ${modelLocal.getlistKetinggianWU.length}');
      // } else if (widget.kodeGerbang == 'ketinggian2/saluran1') {
      //   print(
      //       'Ketinggian Saluran 1 : ${modelLocal.getlistKetinggianSaluran1.length}');
      // } else if (widget.kodeGerbang == 'ketinggian3/saluran2') {
      //   print(
      //       'Ketinggian Saluran 2 : ${modelLocal.getlistKetinggianSaluran2.length}');
      // } else if (widget.kodeGerbang == 'debit1/buangan1') {
      //   print(
      //       'Ketinggian Aliran 1 : ${modelLocal.getlistKetinggianAliran1.length}');
      // } else if (widget.kodeGerbang == 'debit2/buangan2') {
      //   print(
      //       'Ketinggian Aliran 2 : ${modelLocal.getlistKetinggianAliran2.length}');
      // }

      // print('keganti live');
    });
  }

  void fetchData() {
    if (widget.kodeGerbang == 'ketinggian1/wadahutama') {
      listKetinggian = modelLocal.getlistKetinggianWU;
    } else if (widget.kodeGerbang == 'ketinggian2/saluran1') {
      listKetinggian = modelLocal.getlistKetinggianSaluran1;
    } else if (widget.kodeGerbang == 'ketinggian3/saluran2') {
      listKetinggian = modelLocal.getlistKetinggianSaluran2;
    } else if (widget.kodeGerbang == 'debit1/buangan1') {
      listKetinggian = modelLocal.getlistKetinggianAliran1;
    } else if (widget.kodeGerbang == 'debit2/buangan2') {
      listKetinggian = modelLocal.getlistKetinggianAliran2;
    }

    dataPoints = [];
    listKetinggianLast150 = [];

    if (listKetinggian.length >= 150) {
      int count = 149;
      for (var i = 0; i < 150; i++) {
        listKetinggianLast150.add(
          Data(
            time: i + 1,
            level: listKetinggian[listKetinggian.length - 1 - count],
          ),
        ); // index 0 adalah yang paling baru di Last150
        count -= 1;
      }
    } else {
      for (var i = 0; i < listKetinggian.length; i++) {
        listKetinggianLast150.add(
          Data(
            time: i + 1,
            level: listKetinggian[i],
          ),
        ); // index 0 adalah yang paling baru di Last150
      }
    }
    // print('List Ketinggian');
    // for (var item in listKetinggianLast150) {
    //   print('Detik : ${item.time}, Tinggi : ${item.level}');
    // }
    series = [];
    series = [
      charts.Series(
        domainFn: (Data data, _) =>
            data.time, // Property class Sales yang dijadikan sumbu x
        measureFn: (Data data, _) =>
            data.level, // Property class Sales yang dijadikan sumbu y
        colorFn: (Data data, _) => charts.MaterialPalette.blue.shadeDefault,
        id: 'WaterLevel',
        data: listKetinggianLast150,
        labelAccessorFn: (Data data, _) =>
            '${data.time} : ${data.level.toString()}', //buat label di chartnya, harus di aktifin juga di var chart nya
      ),
    ];

    lineChart = null;
    lineChart = charts.LineChart(
      series,
      animate: true,

      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        // color: Colors.red,
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(widget.title),
              ),
              SizedBox(
                height: deviceWidth * 0.8,
                child: lineChart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
