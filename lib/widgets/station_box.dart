import 'package:flutter/material.dart';

class StationBox extends StatelessWidget {
  const StationBox(
      {super.key,
      required this.image,
      required this.subtext,
      required this.text});
  final String image;
  final String text;
  final String subtext;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Stack(
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  "images/station/$image",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$text\n$subtext",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
