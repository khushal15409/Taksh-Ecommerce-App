import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taksh_e_commerce/features/home/data/models/banner_model.dart';

/// Banner carousel widget for displaying promotional banners
class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  final Function(BannerModel)? onBannerTap;

  const BannerCarousel({
    super.key,
    required this.banners,
    this.onBannerTap,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return _BannerItem(
                banner: banner,
                onTap: () => widget.onBannerTap?.call(banner),
              );
            },
          ),
        ),
        if (widget.banners.length > 1) ...[
          const SizedBox(height: 12),
          _PageIndicator(
            itemCount: widget.banners.length,
            currentIndex: _currentPage,
          ),
        ],
      ],
    );
  }
}

/// Individual banner item
class _BannerItem extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback? onTap;

  const _BannerItem({
    required this.banner,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: banner.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.error, size: 48),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Page indicator dots
class _PageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const _PageIndicator({
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
