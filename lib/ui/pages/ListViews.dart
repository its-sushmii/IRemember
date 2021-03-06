import 'package:flutter/material.dart';
import 'dart:io';
import 'DetailView.dart';
import 'AddItems.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ListViews extends StatefulWidget {
  @override
  _ListViewsState createState() => _ListViewsState();
}

class _ListViewsState extends State<ListViews> {
  List item1 = [];
  void initState() {
    super.initState();
    getItem1();
  }

  getItem1() async {
    final sp = await SharedPreferences.getInstance();
    var itemString = sp.getString('item1');
    if (itemString == null) {
      print("items do not exist");
      setState(() {
        item1 = [];
      });
      await saveItem1(item1);
    } else {
      setState(() {
        item1 = json.decode(itemString);
      });
    }
    print(item1);
  }

  saveItem1(item1) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('item1', json.encode(item1));
    print(item1);
  }

  addItem(String title, String description, File image) {
    setState(() {
      item1.add({
        "title": title,
        "description": description,
        "img": image.path,
      });
      saveItem1(item1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: item1.length,
        itemBuilder: (BuildContext context, int index) {
          var item = item1[index];
          return ListTile(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => ItemDetails(item: item))),
            trailing: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () => delete(item),
            ),
            isThreeLine: true,
            title: Text(item["title"]),
            leading: CircleAvatar(
              backgroundImage: FileImage(
                File(item["img"]),
              ),
              radius: 30,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item["description"]),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddItem(addItem))),
        tooltip: "Add Items",
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  void delete(Map item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Delete item"),
              content: Text("Are you sure you want to delete item?"),
              actions: <Widget>[
                FlatButton(
                    child: Text("yes"),
                    onPressed: () {
                      removeItem(item);
                      Navigator.pop(context);
                    }),
                    FlatButton(
                    child: Text("no"),
                    onPressed: () {
                      
                      Navigator.pop(context);
                    })
              ]);
        });
  }

  void removeItem(Map item) {
    setState(() {
      item1.remove(item);
    });
    saveItem1(item1);
  }
}
