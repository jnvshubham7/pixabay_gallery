import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> main() async {
  // await dotenv.load(fileName: ".env");
  runApp(PixabayGalleryApp());
}

//  Entry point of the Pixabay Gallery Application.
class PixabayGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixabay Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageGalleryScreen(),
    );
  }
}

/// Screen displaying a grid of images loaded from Pixabay.
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchImages();
      }
    });
  }

  /// Fetches images from the Pixabay API.
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
        title: Text('Pixabay Gallery'),
      ),
      body: images.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: getCrossAxisCount(context),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return ImageTile(imageData: images[index]);
                    },
                   
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                ),
                if (isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }

  /// Determines the number of columns based on screen width.
  int getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 5; // Desktop
    if (width > 800) return 4;  // Tablet
    return 2; // Mobile
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

/// Widget displaying individual image details.
class ImageTile extends StatelessWidget {
  final dynamic imageData;

  const ImageTile({Key? key, required this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
