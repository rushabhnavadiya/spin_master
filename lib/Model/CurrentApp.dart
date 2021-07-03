import 'dart:convert';

CurrentApp currentAppFromJson(String str) => CurrentApp.fromJson(json.decode(str));

String currentAppToJson(CurrentApp data) => json.encode(data.toJson());

class CurrentApp {
  CurrentApp({
    this.packageName,
    this.applicationUrl,
  });

  String packageName;
  String applicationUrl;

  factory CurrentApp.fromJson(Map<String, dynamic> json) => CurrentApp(
    packageName: json["package_name"],
    applicationUrl: json["application_url"],
  );

  Map<String, dynamic> toJson() => {
    "package_name": packageName,
    "application_url": applicationUrl,
  };
}
