import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taksh_e_commerce/core/theme/app_colors.dart';

/// Full-width product image carousel with no background box.
///
/// Images are shown with [BoxFit.contain] so the whole product is visible;
/// tapping opens a full-screen, pinch-to-zoom viewer.
class ProductImageGallery extends StatefulWidget {
  final List<String> urls;
  final double height;

  const ProductImageGallery({super.key, required this.urls, this.height = 340});

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _page = 0;

  void _openViewer(int index) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _FullScreenGallery(urls: widget.urls, initial: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.urls.isEmpty) {
      return SizedBox(
        height: widget.height * 0.7,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 56,
            color: AppColors.grey400,
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.urls.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => _openViewer(index),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: CachedNetworkImage(
                  imageUrl: widget.urls[index],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 56,
                      color: AppColors.grey400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.urls.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.urls.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: i == _page ? 18 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: i == _page
                          ? AppColors.primaryOrange
                          : AppColors.grey300,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> urls;
  final int initial;

  const _FullScreenGallery({required this.urls, required this.initial});

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late final PageController _controller = PageController(
    initialPage: widget.initial,
  );
  late int _page = widget.initial;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: widget.urls.length > 1
            ? Text('${_page + 1} / ${widget.urls.length}')
            : null,
        centerTitle: true,
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.urls.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (context, index) => InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.urls[index],
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image_outlined,
                  size: 64,
                  color: AppColors.grey400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
