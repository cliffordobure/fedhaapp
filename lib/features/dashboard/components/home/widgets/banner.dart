// import 'package:fedha/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/features/app/blocs/ads/bloc.dart';

import 'package:fedha/theme/theme_constants.dart';

// import 'package:fedha/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'video_player_widget.dart';

// import 'package:go_router/go_router.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsBloc, AdsState>(
      builder: (context, state) {
        if (state.ads.isEmpty) {
          return const SizedBox.shrink();
        }

        return
            // VideoImageCarousel(ads: state.ads);
            Column(
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                autoPlay: true,
                pauseAutoPlayInFiniteScroll: true,
                pauseAutoPlayOnTouch: true,
                autoPlayInterval: const Duration(seconds: 10),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  if (state.ads[index].mediaType == "video") {
                    //Get video player widget for current index
                    _carouselController.stopAutoPlay();

                    // final videoPlayer = context.read<VideoCubit>();

                    // if (videoPlayer.state.controller.value.position ==
                    //     const Duration(seconds: 0, minutes: 0, hours: 0)) {
                    //   print('video Started');
                    // }
                    // if (videoPlayer.state.controller.value.position ==
                    //     videoPlayer.state.controller.value.duration) {
                    //   print('video Ended');
                    //   _controller.nextPage();
                    //   _controller.startAutoPlay();
                    // }

                    // debugPrint(
                    //     videoPlayer.state.controller.position.toString());
                  } else {
                    _carouselController.startAutoPlay();
                  }
                  setState(() {
                    _current = index;
                  });
                },
                viewportFraction: 1,
                height: 180,
              ),
              items: state.ads.map((element) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.primaryColor.withOpacity(0.7)),
                      child: AspectRatio(
                        aspectRatio: 16 /
                            9, // You can set this to match the image aspect ratio
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: element.mediaPath.contains(".mp4")
                              ? Video.blocProvider(
                                  element.mediaPath,
                                  aspectRatio: 16 /
                                      9, // Ensure video maintains the same aspect ratio
                                )
                              : CachedNetworkImage(
                                  imageUrl: element.mediaPath,
                                  fit: BoxFit
                                      .cover, // Ensure the image covers the entire widget area
                                  placeholder: (context, url) => const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: <Widget>[
                      //           Text(
                      //             element.title,
                      //             style: Theme.of(context)
                      //                 .textTheme
                      //                 .bodyLarge!
                      //                 .copyWith(
                      //                     fontSize: 16,
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .onPrimary,
                      //                     fontWeight: FontWeight.bold),
                      //           ),
                      //           const SizedBox(
                      //             height: 8,
                      //           ),
                      //           Container(
                      //             constraints: BoxConstraints(
                      //                 maxWidth:
                      //                     MediaQuery.sizeOf(context).width / 2),
                      //             child: Text(
                      //               element.description,
                      //               maxLines: 2,
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .bodyMedium!
                      //                   .copyWith(
                      //                     fontSize: 12,
                      //                     color: Theme.of(context)
                      //                         .colorScheme
                      //                         .onPrimary
                      //                         .withOpacity(.9),
                      //                   ),
                      //             ),
                      //           ),
                      //           const Spacer(),
                      //           InkWell(
                      //             onTap: () {
                      //               context.pushNamed(Routes.webpage,
                      //                   extra: element.link ?? BASE_URL);
                      //             },
                      //             child: Container(
                      //               alignment: Alignment.center,
                      //               decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(40),
                      //                   color: Theme.of(context)
                      //                       .colorScheme
                      //                       .onPrimary),
                      //               height: 36,
                      //               width: 128,
                      //               child: Text(
                      //                 'View more',
                      //                 style: Theme.of(context)
                      //                     .textTheme
                      //                     .titleSmall!
                      //                     .copyWith(
                      //                         fontSize: 12,
                      //                         color: Theme.of(context)
                      //                             .primaryColor),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     ClipRRect(
                      //       borderRadius: BorderRadius.circular(8),
                      //       child: CachedNetworkImage(
                      //         imageUrl: element.mediaPath,
                      //         height: 120,
                      //         width: 120,
                      //         placeholder: (context, url) =>
                      //             const CircularProgressIndicator(),
                      //         errorWidget: (context, url, error) =>
                      //             const Icon(Icons.error),
                      //         fit: BoxFit.cover,
                      //       ),
                      //     )
                      //   ],
                      // ),
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: state.ads.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
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
      },
    );
  }
}
