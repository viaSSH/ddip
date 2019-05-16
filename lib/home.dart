import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 14, 78),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(8.0),
            child: MaterialButton(
              padding: EdgeInsets.all(4.0),
              color: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)
              ),
              child: Text("물건올리기", style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.pushNamed(context, '/addItem');
              },
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _BannerSection(),
          _CategorySection(),
          _TopCategorySection(),
//          Text("first page"),
//          RaisedButton(
//            child: Text("move to main page"),
//            onPressed: () {
//
//            },
//          ),
        ],
      ),
      drawer: Drawer(

        child: Container(
          color: Colors.indigo,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text("aaa"),
                decoration: BoxDecoration(
                  color: Colors.blue
                ),
              ),
              ListTile(
                title: Text("마이페이지"),
                onTap: () {
                  Navigator.pushNamed(context, '/myPage');

                },
              ),
              ListTile(
                title: Text("로그아웃"),
                onTap: () {
                  Navigator.pushNamed(context, '/init');

                },
              )
            ],
          ),
        ),
      ),

      backgroundColor: Color.fromARGB(255, 25, 14, 78),
    );
  }
}

// 배너 부분 시작
class _BannerSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<_BannerSection> {

  Widget build(BuildContext context) {
    return Image.network(
        'https://firebasestorage.googleapis.com/v0/b/ddip-d0dc1.appspot.com/o/ddip_logo_navy.png?alt=media&token=418b7f31-8905-469b-9cbd-c520f86bd038',
        height: 150.0,width:150.0);
  }
}

// 배너부분 끝


// 카테고리 이동부분 시작
class _CategorySection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection> {

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          child: Text('물품'),
          onPressed: () {
            Navigator.pushNamed(context, '/search',
              arguments: 'item'
            );
          },
        ),
        RaisedButton(
          child: Text('사람'),
          onPressed: () {

          },
        ),
        RaisedButton(
          child: Text('공간'),
          onPressed: () {

          },
        ),
        RaisedButton(
          child: Text('노하우'),
          onPressed: () {

          },
        ),
      ],
    );
  }
}

// 카테고리 이동부분 끝

// 배너 부분 시작
class _TopCategorySection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopCategorySectionState();
}

class _TopCategorySectionState extends State<_TopCategorySection> {

  Widget build(BuildContext context) {
    final double cardWidth = 100.0;
    final double cardHeight = 100.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: <Widget>[
        Text("물건"),
        Container(
          height: cardHeight,
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            children: <Widget>[
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),

            ],
          ),
        ),
        
        Text("사람"),
        Container(
          height: cardHeight,
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            children: <Widget>[
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),

            ],
          ),
        ),
        
        Text("공간"),
        Container(
          height: cardHeight,
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            children: <Widget>[
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),
              Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                child: Text("item"),
              ),

            ],
          ),
        ),


      ],
    );

  }
}

// 배너부분 끝
