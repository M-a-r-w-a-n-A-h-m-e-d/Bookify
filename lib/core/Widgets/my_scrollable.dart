import 'package:flutter/material.dart';

Widget MyScrollable({
  required BuildContext context,
  required int itemCount,
  required Color? color,
  required List<String> categories,
  required List<Widget> pages,

}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100.0,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.68),
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int itemIndex) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => pages[itemIndex],
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(13.0)),
                    ),
                    child: Center(
                      child: Text(
                        categories[itemIndex],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}
