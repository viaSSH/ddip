import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {

  @override
  _DetailPageState createState() => _DetailPageState();

}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        title: Text("abcdef"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share)
          )
        ],
      ),
      backgroundColor: Colors.orangeAccent,
      body: ListView(
        children: <Widget>[
          _ItemInformationSection(),
//          _ActionButtonSection(),
          _ReplyListSection(),
          _RelatedItemSection(),
        ],
      ),
    );
  }
}

class _ItemInformationSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemInformationSectionState();
}

class _ItemInformationSectionState extends State<_ItemInformationSection> {

  Widget build(BuildContext context) {
    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(28.0),
//              child: Image.network(src),
              child: Container(
                height: 100,
                width: 150,
                color: Colors.blue,
              )
            ),
            Column(
              children: <Widget>[
                Text("물건이름"),
                Text("가격"),
                Text("장소")
              ],
            ),

          ],
        ),
        _ActionButtonSection(),
        Text("Few days ago I came here to find a way to dynamically change height when images are loaded from internet and using childAspectRatio cannot do that because its apply to all widget in GridView(same height for each)."
"This answer may help someone who want different height according to each and every widget content:"

 "   I found a package called Flutter Staggered GridView by Romain Rastel. Using this package we can do so many things check examples here."

  "  To get what we want we can use StaggeredGridView.count() and its property staggeredTiles: and for its value you can map all widget and apply StaggeredTile.fit(2)."

   " Example code:"),
        RaisedButton(
          child: Text("더보기 아직안함"),
          onPressed: (){},
        )


      ],
    );
  }
}

class _ActionButtonSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ActionButtonSectionSatte();
}

class _ActionButtonSectionSatte extends State<_ActionButtonSection> {

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          child: Text("거래하기"),
          onPressed: (){},
        ),
        RaisedButton(
          child: Text("대화하기"),
          onPressed: (){},
        )
      ],
    );
  }
}

class _ReplyListSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReplyListSectionState();
}

class _ReplyListSectionState extends State<_ReplyListSection> {

  Widget build(BuildContext context) {
    return Text("댓글창 부분");
  }
}

class _RelatedItemSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RelatedItemSectionState();
}

class _RelatedItemSectionState extends State<_RelatedItemSection> {

  Widget build(BuildContext context) {
    return Text("연관 검색어 부분");
  }
}