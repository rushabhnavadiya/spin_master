// To parse this JSON data, do
//
//     final linkModel = linkModelFromJson(jsonString);

import 'dart:convert';

LinkModel linkModelFromJson(String str) => LinkModel.fromJson(json.decode(str));

String linkModelToJson(LinkModel data) => json.encode(data.toJson());

class LinkModel {
  LinkModel({
    this.date,
    this.linkList,
  });

  String date;
  List<Link1> linkList;

  factory LinkModel.fromJson(Map<String, dynamic> json) => LinkModel(
    date: json["date"],
    linkList: List<Link1>.from(json["link"].map((x) => Link1.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "link": List<dynamic>.from(linkList.map((x) => x.toJson())),
  };


  factory LinkModel.fromJson1(Map<String, dynamic> json) => LinkModel(
    date: json["date"],
    linkList: (List<Link1>.from(jsonDecode(json["link"]).map((x) => Link1.fromJson(x)))),
  );
  Map<String, dynamic> toJson1() => {
    "date": date,
    "link": jsonEncode(List<dynamic>.from(linkList.map((x) => x.toJson()))),
  };
}

class Link1 {
  Link1({
    this.link,
    this.coin,
  });

  String link;
  String coin;

  factory Link1.fromJson(Map<String, dynamic> json) => Link1(
    link: json["l"]??json["i"],
    coin: json["k"],
  );

  Map<String, dynamic> toJson() => {
    "l": link,
    "k": coin,
  };
}