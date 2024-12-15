// lib/history.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'image_detail_page.dart'; // Import the ImageDetailPage

class HistoryPage extends StatelessWidget {
  final List<File> imageHistory;

  HistoryPage({required this.imageHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image History'),
        backgroundColor: Colors.black,
      ),
      body: imageHistory.isEmpty
          ? Center(
              child: Text(
                'No images in history',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: imageHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.file(
                    imageHistory[index],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    'Image ${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Navigate to ImageDetailPage when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageDetailPage(
                          image: imageHistory[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
