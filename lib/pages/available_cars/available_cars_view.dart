import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import '../../core.dart';

class AvailableCarsView extends GetView<AvailableCarsController> {
  final filters = FilterService().getFilterList();

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      appBar: AppBarWidget(
        title: "Available Cars (" +
            CarService().getCarList().length.toString() +
            ")",
      ),
      body: Expanded(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.all(16),
                    physics: BouncingScrollPhysics(),
                    childAspectRatio: 1 / 1.6,
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    children: CarService().getCarList().map((item) {
                      String heroTag =
                          "available" + item.id.toString() + item.images[0];
                      return GestureDetector(
                        onTap: () => Get.toNamed(Routes.BOOK_CAR,
                            arguments: item,
                            parameters: {
                              "heroTag": heroTag,
                            }),
                        child: CarWidget(
                          car: item,
                          heroTag: heroTag,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 70,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildFilterIcon(),
                buildFilters(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFilterIcon() {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Center(
        child: Icon(
          LineIcons.filter,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget buildFilters() {
    return ValueBuilder<Filter>(
      initialValue: filters[0],
      builder: (value, updateFn) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: filters
            .map((filter) => buildFilter(value, filter, updateFn))
            .toList(),
      ),
    );
  }

  Widget buildFilter(Filter value, Filter filter, Function(Filter) updateFn) {
    return GestureDetector(
      onTap: () => updateFn(filter),
      child: Padding(
        padding: EdgeInsets.only(right: 17),
        child: Text(
          filter.name,
          style: TextStyle(
            color: value.name == filter.name ? kPrimaryColor : Colors.grey[500],
            fontSize: 16,
            fontWeight:
                value.name == filter.name ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
