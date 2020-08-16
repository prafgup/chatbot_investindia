import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


class TipsData{
  static final TipsData _TipsData = new TipsData._internal();
  factory TipsData() {
    return _TipsData;
  }
  TipsData._internal();

  static  Future<String> getUserId()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString('userid') ?? "5f1d927c2a21cb581e69ed69";
  }

  static List<TipsItem> listoftips = [];
  static Future<String> urluser() async {
    return Constants.tipsApiUrl ;//+"?USERID=" +   await getUserId();
  }
  static Future<List<TipsItem>> GetTips() async {
    if(listoftips.length==0) {
      String url = await urluser();
      final response = await http.get(url,
      );
      print(json.decode(response.body).toString());
      if(response.statusCode==200){
        var jsonData = json.decode(response.body);
        print(jsonData['data']['TipsData']);
        for(var p in jsonData['data']['TipsData']){
          TipsItem cd=TipsItem.fromJson(p);
          listoftips.add(cd);
        }
        listoftips.sort((a,b)=>a.Priority.compareTo(b.Priority));
        print(listoftips.length);
        return listoftips;
      }
      else{
        throw Error();
      }

    }
    return listoftips;
  }




}

class TipsItem {
  String id;
  String title;
  List<String> descr;
  int Priority=1;
  bool IsActive=true;
  List<int> related = [1,2,3];
  int firstPlus=0;

  void descrParser(Map json){
    descr = json['Description'].toString().split("++++");
    if("+" == json['Description'][3]){
      firstPlus =1;
    }
  }

  //TipsData(this.id,this.TipsID,this.TipsName,this.IconURL,this.Priority);
  TipsItem(this.id,this.title,this.descr,this.Priority , this.IsActive);
  TipsItem.fromJson(Map json){
    id=json['_id'];
    title=json['Title'];
    descrParser(json);
    IsActive=json['IsActive'];
    Priority=json['Priority'];

  }

}