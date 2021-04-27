import 'package:final_project/authentication.dart';
import 'package:final_project/categoary/Item.dart';
import 'package:final_project/components/time_ago.dart';
import 'package:final_project/view/home_page.dart';
import 'package:final_project/view/image_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';

class PostDetail extends StatefulWidget {
  static const String id = 'post_detail';

  Item item;
  String userId;
  String postTime;
  BaseAuth auth;
  List<String> imageHolder = [];

  PostDetail(@required this.item, this.userId, this.auth);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  void initState() {
    super.initState();
    print(widget.item.favorite);
    addImage();
  }

  void addImage() {
    if (widget.item.imageOne != "") {
      widget.imageHolder.add(widget.item.imageOne);
    }
    if (widget.item.imageTwo != "") {
      widget.imageHolder.add(widget.item.imageTwo);
    }
    if (widget.item.imageThree != "") {
      widget.imageHolder.add(widget.item.imageThree);
    }
    if (widget.item.imageFour != "") {
      widget.imageHolder.add(widget.item.imageFour);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Column(
        children: [
          Container(
            height: 240,
            child: Swiper(
              itemCount: widget.imageHolder.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.imageHolder[index],
                  width: 600,
                  height: 240,
                );
              },
              viewportFraction: 1,
              scale: 1,
              pagination: SwiperPagination(),
              onTap: (index) {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ImageDetailPage(
                      index: index,
                      imageHolder: widget.imageHolder,
                    );
                  },
                ));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(32),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '\$ ${widget.item.money}',
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: 20.0,
                            ),
                          ),
                          TimeAgo(postTime: widget.item.date),
                        ],
                      ),
                      Divider(
                        height: 20.0,
                      ),
                      Text(
                        widget.item.item,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.pinkAccent,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                widget.item.location,
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black54),
                              ),
                            ],
                          ),
                          Text('${widget.item.condition}'),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        height: 200.0,
                        child: Text(
                          widget.item.description,
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Divider(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              print('Unavailable yet!');
                            },
                            child: Text('Message Me'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                widget.item.favorite = "true";
                              });
                            },
                            child: Text('Add To Cart'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
