import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahakim/scoped-models/connecting-class.dart';

import '../scoped-models/connecting-class.dart';
import './logout_list_tile.dart';

class SideDrawer extends StatefulWidget {
  String pageRouteName;
  SideDrawer(this.pageRouteName);
  @override
  State<StatefulWidget> createState() {
    return _SideDrawerState();
  }
}

class _SideDrawerState extends State<SideDrawer> {
  bool _isDashboard = false;
  bool _isAbout = false;
  @override
  void initState() {
    super.initState();
    if (widget.pageRouteName == '/') {
      _isDashboard = true;
    } else if (widget.pageRouteName == '/about') {
      _isAbout = true;
    }
  }

  // DecorationImage _buildBackgroundImage() {
  //   return DecorationImage(
  //     colorFilter: ColorFilter.mode(
  //       Colors.black.withOpacity(0.3),
  //       BlendMode.dstATop,
  //     ),
  //     fit: BoxFit.cover,
  //     // image: AssetImage('assets/background.jpg'),
  //   );
  // }

  Widget _buildLogoImage() {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Image.asset('assets/logo.png'),
      width: 0.15 * deviceWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(0.05 * deviceWidth),
              height: 0.3 * deviceHeight,
              width: deviceWidth,
              decoration: BoxDecoration(
                // image: _buildBackgroundImage(),
                color: Theme.of(context).primaryColor.withOpacity(1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 0.04 * deviceHeight,
                  ),
                  _buildLogoImage(),
                  SizedBox(
                    height: 0.02 * deviceHeight,
                  ),
                  Text(
                    model.getUser == null ? "" : model.getUser.email,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'TitiliumWebSemiBold',
                        fontSize: 17),
                  ),
                  SizedBox(
                    height: 0.001 * deviceHeight,
                  ),
                ],
              ),
            ),
            Container(
              height: 0.7 * deviceHeight,
              child: ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.home),
                    selected: widget.pageRouteName == '/home' ? true : false,
                    title: Text(
                      'Dashboard',
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.info),
                    selected: widget.pageRouteName == '/about' ? true : false,
                    title: Wrap(
                      children: <Widget>[
                        Text(
                          'About',
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/about');
                    },
                  ),
                  Divider(),
                  LogoutListTile()
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
