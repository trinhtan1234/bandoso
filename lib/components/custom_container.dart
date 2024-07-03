import 'package:flutter/material.dart';

class AppContainer extends StatefulWidget {
  final String? title;
  final String? content;
  final String? publishedAt;
  final String? newstype;
  final Icon? icon;
  final String? urlToImage;
  final TextStyle? style;

  const AppContainer({
    super.key,
    this.title,
    this.content,
    this.publishedAt,
    this.newstype,
    this.style = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.icon,
    this.urlToImage,
  });

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        border: Border(
          top: BorderSide(width: 0.5),
        ),
      ),
      margin: const EdgeInsets.all(10),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Row(
              children: [
                Flexible(
                  child: Text(widget.title ?? ''),
                ),
              ],
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.content ?? '',
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.public,
                      size: 15,
                    ),
                    Text(widget.publishedAt ?? ''),
                  ],
                ),
              ],
            ),
          ),
          if (widget.urlToImage != null && widget.urlToImage!.isNotEmpty)
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: ClipRRect(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image(
                    image: NetworkImage(
                      widget.urlToImage ?? '',
                    ),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width - 20,
                  ),
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(widget.newstype ?? ''),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
