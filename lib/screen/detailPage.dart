import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/routes.dart';
import '../model/detailModel.dart';

class PageDetailMeal extends ConsumerWidget {
  final String idMeal;
  final String nameMeal;

  const PageDetailMeal({
    super.key,
    required this.idMeal,
    required this.nameMeal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Meal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: _buildListUsersBody(),
    );
  }

  Widget _buildListUsersBody() {
    String id = idMeal;
    return Container(
      child: FutureBuilder(
        future: ApiRoutes.instance.loadDetailMeal(id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            MealDetailModel usersModel =
                MealDetailModel.fromJson(snapshot.data);
            return _buildSuccessSection(usersModel);
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

  Widget _buildSuccessSection(MealDetailModel model) {
    return ListView.builder(
      itemCount: model.meals!.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItemDetailMeals(context, model.meals![index]);
      },
    );
  }

  Widget _buildItemDetailMeals(BuildContext context, Meals meal) {
    return InkWell(
      child: Column(
        children: [
          Hero(
            tag: meal.idMeal!,
            child: Image.network(
              meal.strMealThumb!,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          Text(meal.strMeal!,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  )),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Category : ' + meal.strCategory!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Area : ' + meal.strArea!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Ingredients',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            itemCount: meal.ingredients.length,
            itemBuilder: (context, index) {
              if (meal.ingredients[index] != "") {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          meal.ingredients[index]!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Instructions',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Text(
              meal.strInstructions!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              launchURL(meal.strYoutube!);
            },
            child: Text('Watch Tutorial'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

Future<void> launchURL(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw "Couldn`t launch $_url";
  }
}
