import 'package:flutter/material.dart';
import 'package:gymm/components/news_card.dart';
import 'package:gymm/screens/news_detail_screen.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List news = [
    {"title": "Discover our new treadmills", "image": "assets/treadmills.jpg"},
    {"title": "Expert boxing training", "image": "assets/boxing.jpg"},
    {"title": "Unwind with yoga sessions", "image": "assets/yoga.jpg"},
    {"title": "High-intensity interval training", "image": "assets/hiit.jpg"},
    {
      "title": "Advanced weightlifting equipment",
      "image": "assets/weightlifting.webp"
    },
    {"title": "Personalized fitness coaching", "image": "assets/coaching.webp"}
  ];

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'News',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEndNotification) {
            return false;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isLandscape ? 2 : 1,
                        childAspectRatio: 4 / 2.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NewsDetailPage(
                                image: news[index]["image"],
                                title: news[index]["title"],
                                date: DateTime.now(),
                                content:
                                    "content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content content ")));
                      },
                      child: NewsCard(
                        title: news[index]["title"],
                        image: news[index]["image"],
                      ),
                    ),
                    itemCount: news.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
