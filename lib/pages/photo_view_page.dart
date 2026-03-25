import 'dart:io';
import 'package:flutter/material.dart';

// =====================================================
// 📸 사진 크게 보는 페이지
// =====================================================
class PhotoViewPage extends StatefulWidget {
   final List<File> photos;

   final VoidCallback onAddPhoto;

    const PhotoViewPage({
      super.key,
      required this.photos,
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
            onPressed: widget.onAddPhoto,
            )
        ],
        backgroundColor: Colors.white,
        iconTheme:
          IconThemeData(color: Colors.black),
      ),

      // =========================
      // 📸 사진 슬라이드
      // =========================
      body: 
      
      PageView.builder(
        itemCount: widget.photos.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.file(
              widget.photos[index],
              fit: BoxFit.contain, // 👉 전체 보이게
            ),
          );
        },
      ),
    );

  }
}




