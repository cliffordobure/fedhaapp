import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fedha/data/models/ads/ads.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoImageCarousel extends StatefulWidget {
  final List<Ads> ads;
  const VideoImageCarousel({super.key, required this.ads});

  @override
  State<VideoImageCarousel> createState() => _VideoImageCarouselState();
}

class _VideoImageCarouselState extends State<VideoImageCarousel> {
  final List<VideoPlayerController?> _controllers = [];
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _current = 0;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.ads.length; i++) {
      // get the data
      if (widget.ads[i].mediaType == "video" ||
          widget.ads[i].mediaPath.contains(".mp4")) {
        VideoPlayerController controller = VideoPlayerController.networkUrl(
            Uri.parse(widget.ads[i].mediaPath));
        if (i == _current) {
          controller.initialize().then((_) {
            controller.play();
            controller.addListener(() {
              debugPrint("Player position ${controller.value.position}");
              if (controller.value.position >= controller.value.duration) {
                // If video completes playing, stop and dispose the controller
                controller.pause();
                controller.seekTo(Duration.zero);

                _carouselController.startAutoPlay();
              }
            });
            setState(() {});
          });
        }

        logger.info(controller.dataSource);
        _controllers.add(controller);
      } else {
        _controllers.add(null); // Placeholder for images
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 10),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              if (_controllers[index] != null) {
                _carouselController.stopAutoPlay();
              }
              setState(() {
                _current = index;
              });
            },
            viewportFraction: 1,
            height: 150,
          ),
          items: List.generate(widget.ads.length, (index) {
            final ad = widget.ads[index];
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  // padding: const EdgeInsets.symmetric(
                  //     horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primaryColor.withOpacity(0.7)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ad.mediaType == "video" ||
                            ad.mediaPath.contains(".mp4")
                        ? AnimatedSwitcher(
                            duration: const Duration(milliseconds: 100),
                            child: AspectRatio(
                              key: ValueKey(_controllers[index]),
                              aspectRatio: 2.5,
                              child: !_controllers[index]!.value.isInitialized
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : VideoPlayer(_controllers[index]!),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: ad.mediaPath,
                            height: 120,
                            width: 120,
                            placeholder: (context, url) => const SizedBox(
                              width: 20,
                              height: 20,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.fill,
                          ),
                  ),
                );
              },
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.ads.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
