import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreenItem extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final String image;

  const FeedScreenItem({
    required this.title,
    required this.description,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  FeedScreenItemState createState() => FeedScreenItemState();
}

class FeedScreenItemState extends ConsumerState<FeedScreenItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 0, 16),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFCB997E),
                  ),
                ),
              ),
              Container(
                width: 400, // TODO
                height: 400, // TODO
                color: Colors.grey,
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFCB997E),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
