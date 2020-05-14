import 'package:flutter/material.dart';
import 'package:tahakim/widgets/side_drawer.dart';

class AboutPage extends StatelessWidget {
  Widget _buildLogoImage(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Hero(tag: 'logo', child: Image.asset('assets/logo.png')),
      width: 0.2 * deviceWidth,
    );
  }
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: SideDrawer('/about'),
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(deviceWidth * 0.05),
              child: Column(
                children: <Widget>[
                  _buildLogoImage(context),
                  SizedBox(
                    height: deviceWidth * 0.05,
                  ),
                  Text(
                    '     Aplikasi ini berfungsi sebagai user interface dari prototipe bendung yang bertujuan agar operator dapat memantau dan mengandalikan pintu air secara realtime, kapan dan dimana saja serta dapat diintegrasi dengan bangunan bendung yang tersebar di berbagai wilayah tanpa harus berada di sekitar bangunan bendung. ',
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: deviceWidth * 0.05,
                  ),
                  Text(
                    '     Prototipe ini ditargetkan untuk beroprasi secara otomatis dan manual. Kendali otomatis menggunakan metode jaringan syaraf tiruan bedasarkan data ketinggian dan debit air.',
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: deviceWidth * 0.05,
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: deviceWidth * 0.03,
                          ),
                          Center(
                            child: Text(
                              'Overview System',
                              style: TextStyle(
                                  fontFamily: 'MontserratBold', fontSize: 18),
                            ),
                          ),
                          Divider(),
                          Image.asset('assets/overview.jpeg'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
