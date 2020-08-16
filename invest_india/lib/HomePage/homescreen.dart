import 'dart:convert';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:states_rebuilder/states_rebuilder.dart';


bool ischatScreen = false;

String categoryname;
String userid;
String catID;
BuildContext globalContex;

class HomeScreen extends StatefulWidget {
  HomeScreen();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future<List<CategoryData>> homepageitemfuture;
  Future<List<BannerData>> homepagebannerfuture;
  @override
  void initState() {
    print("homescreen initstate called");
    username = Injector.get<UserDetails>().displayname.split(' ')[0];
    final FirebaseUser user=Injector.get<UserDetails>().user;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    homepageitemfuture = HomepageItem.GetItems();
    homepagebannerfuture = HomepageItem.GetBanners();
    super.initState();

  @override
  Widget build(BuildContext context) {
    final getKeys = KeysToBeInherited.of(context);
    return Center(
      child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
      Positioned(
      top: MediaQuery.of(context).size.height * (35.0 / 812),

      //margin: EdgeInsets.only(top: 5),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30)),
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                blurRadius: 30.0,
                spreadRadius: 1.0,
              )
            ],
          ),
          //margin: EdgeInsets.only(top: 5),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * (170.0 / 812),
          child: FutureBuilder<List<BannerData>>(
              future: homepagebannerfuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            snapshot.data[0].BannerUrl,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width *
                                      (132 / 375.0),
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context)
                                          .size
                                          .width *
                                          (29.43 / 375.0),
                                      top: MediaQuery.of(context)
                                          .size
                                          .height *
                                          (29.43 / 812.0)),
                                  padding: EdgeInsets.only(
                                      left:
                                      MediaQuery.of(context).size.width *
                                          (12.43 / 375.0)),
                                  foregroundDecoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: Colors.green,
                                              width: 5.0))),
                                  child: new AutoSizeText(
                                    snapshot.data[0].BannerTitle.substring(
                                        0,
                                        snapshot.data[0].BannerTitle
                                            .length <=
                                            20
                                            ? snapshot
                                            .data[0].BannerTitle.length
                                            : 20),
                                    maxLines: 2,
                                    style: TextStyle(
                                        color:
                                        Color.fromRGBO(53, 99, 150, 1),
                                        fontSize: 27,
                                        height: 0.8),
                                  )),
                              Container(
                                margin: EdgeInsets.only(
                                    left:
                                    MediaQuery.of(context).size.width *
                                        (29.43 / 375.0)),
                                child: new FlatButton(
                                    onPressed: //to be commented aftert test anf add null again//
                                        () async {
                                      //FlutterTwilioVoice.phoneCallEventSubscription.listen(_onEvent, onError: _onError);
                                      //FlutterTwilioVoice.receiveCalls("alice");
                                      print("making call)");
                                      //FlutterTwilioVoice.makeCall(to: "917000588523", accessTokenUrl: "https://twilio.com/340e4ee62a0aaca3d9c0a95fc3138934", toDisplayName: "James Bond" );
                                    } ,
                                    padding: EdgeInsets.all(0),
                                    clipBehavior:
                                    Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            (104 / 375),
                                        height: MediaQuery.of(context)
                                            .size
                                            .height *
                                            (24 / 812),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                250, 70, 89, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40))),
                                        child: Text(
                                          snapshot.data[0].BannerCTA,
                                          style: TextStyle(
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return new InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text("ERROR OCCURRED, Tap to retry !"),
                        ),
                        onTap: () => setState(() {
                          homepagebannerfuture =
                              HomepageItem.GetBanners();
                        }));
                  }
                }
                return SpinKitWave(
                  color: Color.fromRGBO(198, 240, 231, 1),
                  size: 50,
                );
              })),
    ),
    Positioned(
    top: MediaQuery.of(context).size.height * (185.0 / 812),
    child: Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.only(
    top: MediaQuery.of(context).size.height * (26.0 / 812),
    left: MediaQuery.of(context).size.width * (18 / 375)),
    height: MediaQuery.of(context).size.height * (494.0 / 812),
    decoration: BoxDecoration(
    color: Color.fromRGBO(198, 240, 231, 1),
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(30), topLeft: Radius.circular(30)),
    boxShadow: [
    new BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.16),
    blurRadius: 30.0,
    spreadRadius: 1.0,
    )
    ],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    new Text(
    username == 'Explorer'
    ? "How can I help you today?"
        : "How can I help you, $username?",
    style: TextStyle(
    fontSize: 16,
    color: Color.fromRGBO(2, 44, 67, 1),
    fontFamily: 'PoppinsRegular'),
    ),

    FlatButton(
    onPressed: () => {
    setState(() {
    animheight = 100.0;
    animheighttip = 100.0;
    currentTabIndex = 2;

    }),
    controller.animateTo(2),

    },
    padding: EdgeInsets.all(00),
    color: Color.fromRGBO(
    198,
    240,
    231,
    1,
    ),
    child: Container(
    width: MediaQuery.of(context).size.width - 40,
    child: Text(
    "Type your query here...",
    style: TextStyle(
    color: Color.fromRGBO(2, 44, 67, 0.5), fontSize: 13),
    ),
    ),
    )
    ],
    ),
    ),
    ),
    Positioned(
    top: MediaQuery.of(context).size.height * (300.0 / 812),
    child: Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(30), topLeft: Radius.circular(30)),
    boxShadow: [
    new BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.16),
    blurRadius: 2 * 15.0,
    spreadRadius: 0.5 * 2.0,
    offset: Offset(
    0, // horizontal, move right 10
    0, // vertical, move down 10
    ),
    )
    ],
    ),
    child: Card(
    elevation: 30,
    color: Color.fromRGBO(243, 253, 245, 1),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(30),
    topLeft: Radius.circular(30))),
    child: Container(
    margin: EdgeInsets.only(
    left: 0,
    top: MediaQuery.of(context).size.height * (30.0 / 812)),
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * (494.0 / 812),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Container(padding: EdgeInsets.only(left:20),
    child: new Text(
    "Explore",//textAlign: TextAlign.right,
    style: TextStyle(
    fontSize: 16, fontFamily: 'PoppinsRegular'),
    ),
    ),
    SizedBox(
    height: 10,
    ),
    new Container(
    padding: EdgeInsets.only(bottom: 25.0),
    margin: EdgeInsets.only(left: 0, top: 00, bottom: 5),
    height:
    MediaQuery.of(context).size.height * (400.0 / 812),
    child: Showcase(

    key: getKeys.one,
    description: 'Click on any category to get started',
    disableAnimation: false,overlayOpacity: 0.6,

    descTextStyle:TextStyle(fontSize: 14, color: Color.fromRGBO(2, 44, 67, 1), fontFamily: 'PoppinsRegular'),
    child: FutureBuilder<List<CategoryData>>(
    future: homepageitemfuture,
    builder: (context, snapshot) {
    if (snapshot.connectionState ==
    ConnectionState.done) {
    if (snapshot.hasData) {
    print("hello");
    return ScrollConfiguration(
    child: ListView.builder(
    padding: EdgeInsets.only(
    left: 0, top: 0, bottom: 50),
    itemBuilder: (_, int index) =>
    HomeScreenOptions(
    data: snapshot.data[index],
    ),
    itemCount: snapshot.data.length,
    ),
    behavior: MyBehavior(),
    );
    } else if (snapshot.hasError) {
    return new InkWell(
    child: Padding(
    padding: const EdgeInsets.all(32.0),
    child: Text(
    "ERROR OCCURRED, Tap to retry !"),
    ),
    onTap: () => setState(() {
    homepageitemfuture =
    HomepageItem.GetItems();
    }));
    }
    }

    return SpinKitWave(
    color: Color.fromRGBO(198, 240, 231, 1),
    size: 50,
    );
    },
    ],
    )),
    ),
    ),
    ),
    ],
    ));
  }
}

class HomeScreenOptions extends StatefulWidget {
  final CategoryData data;
  HomeScreenOptions({this.data});
  @override
  _HomeScreenOptionsState createState() => _HomeScreenOptionsState();
}

class _HomeScreenOptionsState extends State<HomeScreenOptions> {
  @override
  Widget build(BuildContext context) {
    globalContex = context;
    return GestureDetector(
      onTap: () => {
        setState(() {
          categoryname = widget.data.CategoryName;
          subcatflag = true;
          catID = widget.data.id;
          subcatapi = widget.data.subcat;
          //print("subat sent data\\\ ");print(widget.data.subcat[0].name);
        }),
        print("a test for subcat  " + subcatapi[0].name),
        Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) =>  ChatStl() )),

      },
      child: Container(
        color: Color.fromRGBO(243, 253, 245, 1),
        margin: EdgeInsets.only(top: 10, left: 00),
        height: MediaQuery.of(context).size.height * (37.0 / 812),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
        Stack(
        children: <Widget>[
        new Container(
        margin: EdgeInsets.only(left: 00),
        height: MediaQuery.of(context).size.height * (37.0 / 768),
        width: MediaQuery.of(context).size.width * (57.0 / 375),
        decoration: BoxDecoration(
            color: Color.fromRGBO(198, 240, 231, 1),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0))),
        Container(
          width: MediaQuery.of(context).size.width * (57.0 / 375),
          alignment: Alignment(-0.2, 0),
          child: SvgPicture.network(
            widget.data.IconURL,
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height * (26.0 / 768),
          ),
        )
        ],
      ),
      SizedBox(
        width: 26.0,
        height: MediaQuery.of(context).size.height * (30.0 / 812),
      ),
      new Text(
        widget.data.CategoryName,
        style: TextStyle(fontFamily: 'PoppinsRegular', fontSize: 16),
      )
      ],
    ),
    ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
