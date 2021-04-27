import 'package:flutter/material.dart';

//TODO: view images with a 'close' icon
class ImageDetailPage extends StatefulWidget {
  ImageDetailPage({@required this.index, @required this.imageHolder});

  final int index;
  final List<String> imageHolder;
  @override
  _ImageDetailPageState createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Hero(
                tag: 'imageHero',
                child: Image.network(
                  widget.imageHolder[widget.index],
                ),
              ),
            ),
            Positioned(
              left: 10.0,
              top: 5.0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.pinkAccent,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: IconButton(
            //     icon: Icon(
            //       Icons.close,
            //       color: Colors.pinkAccent,
            //     ),
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
