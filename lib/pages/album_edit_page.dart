import 'package:flutter/material.dart';
import 'calendar_page.dart';

class AlbumEditPage extends StatefulWidget {
  final Album album;

  const AlbumEditPage({super.key, required this.album});

  @override
  State<AlbumEditPage> createState() => _AlbumEditPageState();
}

class _AlbumEditPageState extends State<AlbumEditPage> {
  late TextEditingController titleController;
  late TextEditingController memoController;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.album.title);
    memoController =
        TextEditingController(text: widget.album.memo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('앨범 설정')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: memoController,
              decoration: InputDecoration(labelText: '메모'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.album.title =
                    titleController.text.isEmpty
                        ? '앨범'
                        : titleController.text;

                widget.album.memo = memoController.text;

                Navigator.pop(context);
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}