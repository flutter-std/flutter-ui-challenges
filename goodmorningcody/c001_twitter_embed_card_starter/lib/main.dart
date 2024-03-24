import 'package:flutter/material.dart';
import 'package:twitter_embed_card/svg_asset.dart';
import 'package:twitter_embed_card/svg_icon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SvgAsset.preloadSVGs();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double screenWidth = constraints.maxWidth;
              return SingleChildScrollView(
                child: Row(
                  children: [
                    Flexible(child: Container()),
                    SizedBox(
                      width: screenWidth > 600 ? 600 : screenWidth,
                      child: const TwitterEmbedCard(),
                    ),
                    Flexible(child: Container()),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TwitterEmbedCard extends StatelessWidget {
  const TwitterEmbedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Column(
          children: [
            ProfileArea(),
            ContentsArea(),
            ContentsDescriptionsArea(),
            Divider(),
            SocialDescriptionsArea(),
            ReadRepliesArea(),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: SvgIcon(asset: SvgAsset.x),
        ),
      ],
    );
  }
}

class ProfileArea extends StatelessWidget {
  const ProfileArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage("andrea-avatar.png"),
        ),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Andrea Bizzotto",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                SvgIcon(
                  asset: SvgAsset.heartBlue,
                  height: 16,
                ),
                SizedBox(width: 4),
                SvgIcon(
                  asset: SvgAsset.verified,
                  height: 16,
                ),
              ],
            ),
            Row(
              children: [
                Text("@biz84"),
                Text("・"),
                Text(
                  "Follow",
                  style: TextStyle(
                    color: Color.fromARGB(255, 51, 133, 241),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class ContentsArea extends StatelessWidget {
  const ContentsArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const Text(
            "Did you know?\n\nWhen you call `MediaQuery.of(context)` inside a build method, the widget will rebuild when *any* of the MediaQuery properties change.\n\nBut there's a better way that lets you depend only on the properties you care about (and minimize unnecessary rebuilds). 👇",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset("media-query-banner.jpg"),
          ),
        ],
      ),
    );
  }
}

class ContentsDescriptionsArea extends StatelessWidget {
  const ContentsDescriptionsArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "10:21 AM・Jun 20, 2023",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF566370),
          ),
        ),
        SvgIcon(
          asset: SvgAsset.info,
          height: 20,
        )
      ],
    );
  }
}

class SocialDescriptionsArea extends StatelessWidget {
  const SocialDescriptionsArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SocialInfo(asset: SvgAsset.heartRed, text: "997"),
        SizedBox(width: 16),
        SocialInfo(asset: SvgAsset.comment, text: "Reply"),
        SizedBox(width: 16),
        SocialInfo(asset: SvgAsset.link, text: "Copy link"),
      ],
    );
  }
}

class SocialInfo extends StatelessWidget {
  final SvgAsset asset;
  final String text;
  const SocialInfo({super.key, required this.asset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgIcon(
          asset: asset,
          height: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromRGBO(86, 99, 112, 1),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ReadRepliesArea extends StatelessWidget {
  const ReadRepliesArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: 32,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF566370),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            "Read 12 replies",
            style: TextStyle(
              color: Color.fromARGB(255, 51, 133, 241),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
