import 'package:flutter/material.dart';
import 'package:food_cycle/screens/needy_person/view_catagory_screen/view_catagories_screen.dart';
import 'package:food_cycle/utils/dummy/dummy_data.dart';

// ignore: must_be_immutable
class SinglechildscrollviewProduct extends StatefulWidget {
  String selectedCategory;
  SinglechildscrollviewProduct({super.key, required this.selectedCategory});

  @override
  State<SinglechildscrollviewProduct> createState() =>
      _SinglechildscrollviewProductState();
}

class _SinglechildscrollviewProductState
    extends State<SinglechildscrollviewProduct> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: DummyData.foodCategories.map((category) {
            widget.selectedCategory == category['name'];
            return InkWell(
              onTap: () {
                setState(() {
                  widget.selectedCategory = category['name']!;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewCategoriesScreen(
                              categoryName: widget.selectedCategory,
                            )));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(category['imageUrl']!),
                    ),
                    const SizedBox(height: 5),
                    Text(category['name']!),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
