import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalenadrPage(),
    );
  }
}

class CalenadrPage extends StatefulWidget {
  const CalenadrPage({super.key});

  @override
  State<CalenadrPage> createState() => _CalenadrPageState();
}

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
  return photoMap[normalizeDate(day)]?.isNotEmpty ?? false;
}
List<File> getPhotos(DateTime day) {
  return photoMap[normalizeDate(day)] ?? [];
}

final ImagePicker picker = ImagePicker();
Future<void> pickImage(DateTime day) async {
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery);
  if (image != null) {
    setState((){
      final key = normalizeDate(day);

      // 👉 해당 날짜에 리스트 없으면 생성
        if (photoMap[key] == null) {
          photoMap[key] = [];
        }

      // 👉 선택한 이미지 File로 변환 후 저장
        photoMap[key]!.add(File(image.path));
      });
  }
}
void showPhotoOptions(DateTime day) {
  // Show photo options for the selected day
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
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
            ListTile(
              leading: Icon(Icons.close),
              title: Text('사진 삭제'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                   photoMap[normalizeDate(day)] = [];
                });
              },
            )
          ],
        )
        );
    }
    );
}

Widget buildCell(DateTime day, bool hasImage, bool isToday) {
  final photos = getPhotos(day);
  return Container(
    margin: EdgeInsets.zero,
    
    child: Stack(
      children: [
        if (photos.isNotEmpty)
          Positioned.fill(child: photos.length == 1
              ? Image.file(
                  photos[0],
                  fit: BoxFit.cover,
                )
              : GridView.count(
                    crossAxisCount: 1,
                    physics: NeverScrollableScrollPhysics(),
                    children: photos.take(4).map((file){
                      return Image.file(
                        file,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                    ),
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
            visible: !hasImage,
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
        title: Text('Caledar')
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
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          // 선택된 날짜의 상태를 갱신합니다.	
          setState((){
            this.selectedDay = selectedDay;
            this.focusedDay = focusedDay;
          });
          showPhotoOptions(selectedDay);
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
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
        ),
       );
     
  }
}
