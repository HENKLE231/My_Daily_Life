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
  TextEditingController _controllerNewPageTitle = TextEditingController();
  TextEditingController _controllerNewTitle = TextEditingController();
  int _selectedPageAction = 0; // 0: Open, 1: Edit, 3: Delete
  List<String> _titles = [];
  List<String> _pages = [];
  String _appBarText = "My Daily Life";

  void initState() {
    _loadPages();
    Future.delayed(const Duration(milliseconds: 1), () {
      setState(() {
        _showPages();
      });
    });
    // _selectedPageAction = 0; //Verificar necessidade
  }

  void _loadPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _titles = prefs.getStringList("titles") ?? [];
    _pages = prefs.getStringList("pages") ?? [];
  }

  String _checkAvailability(String newPageTitle) {
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
    String newPageTitle = _controllerNewPageTitle.text.trim();
    _controllerNewPageTitle.text = "";
    if (newPageTitle.isEmpty) {
      newPageTitle = _getDate();
    }
    newPageTitle = _checkAvailability(newPageTitle);
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
              _selectPage(i);
            }
          ),
        )
      );
    }
    return pages;
  }

  void _openPage(int page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DiaryPage(pageNumber: page, titles: _titles, pages: _pages,)),
    );
  }

  void _goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _selectPage(int page) {
    if (_selectedPageAction == 0) {
      _openPage(page);
    } else if (_selectedPageAction == 1) {
      _askNewTitle(page);
    } else {
      _deletePage(page);
    }
  }

  void _changeSelectedPageAction(int action) {
    _selectedPageAction = action;
    if (_selectedPageAction == 0) {
      setState(() {
        _appBarText = "My Daily Life";
      });
    } else if (_selectedPageAction == 1) {
      setState(() {
        _appBarText = "Selecione para editar";
      });
    } else if (_selectedPageAction == 2) {
      setState(() {
        _appBarText = "Selecione para excluir";
      });
    }
  }

  void _askNewTitle(int page) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "Informe um novo título para a página:",
          textAlign: TextAlign.center,
        ),
        content: TextField(
          keyboardType: TextInputType.text,
          style: TextStyle(fontSize: 22),
          decoration: InputDecoration(hintText: _titles[page]),
          maxLength: 22,
          controller: _controllerNewTitle,
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
                  "Renomear",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _editTitle(page);
                  Navigator.pop(context);
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editTitle(int page) async {
    String newPageTitle = _controllerNewTitle.text.trim();
    _controllerNewTitle.text = "";
    if (newPageTitle.isEmpty) {
      newPageTitle = _titles[page];
    }
    newPageTitle = _checkAvailability(newPageTitle);
    _titles[page] = newPageTitle;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("titles", _titles);

    setState(() {
      _showPages();
    });
    _changeSelectedPageAction(0);
  }

  void _deletePage(int page) async {
    _titles.removeAt(page);
    _pages.removeAt(page);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("titles", _titles);
    prefs.setStringList("pages", _pages);

    _changeSelectedPageAction(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  _appBarText,
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
                    _changeSelectedPageAction(0);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                          "Informe um título para a nova página:",
                          textAlign: TextAlign.center,
                        ),
                        content: TextField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 22),
                          decoration: InputDecoration(hintText: _getDate()),
                          maxLength: 22,
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
                    _changeSelectedPageAction(1);
                  }
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
                    _changeSelectedPageAction(2);
                  }
                ),
              ),
            ),
          ],
        ),
    );
  }
}