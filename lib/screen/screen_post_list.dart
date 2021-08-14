import 'dart:convert';

import 'package:board_app/model/api_adapter.dart';
import 'package:board_app/model/model_board.dart';
import 'package:board_app/screen/screen_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:http/http.dart' as http;

class ListScreen extends StatefulWidget{
  List<PostList> posts;

  ListScreen({this.posts});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen>{
  int _currentIndex = 0;
  bool isLoading = false;
  List<Comment> comments = [];

  _fetchComments(int pk) async{
    setState((){
      isLoading = true;
    });
    print(pk.toString());
    final response = await http.get(Uri.parse('https://lsmin1021.pythonanywhere.com/api/post/'+pk.toString()));
    if(response.statusCode == 200) {
      setState(() {
        comments = parseComments(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    }
    else{
      throw Exception('falied!');
    }
  }

  SwiperController _controller = SwiperController();

  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.deepOrange,
          body : Center(
            child:Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border : Border.all(color:Colors.deepOrange)
              ),
              width: width*0.85,
              height: height*0.6,
              child:Swiper(
                controller: _controller,
                loop:true,
                itemCount:widget.posts.length,
                itemBuilder:(BuildContext context, int index){
                  return _buildListView(widget.posts[index],width,height);
                }
              )
            )
          )
        )
    );
  }
  Widget _buildListView(PostList post, double width, double height){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color:Colors.white),
          color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(0,width*0.24, 0, width*0.024),
              child: Text(
                  (_currentIndex + 1).toString() + '번째 게시글',
                  style:TextStyle(
                    fontSize:width*0.03,
                  )
              )
          ),
          Container(
            width : width*0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: Text(
              post.title,
              textAlign: TextAlign.center,
              maxLines:2,
              style: TextStyle(
                fontSize:width*0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width : width*0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: Text(
              '작성자:'+post.author,
              textAlign: TextAlign.center,
              maxLines:2,
              style: TextStyle(
                fontSize:width*0.040,
              ),
            ),
          ),

          Container(
            width : width*0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: Text(
              post.contents,
              textAlign: TextAlign.center,
              maxLines:2,
              style: TextStyle(
                fontSize:width*0.040,
              ),
            ),
          ),
          Expanded(child: Container()),
          Container(
            width : width*0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: Text(
              '좋아요:'+post.like.toString(),
              textAlign: TextAlign.center,
              maxLines:2,
              style: TextStyle(
                fontSize:width*0.035,
              ),
            ),
          ),
          Container(
            width : width*0.8,
            padding: EdgeInsets.all(width * 0.012),
            child: Center(
              child:ButtonTheme(
                minWidth:width*0.5,
                height:height*0.05,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child:ElevatedButton(
                  child:Text(
                  '자세히 보기',
                  style:TextStyle(color:Colors.white),
                  ),
                  style:ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                  ),
                  onPressed: () {
                    _fetchComments(post.id).whenComplete(() {
                      return Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          PostScreen(post: post,comments:comments)));
                    });
                  },
                ),

              ),

            ),
          ),
          Container(
            width : width*0.8,
            padding: EdgeInsets.all(width * 0.012),
            child: Center(
              child:ButtonTheme(
                minWidth:width*0.5,
                height:height*0.05,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child:ElevatedButton(
                  child:Text(
                    '다음 글!',
                    style:TextStyle(color:Colors.white),
                  ),
                  style:ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                  ),
                  onPressed: () {
                    if (_currentIndex == widget.posts.length -1){ _currentIndex = 0;_controller.next();}
                    else{
                      _currentIndex += 1;
                      _controller.next();
                    }
                  },
                ),

              ),

            ),
          ),
        ],
      ),
    );
  }
}

/*
class PostBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: posts.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) return HeaderTile();
        return PersonTile(people[index-1]);
      },
    );
  }
}*/