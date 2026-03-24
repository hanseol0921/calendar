import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

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
Map<DateTime, bool> photoMap = {
    DateTime(2026, 3, 23): true,
    DateTime(2026, 3, 25): true,
  };

DateTime normalizeDate(DateTime day) {
  return DateTime(day.year, day.month, day.day);
  }

  // 👉 해당 날짜에 사진 있는지 확인
bool hasPhoto(DateTime day) {
  return photoMap[normalizeDate(day)] ?? false;
  }



Widget buildCell(DateTime day, bool hasImage, isToday) {
  return Container(
    margin: EdgeInsets.zero,
    
    child: Stack(
      children: [
        
        if (hasImage)
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
        if (isToday)
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.yellow,
                width: 2,
              ),
            ),
          ),

        Center(
          child:Visibility(
            visible: !hasImage,
              child: Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 12,
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
      appBar: AppBar(title: Text('Caledar')),
      body: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2023,05,30),
        lastDay: DateTime.utc(2030,05,30),
        focusedDay:  focusedDay,

        rowHeight: 80,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          tableBorder: TableBorder.all(
            color: Colors.grey,
            width: 1,
          ),
        ),

        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          // 선택된 날짜의 상태를 갱신합니다.	
          setState((){
            this.selectedDay = selectedDay;
            this.focusedDay = focusedDay;
          });
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
       );
     
  }
}
