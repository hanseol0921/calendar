import 'dart:io';
import 'package:flutter/material.dart';
import 'package:practice/pages/photo_view_page.dart';
import 'calendar_page.dart';

// =====================================================
// 📁 앨범 목록 페이지
// =====================================================
class AlbumListPage extends StatelessWidget {

  final List<Album> albums; // 👉 앨범 리스트 받기

  const AlbumListPage({
    super.key,
    required this.albums,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('앨범 목록'),
      ),

      // =========================
      // 📦 앨범 Grid
      // =========================
      body: GridView.builder(
        padding: EdgeInsets.all(8),

        itemCount: albums.length,

        // 👉 2열 그리드
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),

        itemBuilder: (context, index) {

          final album = albums[index];

          return GestureDetector(

            // 👉 앨범 클릭
            onTap: () {
               Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewPage(
                  album: album,
                   onAddPhoto: () {}, // 👉 여기 연결
                ),
              ),
            );
          },

            child: Column(
              children: [

                // =========================
                // 🖼 썸네일 영역
                // =========================
                Expanded(
                  child: Container(
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: Colors.grey[300], // 👉 기본 배경
                      borderRadius: BorderRadius.circular(8),
                    ),

                    // 👉 이미지 있으면 대표 이미지 보여줌
                    child: album.images.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(album.images[0]), // 👉 첫 이미지
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Icon(Icons.photo),
                          ),
                  ),
                ),

                SizedBox(height: 6),

                // =========================
                // 📝 앨범 제목
                // =========================
                Text(
                  album.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}