import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/pages/article_view.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_data.dart';

class AllNews extends StatefulWidget {
  final String news;
  const AllNews({
    super.key,
    required this.news,
  });

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;

  @override
  void initState() {
    getSliders();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;

    setState(() {
      _loading = false;
    });
  }

  getSliders() async {
    Sliders sliderClass = new Sliders();
    await sliderClass.getSliders();
    sliders = sliderClass.sliders;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.news + " News",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: widget.news == "Breaking"
                      ? sliders.length
                      : articles.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return AllNewsSection(
                      image: widget.news == "Breaking"
                          ? sliders[index].urlToImage!
                          : articles[index].urlToImage!,
                      desc: widget.news == "Breaking"
                          ? sliders[index].description!
                          : articles[index].description!,
                      title: widget.news == "Breaking"
                          ? sliders[index].title!
                          : articles[index].title!,
                      url: widget.news == "Breaking"
                          ? sliders[index].url!
                          : articles[index].url!,
                    );
                  },
                ),
              ),
            ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  final String image, desc, title, url;
  const AllNewsSection({
    super.key,
    required this.image,
    required this.desc,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(blogUrl: url),
          ),
        );
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              desc,
              maxLines: 3,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
