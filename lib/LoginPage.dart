import 'package:flutter/material.dart';
import 'package:my_daily_life/Home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controllerUser = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _statusLogin = "";
  Color _statusColor = Colors.red;
  String _allowedUser = "admin";
  String _allowedPassword = "231";

  void _logar() {
    String user = _controllerUser.text.trim();
    String password = _controllerPassword.text.trim();
    _statusColor = Colors.red;

    if (user.isEmpty) {
      setState(() {
        _statusLogin = "Preencha o campo usuário.";
      });
    } else if (password.isEmpty) {
      setState(() {
        _statusLogin = "Preencha o campo senha.";
      });
    } else if (user != _allowedUser) {
      setState(() {
        _statusLogin = "Usuário não registrado.";
      });
    } else if (password != _allowedPassword) {
      setState(() {
        _statusLogin = "Senha incorreta.";
      });
    } else {
      setState(() {
        _statusColor = Colors.lightGreen;
        _statusLogin = "Logando...";
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        _limparCampos();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      });
    }
  }

  void _limparCampos() {
    _controllerUser.text = "";
    _controllerPassword.text = "";
    setState(() {
      _statusLogin = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "My Daily Login",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget> [
          Image.asset(
            "../img/My_Daily_Life_Icon.png",
            height: 280,
          ),
          TextField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(labelText: "Digíte seu nome."),
            style: TextStyle(fontSize: 22),
            controller: _controllerUser,
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Digíte sua senha."),
            style: TextStyle(fontSize: 22),
            obscureText: true,
            maxLength: 8,
            controller: _controllerPassword,
          ),
          //ignore: deprecated_member_use
          RaisedButton(
            color: Colors.black,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              "Logar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            onPressed: _logar,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              _statusLogin,
              style: TextStyle(
                color: _statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}