import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageEditorScreen extends StatefulWidget {
  final String imageUrl;
  final String heroTag;

  const ImageEditorScreen({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  int _quarterTurns = 0;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _rotateLeft() {
    setState(() {
      _quarterTurns--;
    });
  }

  void _rotateRight() {
    setState(() {
      _quarterTurns++;
    });
  }

  void _resetView() {
    setState(() {
      _quarterTurns = 0;
      _transformationController.value = Matrix4.identity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'image_editor'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.rotate_left),
            onPressed: _rotateLeft,
            tooltip: 'Rotate Left',
          ),
          IconButton(
            icon: const Icon(Icons.rotate_right),
            onPressed: _rotateRight,
            tooltip: 'Rotate Right',
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _resetView,
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: widget.heroTag,
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 4.0,
            child: RotatedBox(
              quarterTurns: _quarterTurns,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error, color: Colors.red, size: 50),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
