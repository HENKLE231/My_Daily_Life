import 'package:flutter/material.dart';
import 'package:my_daily_life/DiaryPage.dart';
import 'package:my_daily_life/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  List<String> _titles = [];
  List<String> _pages = [];

  void initState() {
    _loadPages();
    Future.delayed(const Duration(milliseconds: 1), () {
      setState(() {
        _showPages();
      });
    });
  }

  void _loadPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _titles = prefs.getStringList("titles") ?? [];
    _pages = prefs.getStringList("pages") ?? [];
  }

  TextEditingController _controllerNewPageTitle = TextEditingController();

  // Para verificar se o nome já foi usado
  String _checkAvailability() {
    String newPageTitle = _controllerNewPageTitle.text.trim();
    _controllerNewPageTitle.text = "";
    if (newPageTitle.isEmpty) {
      newPageTitle = _getDate();
    }
    String initialNewPageTitle = newPageTitle;

    bool acceptedTitle = false;
    int attemptcounter = 1;
    while (!acceptedTitle) {
      bool titleUsed = false;
      for (int i = 0; i < _titles.length; i ++) {
        if (_titles[i] == newPageTitle) {
          titleUsed = true;
        }
      }
      if (titleUsed) {
        attemptcounter++;
        newPageTitle = initialNewPageTitle + "(" + attemptcounter.toString() + ")";
      } else {
        acceptedTitle = true;
      }
    }
    return newPageTitle;
  }

  void _createNewPage() async {
    String newPageTitle = _checkAvailability();
    _titles.add(newPageTitle);
    _pages.add("");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("titles", _titles);
    prefs.setStringList("pages", _pages);

    setState(() {
      _showPages();
    });

    _openPage(_titles.length - 1);
  }

  String _getDate() {
    String date = DateTime.now().toString();
    String formattedDate = "Dia ";
    formattedDate += date.substring(8, 10) + "/"; //Dia
    formattedDate += date.substring(5, 7) + "/";  //Mês
    formattedDate += date.substring(0, 4);        //Ano
    return formattedDate;
  }
  
  List<Widget> _showPages() {
    _loadPages();
    List<Widget> pages = <Widget>[];
    for (int i = _titles.length - 1; i >= 0; i--) {
      pages.add(
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          //ignore: deprecated_member_use
          child: RaisedButton(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(
              _titles[i],
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.left,
            ),
            onPressed: () {
              _openPage(i);
            }
          ),
        )
      );
    }
    return pages;
  }

  void _openPage(int pag) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DiaryPage(pageNumber: pag, titles: _titles, pages: _pages,)),
    );
  }

  void _goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Container(
                  width: 40,
                  height: 40,
                  child: FloatingActionButton(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    backgroundColor: Colors.black,
                    onPressed: _goBack,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5, left: 10),
                child: Text(
                  "My Daily Life",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     "My Daily Life",
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontWeight: FontWeight.bold,
      //       fontSize: 24,
      //     ),
      //   ),
      //   backgroundColor: Colors.black,
      // ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: _showPages(),
      ),
      bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //AddButton
            Padding(
              padding: EdgeInsets.only(right: 5, bottom: 5, left: 5),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 9,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100)
                  ),
                ),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 50,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          "Informe um titulo para a nova página:",
                          textAlign: TextAlign.center,
                        ),
                        content: TextField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 22),
                          decoration: InputDecoration(hintText: _getDate()),
                          maxLength: 20,
                          controller: _controllerNewPageTitle,
                        ),
                        actions: <Widget> [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                padding: EdgeInsets.only(top: 15, right: 70, bottom: 15, left: 70),
                                color: Colors.black,
                                child: Text(
                                  "Criar",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: _createNewPage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            //EditingButton
            Padding(
              padding: EdgeInsets.only(right: 5, bottom: 5, left: 5),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 9,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100)
                  ),
                ),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 50,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          "Ainda sem função",
                          textAlign: TextAlign.center,
                        ),
                        // content: ,
                        // actions: <Widget> [],
                      ),
                    );
                  },
                ),
              ),
            ),

            //DeleteButton
            Padding(
              padding: EdgeInsets.only(right: 5, bottom: 5, left: 5),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 9,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(100)
                  ),
                ),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.delete,
                    color: Colors.black,
                    size: 50,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          "Ainda sem função",
                          textAlign: TextAlign.center,
                        ),
                        // content: ,
                        // actions: <Widget> [],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
    );
  }
}