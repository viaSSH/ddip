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
        backgroundColor:Color.fromARGB(255, 25, 14, 78),
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
//            fillColor: Colors.red, //색이 왜 안바뀌냐 ㅡ.ㅡ
            hintText: "검색하기"
          ),
          style: TextStyle(
            color: Colors.purple
          ),
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      semanticLabel: 'search',
                      color: Colors.white
                    )
                  ),
                  RaisedButton(
                  child: Text("대여날짜",style:TextStyle(color: Colors.white)),
                  padding: EdgeInsets.all(4.0),
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                onPressed: (){},
              ),
            ]
            ),
          ),
        ],

      ),
      backgroundColor: Color.fromARGB(255, 25, 14, 78),
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
//      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("물건찾기"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text("공구",style:TextStyle(color: Colors.white)),
                color: Color.fromARGB(255, 25, 14, 78),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                    side: BorderSide(color: Colors.white, width: 1.0),
                ),
                onPressed: (){
                },
              ),
              RaisedButton(
                child: Text("공구",style:TextStyle(color: Colors.white)),
                color: Color.fromARGB(255, 25, 14, 78),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  side: BorderSide(color: Colors.white, width: 1.0),
                ),
                onPressed: (){
                },
              ),
              RaisedButton(
                child: Text("공구",style:TextStyle(color: Colors.white)),
                color: Color.fromARGB(255, 25, 14, 78),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  side: BorderSide(color: Colors.white, width: 1.0),
                ),
                onPressed: (){
                },
              ),


            ],
          ),

        ],
      ),
    );
  }
}

class _ItemSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemSectionState();
}

class _ItemSectionState extends State<_ItemSection> {

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Text("공구",style: TextStyle(fontSize: 20.0, color:Color.fromARGB(255,255,219,181))),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1.7/1,
            physics: ScrollPhysics(), // 스크롤 가능하게 해줌
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.pushNamed(context, '/detail',
                          arguments: index
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      width: 180,
                      height: 100,
                      child: Text("card"),
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}