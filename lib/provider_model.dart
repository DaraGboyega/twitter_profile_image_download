import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image/network.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:flutter/foundation.dart';
import 'model.dart';
import 'package:provider/provider.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'api_key.dart';

class controllerModel with ChangeNotifier {
  final screenNameController = TextEditingController();
  @override
  notifyListeners();
}

class apiCall extends controllerModel {

  String value = "";

  void makeCall() async{
    final authorizationEndpoint =
    Uri.parse("https://api.twitter.com/oauth2/token");
    final identifier = "${ApiKey().identifier}";
    final secret = "${ApiKey().secret}";
    var client = await oauth2.clientCredentialsGrant(
        authorizationEndpoint, identifier, secret
    );
    var Tresponse = client.read("https://api.twitter.com/1.1/users/show.json?screen_name=${screenNameController.text}");
    var response = await Tresponse;
    debugPrint(response);
    final dResponse = await userFromJson(response);
    value = dResponse.profileImageUrlHttps.toString().replaceAll("_normal","");
    debugPrint(value);
    notifyListeners();
  }

  void download() async{

    Directory dir = await getTemporaryDirectory();
    String patthh = dir.path;
    final taskId = await FlutterDownloader.enqueue(
      url: '$value',
      savedDir: '$patthh',
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    print(taskId);
  }
}

