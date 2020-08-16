import 'package:auto_size_text/auto_size_text.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'OpenOrder/OpenOrder.dart';
import 'homepage.dart';
import 'package:flutter/services.dart';
import 'homescreen.dart';

double animheighttip;
Map<int, bool> checkcolor = {};

Color cardcolor(int index) {
  if (checkcolor[index] == null) {
    return Color.fromRGBO(198, 240, 231, 1);
  }
  return Color.fromRGBO(198, 240, 231, 0.3);
}

class TipsScreen extends StatefulWidget {
  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  Future<List<TipsItem>> tipsitemall;

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 1), () {
      setState(() {
        animheighttip = 0.0;
      });
    });
    tipsitemall = TipsData.GetTips();
    try{
      DartNotificationCenter.subscribe(
          channel: chanalnameNofication3,
          observer: 0,
          onNotification: (result) {
            openOrder(result);
          });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  openOrder(dataid) {
    ShLoader().showLoader(context);
    order.orderChatList(
      dataid['_id'],
    );
    order.orderChat.listen((data) {
      Navigator.pop(context);
      if (data != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OpenOrderScreenStl(data),
          ),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[

            new AppBar(
              elevation: 00,bottomOpacity:00,
              backgroundColor: Colors.white,
              leading: new IconButton(padding: EdgeInsets.only(bottom: 10,),
                icon: new SvgPicture.asset('assets/back.svg') ,
                onPressed: (){ if(subcatflag==true){Navigator.of(context).pop();}
                else{controller.animateTo(0);
                currentTabIndex = 0;}},
              ),

              centerTitle: true,
              title: Container(margin: EdgeInsets.only(top:00,bottom:10),
                  child: new Text("Tips",style: TextStyle(color: Color.fromRGBO(2, 44, 67, 100),fontFamily: 'PoppinsMedium',fontSize: 16.0,),)),
            ),

            Container(
              child: Column(
                children: <Widget>[
                  AnimatedContainer(
                    height: animheighttip,
                    curve: Curves.easeOut,
                    duration: Duration(milliseconds: 300),
                    color: Colors.transparent,
                  ),
                  Flexible(
                    child: AnimatedContainer(
                      curve: Curves.easeOut,
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*(45.0/768.0)),
                      decoration: BoxDecoration(
                          boxShadow: [
                            new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.16),
                              blurRadius: 30,
                              offset: Offset(
                                0, // horizontal, move right 10
                                0, // vertical, move down 10
                              ),
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Container(
                          //    margin: EdgeInsets.only(top: 20),
                            child: FutureBuilder<List<TipsItem>>(
                              future: tipsitemall,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {

                                        itemBuilder: (_, int index) => InkWell(
                                          child: Hero(
                                            child: Material(
                                                color: Colors.transparent,
                                                child: TipsCard(
                                                  data: snapshot.data[index],
                                                  index: index,
                                                )),
                                            tag: index.toString(),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                      TipsPostScreen(
                                                        data: snapshot
                                                            .data[index],
                                                        index:
                                                        index.toString(),
                                                      ),
                                                ));
                                          },
                                        ),
                                        itemCount: snapshot.data.length,
                                      ), behavior: MyBehavior(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return new InkWell(
                                        child: Center(
                                          child: Container(
                                            width: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.all(32.0),
                                              child: Text(
                                                  "ERROR OCCURRED, Tap to retry !"),
                                            ),
                                          ),
                                        ),
                                        onTap: () => setState(() {
                                          tipsitemall = TipsData.GetTips();
                                        }));
                                  }
                                }
                                return SpinKitWave(
                                  color: Color.fromRGBO(198, 240, 231, 1),
                                  size: 50,
                                );
                              },
                            )

//              Column(
//                children: <Widget>[
//                  Hero(child: Material(
//                    child: InkWell(child: TipsCard(),
//                    onTap: (){
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (BuildContext context) =>
//                              TipsPostScreen()));}
//                    ),
//                  ),
//                    tag: 'tipsitem',
//                  ),
//                ],
//              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TipsPostScreen extends StatefulWidget {
  TipsItem data;
  String index;

  TipsPostScreen({this.data, this.index});

  @override
  _TipsPostScreenState createState() => _TipsPostScreenState();
}

class _TipsPostScreenState extends State<TipsPostScreen> {
  double opacity = 1;
  double opacitynew = 1;
  PanelController _pc = new PanelController();

  @override
  void initState() {
    super.initState();
  }

  void openorclose() {
    _pc.isPanelOpen() ? _pc.close() : _pc.open();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        checkcolor[int.parse(widget.index)] = true;
        Navigator.of(context).pop();

      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SlidingUpPanel(
          onPanelSlide: (val) {
            setState(() {
              opacity = 1 - val;
            });
          },
          controller: _pc,
          minHeight: MediaQuery.of(context).size.height * 85 / 730,
          maxHeight: MediaQuery.of(context).size.height / 4.5,

          renderPanelSheet: false,
          panel: _floatingPanel(),
          //     collapsed: _floatingCollapsed(),

          body: TipsBodyWidget(),
        ),
      ),
    );
  }

  Widget TipsBodyWidget() {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          new AppBar(
            elevation: 00,
            bottomOpacity: 00,
            backgroundColor: Colors.white,
            leading: new IconButton(
              icon: new SvgPicture.asset('assets/back.svg'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Padding(padding: EdgeInsets.only(right: 10),),
                Text("Tips",style: TextStyle(color: Color.fromRGBO(2, 44, 67, 100),fontFamily: 'PoppinsMedium',fontSize: 16.0,),),
                Padding(padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/8),),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 12, bottom: 30),

            height: MediaQuery.of(context).size.height * 0.85, //added

            decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    blurRadius: 30.0,
                    offset: Offset(
                      0, // horizontal, move right 10
                      0, // vertical, move down 10
                    ),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),

            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0, left: 0, right: 20),
                child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Hero(
                      child: Material(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TipsCard(
                                data: widget.data,
                                index: int.parse(widget.index),
                              ),
                            ],
                          )),
                      tag: widget.index,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: textBuilder(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textBuilder(){
    var datalist = widget.data.descr;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for(int i =0;i< datalist.length;i++)
          if(i%2==widget.data.firstPlus)Padding(padding: EdgeInsets.only(left: 20),child: Text(datalist[i]))
          else superTip(datalist[i]),
      ],
    );
  }

  Widget superTip(String text){
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(width: 10,color: Color.fromRGBO(250, 70, 89, 1),height: 10,),
          Flexible(child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(text),
          )),
        ],
      ),
    );
  }

  Widget _floatingPanel() {
    return Container(
        width: double.infinity,
        color: Colors.transparent,
        //     margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(243, 253, 245, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20.0,
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                  ),
                ]),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      openorclose();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  0, 2 + 14 * opacitynew, 0, 8 * opacitynew),
                              child: Center(
                                child: SizedBox(
                                  width: 11,
                                  height: 2,
                                  child: Opacity(

                                  style: TextStyle(
                                      color: Color.fromRGBO(2, 44, 67, 1),
                                      fontSize: 14)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                new SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10),

                        ),
                        for (int i = 0; i < widget.data.related.length; i++)
                          InkWell(
                            //todo

                            child: TipsCard2(
                              data: TipsData
                                  .listoftips[widget.data.related[i] - 1],
                              index: widget.data.related[i] - 1,
                            ),

                            onTap: () {
                              // Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TipsPostScreen(
                                          data: TipsData.listoftips[
                                          widget.data.related[i] - 1],
                                          index: (widget.data.related[i] - 1)
                                              .toString(),
                                        ),
                                  ));
                            },
                          ),
//                    ListView.builder(
//                      // shrinkWrap: true,
//                      scrollDirection: Axis.horizontal,
//                      //padding: EdgeInsets.only(left:0,top: 10,),
//                      itemBuilder: (_,index)=> InkWell(
//
//                        child: TipsCard(data: TipsData.listoftips[widget.data.related[index]],index:widget.data.related[index],),
//
//                        onTap: (){
//                          Navigator.push(context,
//                              MaterialPageRoute(builder: (BuildContext context) =>
//                                  TipsPostScreen(data: TipsData.listoftips[widget.data.related[index]],index: widget.data.related[index].toString(),),));
//                        },
//                      ),
//                      itemCount: widget.data.related.length,
//
//                    ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class TipsCard extends StatefulWidget {
  TipsItem data;
  int index;

  TipsCard({this.data, this.index});

  @override
  _TipsCardState createState() => _TipsCardState();
}

class _TipsCardState extends State<TipsCard> {
  Color colorofcard;

  @override
  void initState() {
    colorofcard = Colors.deepPurple.withOpacity(0.8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width - 42,
            //total - padding

            alignment: Alignment.centerLeft,
            //  margin: const EdgeInsets.fromLTRB(20,10, 20, 10),
            decoration: BoxDecoration(
                color: colorofcard,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    topLeft: Radi
              '${widget.data.title}',
              maxLines: 2,
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
        ],
      ),
    );
  }
}

class TipsCard2 extends StatefulWidget {
  final TipsItem data;
  final int index;

  TipsCard2({this.data, this.index});

  @override
  _TipsCard2State createState() => _TipsCard2State();
}

class _TipsCard2State extends State<TipsCard2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: new Container(
        // height: MediaQuery.of(context).size.height*55/800,
        width: MediaQuery.of(context).size.width / 2.5,
        //total - padding

        alignment: Alignment.centerLeft,
        //  margin: const EdgeInsets.fromLTRB(20,10, 20, 10),
        decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.8),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30))),
        child: Text(
          '${widget.da
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
    );
  }
}
