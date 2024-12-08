import 'package:b2gin/presenter/feed_screen_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  FeedScreenState createState() => FeedScreenState();
}

class FeedScreenState extends ConsumerState<FeedScreen> {
  List<FeedScreenItem> feedItems = [
    FeedScreenItem(
      title: '@보리',
      description: '우리 보리가 태어나서 첫 산책을 했어요! 무서워하지 않고 잘 다니니 보기 좋네요.',
      image:
          'https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_960_720.jpg',
    ),
    FeedScreenItem(
      title: '@시로',
      description: '봄이가 한달 전에 낳은 강아지인 시로는 이제 1살이 되었어요. 너무 귀여웡!',
      image:
          'https://lh3.googleusercontent.com/proxy/wv4HxLAA1NOI5jB11maauNkbQ-QeSmPEpLo9uhxZleJ7mBG-UAf8dqIt1i4onks5YrrG4o6UbqTtJxvbrPRLNgUEzrbzmCWsl9apAeUNpHsTxtZN_Z4hsyA',
    ),
    FeedScreenItem(
      title: '@도깨',
      description: '사실 도깨는 저희 집 강아지는 아니구요. 다들 아시잖아요?',
      image:
          'https://i.namu.wiki/i/caDGc_4nF3ZCIxLITwXt4aHhFoLJ0PFf0AUUQDsTR-hHc0St_th29J7p-ttO_2g5pOYzpWy3FEt5FXzxV_itjQ.webp',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: feedItems.length,
      itemBuilder: (context, index) {
        return feedItems[index];
      },
    );
  }
}
