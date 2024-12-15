// lib/image_detail_page.dart
import 'package:flutter/material.dart';
import 'dart:io';

class ImageDetailPage extends StatelessWidget {
  final File image;

  // Constructor to receive the image file
  ImageDetailPage({required this.image});

  @override
  Widget build(BuildContext context) {
    // Set your desired width and height for the image
    double imageWidth = 200.0; // Example width in pixels
    double imageHeight = 300.0; // Example height in pixels

    return Scaffold(
      appBar: AppBar(
        title: Text('Image Detail'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // To prevent the column from expanding too much
          children: [
            // Box above the image (Fixed size for the box)
            Container(
              width: 550.0, // Fixed width for the box
              height: 450.0, // Fixed height for the box
              padding: EdgeInsets.all(10.0), // Padding inside the container
              margin:
                  EdgeInsets.only(bottom: 20.0), // Space below the container
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255), // Background color for the box
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 10.0), // Space between text and next widget
                  Text(
                    'This is a detailed view of the image. You can add more information here.',
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
            ),

            // Image at the bottom (Fixed size for the image)
            Image.file(
              image,
              width: 300, // Set the width of the image
              height: 300, // Set the height of the image
              fit: BoxFit
                  .cover, // This will make the image cover the set width and height
            ),
          ],
        ),
      ),
    );
  }
}
