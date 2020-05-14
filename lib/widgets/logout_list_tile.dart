import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:tahakim/scoped-models/connecting-class.dart';


class LogoutListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout', style: TextStyle(fontFamily: 'Montserrat'),),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
            model.logout();
          },
        );
      },
    );
  }
}
