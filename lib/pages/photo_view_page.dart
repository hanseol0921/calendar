import 'dart:io';
import 'package:flutter/material.dart';
import 'package:practice/pages/calendar_page.dart';

// =====================================================
// 📸 사진 크게 보는 페이지
// =====================================================
class PhotoViewPage extends StatefulWidget {

  final Album album;

  final VoidCallback onAddPhoto;
   

    const PhotoViewPage({
      super.key,
      required this.album,
      required this.onAddPhoto,
   });
  


  @override
  State<PhotoViewPage> createState() => _PhotoViewPageState();
}


class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 👉 배경 검정

      appBar: AppBar(
        actions:[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              widget.onAddPhoto();
            },
          ),
            
        ],
        backgroundColor: Colors.white,
        iconTheme:
          IconThemeData(color: Colors.black),
      ),

      // =========================
      // 📸 사진 슬라이드
      // =========================
      body: 
      Column(
        children: [
          Padding(
            padding:EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.album.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if(widget.album.memo.isNotEmpty)
                 Text(widget.album.memo),
              ],
            ),
            ),
        
      
        Expanded(
          child: PageView.builder(
            itemCount: widget.album.images.length,
            itemBuilder: (context, index) {
              return Image.file(File(widget.album.images[index]), fit: BoxFit.contain,);
            }
            ),
          ),
          ]
          )
        );
      }
      

  }





