import 'package:flutter/material.dart';
import '../data/routes.dart';
import '../model/mealModel.dart';
import 'detailPage.dart';

class PageMeal extends StatefulWidget {
  final String Category;

  PageMeal({required this.Category});
  @override
  State<PageMeal> createState() => _PageMealState();
}

class _PageMealState extends State<PageMeal> {
  @override
  Widget build(BuildContext context) {
    String id = widget.Category;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          id,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: _buildListUsersBody(),
    );
  }

  Widget _buildListUsersBody() {
    String id = widget.Category;
    return Container(
      child: FutureBuilder(
        future: ApiRoutes.instance.loadMeal(id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            MealModel usersModel = MealModel.fromJson(snapshot.data);
            return _buildScreenSection(usersModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildScreenSection(MealModel model) {
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
          itemCount: model.meals!.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItemCategory(model.meals![index]);
          },
        ),
      ),
    );
  }

  Widget _buildItemCategory(Meals meal) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PageDetailMeal(idMeal: meal.idMeal!, nameMeal: meal.strMeal!),
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
                  image: NetworkImage(meal.strMealThumb!),
                ),
              ),
            ),
            Text(
              meal.strMeal!,
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
