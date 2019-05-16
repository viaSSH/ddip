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
        backgroundColor: Color.fromARGB(255, 25, 14, 78),
        title: Text("abcdef"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share)
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 25, 14, 78),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            _ItemInformationSection(),
//          _ActionButtonSection(),
            _ReplyListSection(),
            _RelatedItemSection(),
          ],
        ),
      ),
    );
  }
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _ItemInformationSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ItemInformationSectionState();
}

class _ItemInformationSectionState extends State<_ItemInformationSection> {

  List<NewItem> itemMoreDetail = <NewItem>[
    NewItem(
        false,
        '더보기',
        Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey
              ),
              child: Column(
                  children: <Widget>[
                    Text("children", style: TextStyle(color: Colors.red),),
                  ]),
            )
        ),
    Icon(Icons.info_outline)
    ),

  ];

  Widget build(BuildContext context) {
    return Column(
//      mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(180.0),
//              child: Image.network(src),
              child: Container(
                height: 100,
                width: 100,
                color: Colors.white,
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0,8,8,8),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text("물건이름"),
                    Text("가격"),
                    Text("장소")
                  ],
                ),
              ),
            ),

          ],
        ),
        _ActionButtonSection(),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0,8,8,8),
          child: Text("Few days ago I came here to find a way to dynamically change height when images are loaded from internet and using childAspectRatio cannot do that because its apply to all widget in GridView(same height for each)."
"This answer may help someone who want different height according to each and every widget content:"

 "   I found a package called Flutter Staggered GridView by Romain Rastel. Using this package we can do so many things check examples here."

  "  To get what we want we can use StaggeredGridView.count() and its property staggeredTiles: and for its value you can map all widget and apply StaggeredTile.fit(2)."

   " Example code:"),
        ),
        RaisedButton(
          child: Text("더보기 아직안함"),
          onPressed: (){},
        ),

// expasion패널에서 바탕 색상이 잘 안바뀜 코드 수정 필요 TODO

//        Container(
////          color: Colors.red,
//          decoration: BoxDecoration(color: Colors.red),
//          child: ExpansionPanelList(
//            expansionCallback: (int index, bool isExpanded) {
//              setState(() {
//                itemMoreDetail[index].isExpanded = !itemMoreDetail[index].isExpanded;
//              });
//            },
//            children: itemMoreDetail.map((NewItem item) {
//              return ExpansionPanel(
//                headerBuilder: (BuildContext context, bool isExpanded) {
//                  return ListTile(
////                    leading: item.iconpic,
//                      title: Text(
//                        item.header,
//                        textAlign: TextAlign.center,
//                        style: TextStyle(
//                          fontSize: 20.0,
//                          fontWeight: FontWeight.w400,
//                        ),
//
//                      ),
//
//                  );
//                },
//
//                canTapOnHeader: true,
//                isExpanded: item.isExpanded,
//                body: item.body,
//
//              );
//            }).toList(),
//          ),
//        ),


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
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0,30,10.0,20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          MaterialButton(
            color: Colors.orangeAccent,
            minWidth: 250,
            height: 40,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text("대여요청",style: TextStyle(color: Colors.white,fontSize: 15)),
            onPressed: (){
              Navigator.pushNamed(context, '/check',
              arguments: 'item');
            }
            ,
          ),
          SizedBox(width:10),
          MaterialButton(
            color: Colors.orange[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text("대화하기",style: TextStyle(color: Colors.white, fontSize: 15)),
            minWidth: 100,
            height: 40,
            onPressed: (){},
          )
        ],
      ),
    );
  }
}

//Future<Null> _selectDate2(BuildContext context) async {
//  final DateTime picked = await showDatePicker(
//      context: context,
//      initialDate: _date2,
//      firstDate: new DateTime(2016),
//      lastDate: new DateTime(2020)
//  );
//
//  if(picked != null && picked != _date2){
//    print("Date selected: ${_date2.toString()}");
//    setState((){
//      _date2 = picked;
//    });
//  }
//}
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