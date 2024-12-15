import 'package:flutter/material.dart';
import 'dart:io';
import 'history.dart'; // Import the HistoryPage class

class ResultPage extends StatefulWidget {
  final File image; // Receive the image file

  const ResultPage({required this.image});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isImageLoaded = false;
  bool _dataNotFound = false;
  bool _isTreeDetected = false; // Track if a tree is detected
  bool _isHumanDetected = false; // Track if a human is detected

  List<String> terminalMessages = [];
  double _progressValue = 0.0; // Progress indicator value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _isImageLoaded
                      ? Image.file(widget.image, fit: BoxFit.cover)
                      : Image.file(
                          widget.image,
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.5),
                          colorBlendMode: BlendMode.darken,
                        ),
                ),
                if (!_isImageLoaded)
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Here is the image result you picked!',
              style: TextStyle(
                  fontSize: 18, color: Colors.white, fontFamily: 'Courier'),
            ),
            SizedBox(height: 16),
            // Progress bar
            LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: Colors.black.withOpacity(0.5),
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display terminal messages with animations
                  for (var message in terminalMessages)
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        message,
                        key: ValueKey(message),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green.shade200,
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (_dataNotFound)
                    Text(
                      '> Warning: No dataset found in the image.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade200,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            // Add the button at the bottom
            Spacer(), // Pushes the button to the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to HistoryPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoryPage(imageHistory: [])),
                  );
                },
                child: Text('Continue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Simulate an image loading process with a delay and update terminal messages
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        terminalMessages.add('AI Terminal: Initializing...');
        _progressValue = 0.2;
      });
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        terminalMessages
            .add('> Image loaded successfully. AI is processing...');
        _progressValue = 0.4;
      });
    });

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        terminalMessages
            .add('> Analyzing image... Results will be available shortly.');
        _progressValue = 0.6;
      });
    });

    Future.delayed(Duration(seconds: 7), () {
      setState(() {
        terminalMessages.add('> Process complete. AI analysis is finished!');
        _progressValue = 0.8;
        _isImageLoaded = true; // Finally set image as loaded
        _simulateRecognition(); // Simulate tree or human detection
      });
    });

    Future.delayed(Duration(seconds: 9), () {
      setState(() {
        _progressValue = 1.0; // Indicate that the process is complete
        // Clear terminal and show final detection result
        terminalMessages.clear();
        _showDetectionResult();
      });
    });
  }

  // Simulate image recognition for tree or human detection
  void _simulateRecognition() {
    final detectedObject = _randomDetection();
    if (detectedObject == 'tree') {
      setState(() {
        _isTreeDetected = true;
        _isHumanDetected = false;
      });
    } else if (detectedObject == 'human') {
      setState(() {
        _isTreeDetected = false;
        _isHumanDetected = true;
      });
    } else {
      setState(() {
        _isTreeDetected = false;
        _isHumanDetected = false;
      });
    }
  }

  // Show the final detection result
  void _showDetectionResult() {
    if (_isTreeDetected) {
      terminalMessages.add('> Detection: Tree identified in the image.');
    } else if (_isHumanDetected) {
      terminalMessages.add('> Detection: Human identified in the image.');
    } else {
      terminalMessages.add('> Detection: No tree or human detected.');
    }
  }

  // Simulate random detection (for demonstration purposes)
  String _randomDetection() {
    final detections = ['tree', 'human', 'none'];
    detections.shuffle(); // Shuffle to simulate randomness
    return detections.first;
  }
}
