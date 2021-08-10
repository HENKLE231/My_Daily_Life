import 'package:flutter/material.dart';
import 'package:my_daily_life/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryPage extends StatefulWidget {
  int pageNumber;
  List<String> titles = [];
  List<String> pages = [];
  DiaryPage({required this.pageNumber, required this.titles, required this.pages});

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  TextEditingController _controllerPageContent = TextEditingController();

  void initState() {
    _loadPages();
    _controllerPageContent = TextEditingController(text: widget.pages[widget.pageNumber]);
  }
  
  void _loadPages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.titles = prefs.getStringList("titles") ?? [];
    widget.pages = prefs.getStringList("pages") ?? [];
  }

  void _save() async {
    String pageContent = _controllerPageContent.text;

    List<String> sortedTitles = [];
    List<String> sortedPages = [];

    for (int i = 0; i < widget.titles.length; i++) {
      if (i != widget.pageNumber) {
        sortedTitles.add(widget.titles[i]);
        sortedPages.add(widget.pages[i]);
      }
    }
    sortedTitles.add(widget.titles[widget.pageNumber]);
    sortedPages.add(pageContent);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("titles", sortedTitles);
    prefs.setStringList("pages", sortedPages);
  }

  void _goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
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
                        Icons.arrow_back_ios,
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
                  widget.titles[widget.pageNumber],
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
        children: <Widget> [
          TextFormField(
            minLines: 21,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: _controllerPageContent,
          ),
        ],
      ),
      bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SaveButton
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
                    Icons.save,
                    color: Colors.black,
                    size: 50,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: _save,
                ),
              ),
            ),
          ],
        ),
    );
  }
}