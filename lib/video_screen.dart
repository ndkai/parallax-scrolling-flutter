import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paralax_scrolling/scroll_delegate.dart';
import 'package:video_player/video_player.dart';

final videos = [
  "assets/videos/1.mp4",
  "assets/videos/2.mp4",
  "assets/videos/3.mp4",
  "assets/videos/4.mp4",
];

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: PageView.builder(
            onPageChanged: (index){
              setState(() {
                selectedIndex = index;
              });
            },
              controller: _pageController,
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return VideoCard(
                  isSelected: selectedIndex == index,
                  videoPath: videos[index],
                );
              }),
        )
      ],
    ));
  }
}

class VideoCard extends StatefulWidget {
  final String videoPath;
  final bool isSelected;

  const VideoCard({super.key, required this.videoPath, required this.isSelected});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  GlobalKey videoKey = GlobalKey();
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath);
    _controller
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((value) => setState(() {}))
      ..play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        margin: widget.isSelected ?  EdgeInsets.symmetric(vertical: 16, horizontal: 4) :  EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54, offset: Offset(0, 6), blurRadius: 8)
            ]),
        duration: Duration(milliseconds: 100),
        child: Flow(
          delegate: ParallaxFlowDelegate(
              scrollable: Scrollable.of(context),
              listItemContext: context,
              backgroundImageKey: videoKey),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(
                  _controller,
                  key: videoKey,
                ),
              ),
            )
          ],
        ));
  }
}
