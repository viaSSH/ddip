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
        title: Text("main page"),
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
      'https://firebasestorage.googleapis.com/v0/b/ddip-d0dc1.appspot.com/o/ddip_logo.PNG?alt=media&token=5fc6b17a-9cf5-4b3f-957f-b59d19b81a8b'
    );
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
