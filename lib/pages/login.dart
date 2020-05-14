import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import '../scoped-models/connecting-class.dart';

class LoginPage extends StatefulWidget {
  MainModel model;

  LoginPage(this.model);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'username': null,
    'password': null,
    'name': null,
  };
  

  

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    // await widget.model.fetchSummary();
    // widget.model.fetchLot();
    _formKey.currentState.save();
    Map<String, dynamic> successInformation =
        await authenticate(_formData['username'], _formData['password']);
    // _loginFireBase(widget.model);
    // print('baru beres authenticate');

    // print(successInformation);

    if (!successInformation['success']) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An Error Occurred !'),
              content: Text(successInformation['message']),
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
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.dstATop,
      ),
      fit: BoxFit.cover,
      image: AssetImage('assets/background.jpg'),
    );
  }

  Widget _buildLogoImage() {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Image.asset('assets/logo.png'),
      width: 0.3 * deviceWidth,
    );
  }

  Widget _buildUsernameTextField() {
    // _titleTextController.text = product.title;

    return TextFormField(
      initialValue: 'maulanahs69@gmail.com',
      decoration: InputDecoration(
          hasFloatingPlaceholder: false,
          fillColor: Colors.white,
          filled: true,
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(8)))
          // border: ,
          ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Email is required and should email format ';
        }
      },
      onSaved: (String value) {
        _formData['username'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      initialValue: '12345678',
      decoration: InputDecoration(
          hasFloatingPlaceholder: false,
          fillColor: Colors.white,
          filled: true,
          labelText: 'Password',
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(8)))),
      obscureText: true, //agar text password tidak terlihat
      // controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length <= 5) {
          //di firebase, password harus memiliki minimal 6 char
          return 'Password is required';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildLoginButton() {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.getIsLoading
          ? CircularProgressIndicator()
          : GestureDetector(
              child: Container(
                width: deviceWidth * 0.8,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color(0xFFaaaaaa),
                  //     offset: Offset(5.0, 5.0),
                  //     blurRadius: 5.0,
                  //   )
                  // ],
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              onTap: () async {
                _submitForm(model.authenticate);
              },
              // onTap: () => check
              //         ? _fetchversion()
              //         : _submitForm(model.authenticate),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // image: _buildBackgroundImage(),
          color: Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.only(
          right: 0.1 * deviceWidth,
          left: 0.1 * deviceWidth,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildLogoImage(),
                    SizedBox(
                      height: 0.04 * deviceHeight,
                    ),
                    _buildUsernameTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildLoginButton(),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
