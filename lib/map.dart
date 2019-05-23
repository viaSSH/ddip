import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final itemCategoryController =  TextEditingController();
final itemNameController =  TextEditingController();
final itemPriceController =  TextEditingController();
final itemLocationController =  TextEditingController();
final itemDateController =  TextEditingController();
final itemContentController =  TextEditingController();
List<dynamic> stime = [];
List<dynamic> etime = [];
class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();

}

class _MapPageState extends State<MapPage> {



  Completer<GoogleMapController> _controller = Completer();
  LatLng _center = const LatLng(36.103079, 129.3880255);
//  LatLng _lastMapPosition = _center;
  LatLng _lastMapPosition = const LatLng(36.103079, 129.3880255);

  final Set<Marker> _markers = {};

  bool onlyView = false;

  void getLocation() {
    final LatLng myLL = ModalRoute.of(context).settings.arguments;

    if(myLL != null) {
      setState(() {
        _center = myLL;
        onlyView = true;
      });

    }

    print(myLL);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: '거래장소',
//          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    print(_markers.first.position);
    Navigator.pop(context, _markers.first.position);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    getLocation();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
//        title: Text("asd"),
        backgroundColor: Color.fromARGB(255, 25, 14, 78),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
                target: _center,
//                zoom: 11.0
                zoom: onlyView ? 16.0 : 11.0
            ),
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          onlyView ? Text("") :
          Padding(
            padding: EdgeInsets.all(0.0),
            child: Align(
//            alignment: Alignment.topRight,
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.black87,
                height: 80,
                width: 350,
                child: Column(

                  children: <Widget>[
                    SizedBox(width: 20, height: 12,),
                    Text("지도를 움직여 거래장소에 마커를 올려놓으세요"),
                    RaisedButton(
                      child: Text("계속"),
                      onPressed: () {
                        _onAddMarkerButtonPressed();
                      },
                    )
                  ],
                ),
              ),

            ),
          ),
          Container(
            child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 80,
                  width: 2.0,
                  color: Colors.black54,
                )
            ),
          ),
          Container(
            child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 2,
                  width: 80,
                  color: Colors.black54,
                )
            ),
          ),

        ],
      ),
      backgroundColor: Color.fromARGB(255, 25, 14, 78),
    );
  }
}

