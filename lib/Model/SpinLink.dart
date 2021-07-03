// To parse this JSON data, do
//
//     final spinLink = spinLinkFromJson(jsonString);

import 'dart:convert';

List<SpinLink> spinLinkFromJson(String str) =>
    List<SpinLink>.from(json.decode(str).map((x) => SpinLink.fromJson(x)));

String spinLinkToJson(List<SpinLink> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpinLink {
  SpinLink({
    this.id,
    this.key,
    this.spins,
  });

  int id;
  String key;
  List<Spin> spins;

  factory SpinLink.fromJson(Map<String, dynamic> json) => SpinLink(
        id: json["id"],
        key: json["key"],
        spins: List<Spin>.from(json["data"].map((x) => Spin.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "data": List<dynamic>.from(spins.map((x) => x.toJson())),
      };
}

class Spin {
  Spin({
    this.id,
    this.key,
    this.time,
    this.link,
  });

  int id;
  String key;
  String time;
  String link;

  factory Spin.fromJson(Map<String, dynamic> json) => Spin(
        id: json["id"],
        key: json["key"],
        time: json["time"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "time": time,
        "link": link,
      };
}
