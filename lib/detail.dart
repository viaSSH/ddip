import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  FirebaseUser user;
  DocumentSnapshot document;
  DetailPage ({Key key, @required this.document, @required this.user});
  @override
  _DetailPageState createState() => new _DetailPageState(document:document,user:user);
}

class _DetailPageState extends State<DetailPage> {
  DocumentSnapshot document;
  FirebaseUser user;
  _DetailPageState({Key key, @required this.document, @required this.user});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 25, 14, 78),
        title: Text("< "+document['category']+" > "+document['name']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share)
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 25, 14, 78),
      body:
      _buildBody(context),
//      Padding(
//        padding: const EdgeInsets.all(15.0),
//        child: ListView(
//          children: <Widget>[
//            _ActionButtonSection(),
//            _ReplyListSection(),
//            _RelatedItemSection(),
//          ],
//        ),
//      ),
    );
  }
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Items').where('name',isEqualTo: document['name']).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(180.0),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(document['imageUrl']),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0,5,5,10),
              child: Column(
                children: <Widget>[

                  Row(children: <Widget>[

                    Text("물건이름",style:TextStyle(color:Colors.grey)),
                    Container(
                        margin: EdgeInsets.all(8.0),
                        child: Text(document['name'])
                    ),
                  ]),
                  Row(children: <Widget>[
                    Text("가격",style:TextStyle(color:Colors.grey)),
                    Container(
                        margin: EdgeInsets.all(8.0),
                        child: Text(document['price'])
                    ),]),
                  Row(children: <Widget>[
                    Text("장소",style:TextStyle(color:Colors.grey)),
                    Container(
                        margin: EdgeInsets.all(8.0),
                        child: Text(document['location'])
                    ),]),
                ]
          ),
            ),

    ]
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20.0,8,20,8),
        child: Divider(height:30, color: Colors.grey),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10.0,10,10,10),
        child: Container(
            margin: EdgeInsets.all(8.0),
            child: Text(document['description'])
        ),
      ),
      RaisedButton(
        child: Text("더보기 아직안함"),
        onPressed: (){},
      ),
      _ActionButtonSection(),
      _ReplyListSection(),
      _RelatedItemSection(),
    ]
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

class _ActionButtonSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ActionButtonSectionState();
}

class _ActionButtonSectionState extends State<_ActionButtonSection> {

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
          onPressed: () async {
            final List<DateTime> picked = await DateRagePicker.showDatePicker(
                context: context,
                initialFirstDate: new DateTime.now(),
                initialLastDate: new DateTime.now(),
                firstDate: new DateTime(2015),
                lastDate: new DateTime(2020),
            );
            if (picked != null && picked.length == 2) {
              print(picked);
            }
          },
              child: Text("대여요청",style: TextStyle(color: Colors.white,fontSize: 15)),
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
