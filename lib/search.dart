import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchQuery = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        title: TextField(
          controller: _searchQuery,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white) //색이 왜 안바뀌냐 ㅡ.ㅡ 어케하는지 모르겟네

            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3.0),
            ),
            contentPadding: EdgeInsets.all(8.0),
//          fillColor: Colors.red, //색이 왜 안바뀌냐 ㅡ.ㅡ
            hintText: "검색하기"
          ),
          
          style: TextStyle(
            color: Colors.purple
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("대여날짜"),
              padding: EdgeInsets.all(4.0),
              onPressed: (){},
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orangeAccent,
      body: ListView(

        children: <Widget>[
          _QuickQuerySection(),
          _ItemSection()
        ],
      )
    );
  }
}

class _QuickQuerySection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuickQuerySectionState();
}

class _QuickQuerySectionState extends State<_QuickQuerySection> {

  Widget build(BuildContext context) {
    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("물건찾기"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text("공구"),
              onPressed: (){
              },
            ),
            RaisedButton(
              child: Text("공구"),
              onPressed: (){
              },
            ),
            RaisedButton(
              child: Text("공구"),
              onPressed: (){
              },
            ),


          ],
        ),

      ],
    );
  }
}

class _ItemSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<_ItemSection> {

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("공구"),
        GridView.count(
            crossAxisCount: 2,
          shrinkWrap: true,
          physics: ScrollPhysics(), // 스크롤 가능하게 해줌
          children: List.generate(5, (index) {
            return Card(
              child: Text("aa", style: TextStyle(color: Colors.red),),
//              child: ListTile(
//
//                title: Text("item $index"),
//              )
            );
          }),
        )
      ],
    );
  }
}