import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:showcaseview/showcaseview.dart';
//import 'package:showcaseview/tooltip_widget.dart';
import 'orderspage.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:flutter_svg/svg.dart';
import 'homescreen.dart';
import 'tipspage.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'more.dart';

//GoogleSignIn _googleSignIn = GoogleSignIn(
//  scopes: <String>[
//    'email',
//  ],
//);
int currentTabIndex = 0;

class HomePageBuilder extends StatelessWidget {

  final FirebaseUser user;
  int sent_index;
  HomePageBuilder(this.user,this.sent_index);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));

    return Injector(
      inject: [Inject(() => UserDetails(user))],
      //models: [
      // () => UserDetails(user)],
      builder: (_)=> Home1(sent_index,user),
    );
  }
}
class Home1 extends StatelessWidget {
  //static final _myTabbedPageKey = new GlobalKey<_HomePageState>();
  final int sent_index;
  final FirebaseUser user;
  Home1(this.sent_index,this.user);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        builder: Builder(builder:(_)=> HomePage(sent_index: sent_index,user:user),),
      ),
    );
  }
}

TabController controller;
final List<Widget> tabs = [
  HomeScreen(),
  OrderScreenStl(),
  ChatStl(),
  TipsScreen(),
  MoreDetails(),
];


//for sending keys to screens

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey one;
  final GlobalKey two;
  final GlobalKey three;
  final GlobalKey four;
  final GlobalKey five;
  final GlobalKey six;
  final GlobalKey seven;
  final GlobalKey eight;
  final GlobalKey nine;
  final GlobalKey ten;

  KeysToBeInherited({
    this.one,
    this.two,
    this.three,
    this.four,
    this.five,
    this.six,
    this.seven,
    this.eight,
    this.nine,
    this.ten,
    Widget child,
  }) : super(child: child);

  static KeysToBeInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect: KeysToBeInherited);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

//






class HomePage extends StatefulWidget {
  final int sent_index;
  final FirebaseUser user;
  const HomePage({this.sent_index,this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

//for tut
  GlobalKey one = GlobalKey();
  GlobalKey two = GlobalKey();
  GlobalKey three = GlobalKey();
  GlobalKey four = GlobalKey();
  GlobalKey five = GlobalKey();
  GlobalKey six = GlobalKey();
  GlobalKey seven = GlobalKey();
  GlobalKey eight = GlobalKey();
  GlobalKey nine= GlobalKey();
  GlobalKey ten = GlobalKey();
//end tut



  int checkout = 0;
  int selectedInex =0;
  Future<bool> _onWillPop() async {

    //return selectedInex==0?
    selectedInex==0?  await showModalBottomSheet<bool>(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * (28.0 / 812),
                  left: MediaQuery.of(context).size.width * (32.0 / 375.0),
                  right: MediaQuery.of(context).size.width * (32.0 / 375.0)),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Row(children: <Widget>[
                    new Icon(Icons.exit_to_app),
                    Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width *
                                (8.1 / 375.0))),
                    new Text(
                      'Exit App',
                      style: TextStyle(
                          fontSize: 18, color: Color.fromRGBO(2, 44, 67, 1)),
                    )
                  ]),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height *
                              (18.0 / 812))),
                  new AutoSizeText(
                    'Are you sure you want to exit the app?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(2, 44, 67, 1),
                    ),
                    maxLines: 1,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height *
                              (17.0 / 812))),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromRGBO(250, 70, 89, 1),
                                width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(40.0))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        splashColor: Color.fromRGBO(250, 70, 89, 1),
                        color: Colors.white,
                        child: Text(
                          "No",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(250, 70, 89, 1)),
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromRGBO(250, 70, 89, 1),
                                width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(40.0))),
                        onPressed: ()
                        {
                          setState(() {
                            checkout = 1;
                          });
                          Navigator.pop(context);
                        },
                        color: Color.fromRGBO(250, 70, 89, 1),
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(15)),
                ],
              ),
            ),
          );
        }):{
      setState((){
        currentTabIndex=0;
        selectedInex=0;}),
      controller.animateTo(0),


    };
    if (checkout == 1) {
      return true;
    }
    return false;
  }

  String username;

  final usermodel = Injector.get<UserDetails>();

  List<Color> Customcolors = [
    Color.fromRGBO(243, 253, 245, 1),
    Color.fromRGBO(243, 253, 245, 1),
    Color.fromRGBO(198, 240, 231, 1),
    Colors.white,
    Colors.white
  ];
  List<CategoryData> listofcategory = [];

  onTapped(int index) {
    print("you tapped");
    selectedInex = index;
    if(this.mounted){setState(() {
      animheight = 100.0;
      animheighttip = 100.0;
      animheightmore = 100.0;
    });}

    setState(() {
      currentTabIndex = index;//not used, was used earlier
    });
  }



  int IndexAfterDL=0;

  @override
  Future<void> initDynamicLinks() async {

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          print("Deeplink" );print(deepLink.toString());
          if (deepLink != null) {
//            Navigator.pushNamed(context, deepLink.path);
            if(deepLink.path=="/home"){
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (context) => HomePageBuilder(widget.user, 0)));
              setState(() {
                currentTabIndex=0;
                selectedInex=0;
              });
            }
            else if(deepLink.path=="/tips") {
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (context) => HomePageBuilder(widget.user, 3)));
              setState(() {
                currentTabIndex=3;
                selectedInex=3;
              });
            }
            else if(deepLink.path=="/profile") {
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (context) => HomePageBuilder(widget.user, 4)));
              setState(() {
                currentTabIndex=4;
                selectedInex=4;
              });
            }
            else if(deepLink.path=="/chat") {
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (context) => HomePageBuilder(widget.user, 2)));
              setState(() {
                currentTabIndex=2;
                selectedInex=2;
              });
            }
            else if(deepLink.path=="/requests") {
              Navigator.of(context).pushReplacement(new MaterialPageRoute(
                  builder: (context) => HomePageBuilder(widget.user, 1)));
//              controller.animateTo(1);
              setState(() {
                currentTabIndex=1;
                selectedInex=1;
              });

            }
            else{
              var x= deepLink.path.split('/');
              print("Hiiiiiiiiiiololol");
              print(x);
              print(x[1]);
              if(x[1].trim()=="requests"){
                print("herehrehreh");
                OrdersDatum temporder=await OrderDetails().GetOrderbyIDDetails(x[2].trim());
                print("huhuhuh");
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => OpenOrderScreenStl(temporder)));
              }
              else if(x[1].trim()=="chat"){
                print("Got Here//////////");
                setState(() {
                  isdeeplinksubcat=true;
//                 subcatflag = false;
                  catID = x[2].trim();
                  subcatid=x[3].trim();
                });
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) =>  ChatStl() ));
//             SendDeepLinkSubCatMsg();
              }

            }
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }



  @override
  void initState() {
    super.initState();
    print("homapage  intistate was called");

    //initDynamicLinks();
    WidgetsBinding.instance.addObserver(this);
    getuserID();
    username = Injector.get<UserDetails>().displayname.split(' ')[0];
    controller =
        TabController(length: 5, initialIndex:IndexAfterDL!=0?IndexAfterDL: widget.sent_index, vsync: AnimatedListState());
    setState(() {
      IndexAfterDL=0;
    });
    selectedInex=widget.sent_index;
  }
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("cik");
    if (state == AppLifecycleState.resumed) {
      new Timer(const Duration(milliseconds: 1000), () {

        initDynamicLinks();
      });



    }
    // new Timer(new Duration(milliseconds: 1000), () {
    super.didChangeAppLifecycleState(state);
    print("bgst");
    //});
  }


  @override
  void dispose() {
    super.dispose();
  }

  dynamic getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userid = prefs.getString('userid') ?? null;

  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences_my;
    setState(() {
      selectedInex=currentTabIndex;
    });
    displayShowCase() async {
      preferences_my=await SharedPreferences.getInstance();
      bool showCaseVisibilityStatus= preferences_my.getBool("displayShowCase");
      if(showCaseVisibilityStatus == null){
        preferences_my.setBool("displayShowCase", false);
        return true;
      }
      return false;
    }
    displayShowCase().then((status) => { if(status){
      ShowCaseWidget.of(context).startShowCase([one, two, three, four, five,six,seven,eight,nine,ten] )
    }   });
    //WidgetsBinding.instance.addPostFrameCallback((_) {
    // } );

    return KeysToBeInherited(
      one: one,
      two: two,
      three: three,
      four: four,
      five: five,
      six: six,
      seven: seven,
      eight: eight,
      nine: nine,
      ten: ten,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: DefaultTabController(
          length: 5,
          child: new Scaffold(
            backgroundColor: Customcolors[currentTabIndex],
            bottomNavigationBar: SafeArea(
              bottom: false,
              child: Container(
                height: MediaQuery.of(context).size.height * (63.0 / 768),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  boxShadow: [
                    new BoxShadow(
                      color: Color.fromRGBO(2, 44, 67, 0.16),
                      blurRadius: 15.0,
                      spreadRadius: 2.0,
                    )
                  ],
                ),
                child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: SafeArea(
                      child: TabBar(
                        controller: controller,
                        onTap: onTapped,
                        labelPadding: EdgeInsets.all(0),
                        unselectedLabelColor: Color.fromRGBO(2, 44, 67, 0.59),
                        indicatorColor: Colors.white,
                        labelColor: Color.fromRGBO(255, 0, 0, 1),
                        labelStyle: TextStyle(
                            fontFamily: 'PoppinsRegular',
                            fontSize: 11,
                            color: Color.fromRGBO(2, 44, 67, 0.59)),
                        tabs: [
                          Tab(
                              text: 'Home',
                              icon: selectedInex == 0
                                  ? SvgPicture.asset("assets/home-active.svg")
                                  : SvgPicture.asset(
                                "assets/home-inactive.svg",
                              )),
                          Showcase(
                            key: three,
                            description: 'Click here to track your service requests',
                            disableAnimation: false,overlayOpacity: 0.6,



//                            height: 80,
//                            width: 140,
//                            container: Container(),

                            descTextStyle:TextStyle(fontSize: 14, color: Color.fromRGBO(2, 44, 67, 1), fontFamily: 'PoppinsRegular'),

                            child: Tab(//iconMargin: EdgeInsets.fromLTRB(1, 1, 1, 1),
                              text: 'Requests',
                              icon: selectedInex == 1
                                  ? SvgPicture.asset("assets/orders-active.svg")
                                  : SvgPicture.asset("assets/orders-inactive.svg"),
                            ),
                          ),
                          Showcase(
                            key:two,
                            description: 'Click here to  ask  your financial queries',
                            disableAnimation: false,overlayOpacity: 0.6,



                            descTextStyle:TextStyle(fontSize: 14, color: Color.fromRGBO(2, 44, 67, 1), fontFamily: 'PoppinsRegular'),

                            child: Tab(
                              text: '  Chat  ',
                              icon: selectedInex == 2
                                  ? SvgPicture.asset("assets/chat-active.svg")
                                  : SvgPicture.asset("assets/chat-inactive.svg"),
                            ),
                          ),
                          Showcase(
                            key: four,
                            description: 'Click here to get great tips from experts',
                            disableAnimation: false,overlayOpacity: 0.6,



                            descTextStyle:TextStyle(fontSize: 14, color: Color.fromRGBO(2, 44, 67, 1), fontFamily: 'PoppinsRegular'),
                            child: Tab(
                              text: '   Tips  ',
                              icon: selectedInex == 3
                                  ? SvgPicture.asset("assets/tip-active.svg")
                                  : SvgPicture.asset("assets/tip-inactive.svg"),
                            ),
                          ),
                          Tab(
                            text: username == 'Explorer' ? "Login" : "Profile",
                            icon: selectedInex == 4
                                ? SvgPicture.asset("assets/profile-active.svg")
                                : SvgPicture.asset("assets/profile-inactive.svg"),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            body: TabBarView(
                controller: controller,
                physics: NeverScrollableScrollPhysics(),
                children: tabs),

          ),
        ),
      ),
    );

  }
}

