import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html; // Import for web-specific full-screen API

// Entry point of the application.
Future<void> main() async {
  // Uncomment the following line to load environment variables from the .env file.
  // await dotenv.load(fileName: ".env");
  runApp(PixabayGalleryApp());
}

// The main application widget for Pixabay Gallery.
class PixabayGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixabay Gallery',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      themeMode:
          ThemeMode.system, // Automatically switch based on system setting
      home: ImageGalleryScreen(),
    );
  }
}

// Stateful widget to display a grid of images fetched from the Pixabay API.
class ImageGalleryScreen extends StatefulWidget {
  @override
  _ImageGalleryScreenState createState() => _ImageGalleryScreenState();
}

class _ImageGalleryScreenState extends State<ImageGalleryScreen> {
  List<dynamic> images = [];
  int page = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchImages();

    // Adding scroll listener to trigger fetch when at the bottom of the list.
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchImages();
      }
    });
  }

  // Fetches images from the Pixabay API and updates the state.
  Future<void> _fetchImages() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=46300711-6d7b7b666eb36969bf4f66970&image_type=photo&pretty=true&page=$page&per_page=20'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        images.addAll(data['hits']);
        page++;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pixabay Gallery',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
      ),
      body: images.isEmpty
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              strokeWidth: 4.0,
            ))
          : Column(
              children: [
                Expanded(
                  child: MasonryGridView.count(
                    padding: const EdgeInsets.all(8.0), // Add padding
                    controller: _scrollController,
                    crossAxisCount: _getCrossAxisCount(context),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.all(4.0), // Spacing between items
                        child: ImageTile(imageData: images[index]),
                      );
                    },
                    mainAxisSpacing: 8.0, // More spacing between grid items
                    crossAxisSpacing: 8.0,
                  ),
                ),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      strokeWidth: 4.0,
                    ),
                  ),
              ],
            ),
    );
  }

  // Determines the number of columns for the grid based on the screen width.
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 5; // Desktop layout
    if (width > 800) return 4; // Tablet layout
    return 2; // Mobile layout
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Widget to display individual image details in a grid tile.
class ImageTile extends StatelessWidget {
  final dynamic imageData;

  const ImageTile({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openImageFullscreen(context, imageData['largeImageURL']);
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Column(
            children: [
              Image.network(imageData['webformatURL']),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Likes: ${imageData['likes']}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Views: ${imageData['views']}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openImageFullscreen(BuildContext context, String imageUrl) {
    if (kIsWeb) {
      // Request full-screen mode in the browser
      html.document.documentElement?.requestFullscreen();
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  minScale: 0.5,
                  maxScale: 2.0,
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      if (kIsWeb) {
                        html.document.exitFullscreen();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue, // Solid blue background
                        shape: BoxShape.circle, // Circular shape
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Soft shadow
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: Offset(0, 2), // Shadow position
                          ),
                        ],
                      ),
                      padding:
                          EdgeInsets.all(8.0), // Padding inside the container
                      child: Icon(
                        Icons.close,
                        color: Colors.white, // White icon color
                        size: 24, // Slightly smaller size to fit the design
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
