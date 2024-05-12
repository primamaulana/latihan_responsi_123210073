import 'package:flutter/material.dart';
import '../data/routes.dart';
import '../model/categoryModel.dart';
import 'mealPage.dart';

class PageCategory extends StatefulWidget {
  const PageCategory({Key? key}) : super(key: key);
  @override
  State<PageCategory> createState() => _PageCategoryState();
}

class _PageCategoryState extends State<PageCategory>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: ApiRoutes.instance.loadCategory(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              CategoryModel usersModel = CategoryModel.fromJson(snapshot.data);
              return _buildScreenSection(usersModel);
            }
            return _buildLoadingSection();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget _buildScreenSection(CategoryModel model) {
    return Scaffold(
      body: Center(
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: model.categories!.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItemCategory(model.categories![index]);
          },
        ),
      ),
    );
  }

  Widget _buildItemCategory(Categories category) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PageMeal(Category: category.strCategory!),
        ),
      ),
      splashColor: Colors.brown,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(90),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  scale: 1,
                  image: NetworkImage(category.strCategoryThumb!),
                ),
              ),
            ),
            Text(
              category.strCategory!,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
