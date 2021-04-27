import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeAgo extends StatefulWidget {
  TimeAgo({@required this.postTime});

  final String postTime;

  @override
  _TimeAgoState createState() => _TimeAgoState();
}

class _TimeAgoState extends State<TimeAgo> {
  showTimeAgo() {
    final nowTime = DateTime.now();
    print(nowTime.toString());
    print(widget.postTime);
    // final oldTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.postTime);
    final oldTime = DateTime.parse(widget.postTime);

    print('hi');
    final difference = nowTime.difference(oldTime);
    print(difference.toString());
    if (difference.inDays >= 1) {
      return 'Posted ${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return 'Posted ${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return 'Posted ${difference.inMinutes} minutes ago';
    } else if (difference.inSeconds >= 3) {
      return 'Posted ${difference.inSeconds} seconds ago';
    }
    return 'Posted Just Now!';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      showTimeAgo(),
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.black54,
      ),
    );
  }
}
