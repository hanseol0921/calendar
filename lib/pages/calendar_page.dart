import 'package:flutter/material.dart';
import 'package:practice/pages/album_edit_page.dart';
import 'package:practice/pages/album_list_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'photo_view_page.dart';

class CalenadrPage extends StatefulWidget {
  const CalenadrPage({super.key});

  @override
  State<CalenadrPage> createState() => _CalenadrPageState();
}

// =====================================================
// 📁 앨범 데이터
// =====================================================
class Album {
  String title; // 👉 앨범 이름
  List<String> images; // 👉 일단 이미지 경로 (지금은 비어있어도 됨)
  String memo;

  Album({
    required this.title,
    required this.images,
    this.memo = '',
  });
}

Map<DateTime, List<Album>> albumMap = {};

class _CalenadrPageState extends State<CalenadrPage> {
  DateTime selectedDay = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

DateTime focusedDay = DateTime.now();
Map<DateTime, List<File>> photoMap = {
  };

DateTime normalizeDate(DateTime day) {
  return DateTime(day.year, day.month, day.day);
  }

  // 👉 해당 날짜에 사진 있는지 확인
  bool hasPhoto(DateTime day) {
  return albumMap[normalizeDate(day)]?.isNotEmpty ?? false;
}

List<File> getPhotos(DateTime day) {
  return photoMap[normalizeDate(day)] ?? [];
}
List<Album> getAlbums(DateTime day) {
  return albumMap[normalizeDate(day)] ?? [];
}




final ImagePicker picker = ImagePicker();


Future<void> pickImage(DateTime day) async {
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery);
      if (image == null) return;
       // 👉 이미지 선택 취소
       
      
      final path = image.path;
      final newAlbum = Album(
        title: '',
        images: [path],
     );
     // ⭐ 2. 설정창 이동
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlbumEditPage(album: newAlbum),
       ),
     );
      setState(() {
        albumMap[normalizeDate(day)] ??= [];
          albumMap[normalizeDate(day)]!.add(newAlbum);
});
    }
  

Future<void> addImageToAlbum(Album album) async {
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image == null) return;

  setState(() {
    album.images.add(image.path);
  });
}



void showPhotoOptions(DateTime day) {
    // Show photo options for the selected day
  showModalBottomSheet(
    context: context,
    builder: (context) {
      
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            ListTile(
              leading: Icon(Icons.add_a_photo),
              title: Text('사진 추가'),
              onTap: () {
                Navigator.pop(context);
                pickImage(day);
              },
            ),
          ],
        )
        )
        );
    }
    );
}

Widget BuildImage(String path) {
  return Image.file(
    File(path),
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
  );
}

Widget buildCell(DateTime day, bool hasImage, bool isToday) {
  final Albums = getAlbums(day);
  return Container(
    margin: EdgeInsets.zero,
    //사진정렬
    child: Stack(
      children: [
        if (Albums.isNotEmpty)
          BuildImage(Albums[0].images[0]),
        if (Albums.length == 2)
          Column(
            children: [
              Expanded(
                child: 
                BuildImage(Albums[0].images[0])
              ),
              Expanded(
                child: 
                BuildImage(Albums[1].images[0])
              ),
            ],
          ),
        if (Albums.length == 3)
          Column(
            children: [
              Expanded(
                child: 
                BuildImage(Albums[0].images[0])
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: 
                      BuildImage(Albums[1].images[0])
                    ),
                    Expanded(
                      child: 
                      BuildImage(Albums[2].images[0])
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (Albums.length >= 4)
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: 
                      BuildImage(Albums[0].images[0])
                    ),
                    Expanded(
                      child: 
                      BuildImage(Albums[1].images[0])
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: 
                      BuildImage(Albums[2].images[0])
                    ),
                    Expanded(
                      child: BuildImage(Albums[3].images[0])
                    ),
                  ],
                ),
              ),
            ],
          ),


        if (isToday)
          Container(
            decoration: BoxDecoration(
              border: Border .all(
                color: Colors.yellow,
                width: 1,
              ),
            ),
          ),

        Center(
          child:Visibility(
            visible: hasImage==false,
              child: Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 14,
              color: hasImage ? Colors.white : Colors.black,
            ),
            ),
          ),
         ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Caledar'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              pickImage(selectedDay);
            },
          ),
        ],
      ),  
      body: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2023,05,30),
        lastDay: DateTime.utc(2030,05,30),
        focusedDay:  focusedDay,

        rowHeight: 80,
        daysOfWeekHeight: 40,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
        ),



        // 선택된 날짜의 상태를 갱신합니다.//
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          setState((){
            this.selectedDay = selectedDay;
            this.focusedDay = focusedDay;
          });

          final albums = getAlbums(selectedDay);

            
          if (albums.isEmpty) {
             showPhotoOptions(selectedDay);
          }
          else if (albums.length == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewPage(
                  album: albums[0],
                   onAddPhoto: () {
                    addImageToAlbum(albums[0]);
                   }, // 👉 여기 연결
                ),
              ),
            ).then((_){
              setState(() {}); // 앨범 페이지에서 돌아올 때 상태 갱신
            });
          }
          else {
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumListPage(albums: albums),
              ),
            );
          };
          },

        
        selectedDayPredicate: (DateTime day) {
          // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.	
          return isSameDay(selectedDay, day);
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            ),
          calendarBuilders: CalendarBuilders(
            outsideBuilder: (context, day, focusedDay) {
             return SizedBox(); // 👉 아무것도 안 그림
            },
            defaultBuilder: (context, day, focusedDay) {
              final hasImage = hasPhoto(day);
              final isToday = isSameDay(day, DateTime.now());
              return buildCell(day, hasImage, isToday);
            },
                
            todayBuilder: (context, day, focusedDay){
              final hasImage = hasPhoto(day);
              return buildCell(day, hasImage,true);
            },
            selectedBuilder: (context, day, focusedDay) {
              final hasImage = hasPhoto(day);
              final isToday = isSameDay(day, DateTime.now());
              return buildCell(day, hasImage, isToday);
            }
           )
                
          ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: '갤러리',
          ),
        ],
        ),
       );
     
  }
}