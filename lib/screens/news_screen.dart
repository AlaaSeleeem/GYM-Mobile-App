import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gymm/components/news_card.dart';
import 'package:gymm/screens/news_detail_screen.dart';

import '../api/actions.dart';
import '../components/loading.dart';
import '../models/news.dart';
import '../utils/snack_bar.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int currentPage = 1;
  bool loading = false;
  bool hasMore = true;

  late List<News> news = [];
  CancelableOperation? _currentOperation;

  @override
  void initState() {
    super.initState();
    _loadMoreNews();
  }

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
  }

  Future<void> _refreshNews() async {
    setState(() {
      news = [];
      currentPage = 1;
      hasMore = true;
    });
    await _loadMoreNews();
  }

  Future<void> _loadMoreNews() async {
    if (loading || !hasMore) return;
    setState(() {
      loading = true;
    });

    _currentOperation?.cancel();
    _currentOperation = CancelableOperation.fromFuture(getNews(currentPage));

    _currentOperation!.value.then((value) {
      if (!mounted) return;

      final (List<News> newItems, bool next) = value;
      setState(() {
        currentPage++;
        news.addAll(newItems);
        if (!next) {
          hasMore = false;
        }
      });
    }).catchError((e) {
      showSnackBar(context, "Failed loading news", "error");
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  // List news = [
  //   {
  //     "title": "Discover our new treadmills",
  //     "image": null /*"assets/treadmills.jpg"*/
  //   },
  //   {"title": "Expert boxing training", "image": "assets/boxing.jpg"},
  //   {"title": "Unwind with yoga sessions", "image": "assets/yoga.jpg"},
  //   {"title": "High-intensity interval training", "image": "assets/hiit.jpg"},
  //   {
  //     "title": "Advanced weightlifting equipment",
  //     "image": "assets/weightlifting.webp"
  //   },
  //   {"title": "Personalized fitness coaching", "image": "assets/coaching.webp"}
  // ];

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
        onRefresh: _refreshNews,
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
                            builder: (context) =>
                                NewsDetailPage(item: news[index])));
                      },
                      child: NewsCard(item: news[index]),
                    ),
                    itemCount: news.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  if (loading)
                    const Loading(
                      height: 100,
                    ),
                  if (!loading && news.isEmpty)
                    const Center(
                      child: Text(
                        "No current Plans",
                        style: TextStyle(fontSize: 24),
                      ),
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
