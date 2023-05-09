import 'package:flutter/material.dart';
import 'package:todo_app_new_edition/ui/widgets/category_list.dart';
import 'package:todo_app_new_edition/utils/constants.dart';

class AllTask extends StatelessWidget {
  const AllTask({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          CategoryList(),
          SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: Stack(
              children: <Widget>[
                // Our background
                Container(
                  margin: EdgeInsets.only(top: 70),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                // ListView.builder(
                //   // here we use our demo procuts list
                //   itemCount: products.length,
                //   itemBuilder: (context, index) => ProductCard(
                //     itemIndex: index,
                //     product: products[index],
                //     press: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => DetailsScreen(
                //             product: products[index],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
