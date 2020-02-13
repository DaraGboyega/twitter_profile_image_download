import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image/network.dart';
import 'provider_model.dart';
import 'package:provider/provider.dart';
import 'package:oauth2/oauth2.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  runApp(
      ChangeNotifierProvider(
        create: (context) => apiCall(),
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Consumer<apiCall>(
        builder: (context, model, child) {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text("Profile Image Downloader", style: TextStyle(
                  color: Colors.black45
                )),
                backgroundColor: Colors.greenAccent,
              ),
              body: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomPaint(
                    painter: ShapesPainter(),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                                color: Colors.blueGrey,
                                width: 3
                            )
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextField(
                                onEditingComplete: () => model.makeCall(),
                                decoration: InputDecoration(
                                  hintText: "Enter Twitter Username",
                                  hintStyle: TextStyle(color: Colors.blueGrey),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(color: Colors.blueGrey)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(color: Colors.blueGrey)
                                  )
                                ),
                                controller: model.screenNameController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 200,
                                    width: 270,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        color: Colors.blueGrey,
                                        width: 2
                                      )
                                    ),
                                    child: FadeInImage(
                                      image: NetworkImageWithRetry('${model.value}'),
                                      placeholder: NetworkImage('https://flutterappdev.com/wp-content/uploads/2019/01/Screen-Shot-2019-01-25-at-12.54.42-PM.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        )
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => model.download(),
                icon: Icon(Icons.save),
                label: Text('Download'),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          );
        }
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.white;

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(rect, paint);

    paint.color = Colors.greenAccent;

    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);

    path.close();

    canvas.drawPath(path, paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  // paint.color = Colors.blue;
//
//    var center = Offset(size.width / 2, size.height / 2);
//
//    canvas.drawCircle(center, 75.0, paint);
}
