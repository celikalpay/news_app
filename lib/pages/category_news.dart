import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/show_category.dart';
import 'package:news_app/pages/article_view.dart';
import 'package:news_app/services/show_category_news.dart';

class CategoryNews extends StatefulWidget {
  final String name;
  CategoryNews({
    super.key,
    required this.name,
  });

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = [];
  bool _loading = true;

  getCategoryNews() async {
    ShowCategoryNews showCategoryNews = ShowCategoryNews();
    await showCategoryNews.getCategoryNews(widget.name.toLowerCase());
    categories = showCategoryNews.categories;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    getCategoryNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
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
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ShowCategory(
                      image: categories[index].urlToImage!,
                      desc: categories[index].description!,
                      title: categories[index].title!,
                      url: categories[index].url!,
                    );
                  },
                ),
              ),
            ),
    );
  }
}

class ShowCategory extends StatelessWidget {
  final String image, desc, title, url;
  const ShowCategory({
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
