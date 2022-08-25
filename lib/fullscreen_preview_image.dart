import 'package:flutter/material.dart';

class FullScreenImagePreview extends StatelessWidget {
  final String image;
  final Object tag;
  const FullScreenImagePreview(
      {Key? key, required this.image, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: GridTile(
          footer: const GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(
              'Latitude: 20.296059',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            subtitle: Text(
              'Longitude: 85.824539',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          child: Center(
            child: Hero(
              // tag: 'imageHero',
              tag: tag,
              child: Image.asset(
                image.toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
