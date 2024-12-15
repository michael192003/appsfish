import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'history.dart' as history_page; // Alias for history.dart import
import 'result.dart'; // Import ResultPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Example',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late File _image;
  bool _imagePicked = false;
  bool _isLoading = false; // Loading state
  List<File> imageHistory = []; // List to store image history

  // Function to pick an image from the camera
  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imagePicked = true;
        _isLoading = false; // Hide loading indicator after picking
        imageHistory.add(_image); // Add picked image to history
      });
    } else {
      setState(() {
        _isLoading = false; // Hide loading if no image was picked
      });
      print('No image selected');
    }
  }

  // Function to reset the image
  void _resetImage() {
    setState(() {
      _imagePicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, color: Colors.white),
            SizedBox(width: 10),
            Text('Dashboard',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Navigate to HistoryPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      history_page.HistoryPage(imageHistory: imageHistory),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade900, Colors.grey.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: _imagePicked
                  ? Image.file(_image, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        'No Image Selected',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 8),

            // Show loading indicator
            if (_isLoading)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            SizedBox(height: 8),

            // Reset button to clear the image
            if (_imagePicked)
              ElevatedButton(
                onPressed: _resetImage,
                child: Text('Erase'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 112, 104, 104),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
              ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 2,
                itemBuilder: (context, index) {
                  final items = [
                    {'icon': Icons.camera_alt, 'label': 'Camera Access'},
                    {'icon': Icons.article, 'label': 'Result'},
                  ];
                  return DashboardItem(
                    icon: items[index]['icon'] as IconData,
                    label: items[index]['label'] as String,
                    onTap: () {
                      if (items[index]['label'] == 'Camera Access') {
                        _pickImage(ImageSource.camera);
                      } else if (items[index]['label'] == 'Result') {
                        // Navigate to ResultPage and pass the image
                        if (_imagePicked) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(image: _image),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please pick an image first.'),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.grey.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
