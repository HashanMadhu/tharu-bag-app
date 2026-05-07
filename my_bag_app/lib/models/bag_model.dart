import 'package:flutter/material.dart';

class BagProduct {
  final String name;
  final String imagePath;
  final double price;
  final Color color;

  BagProduct({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.color,
  });
}

// දැනට අපේ ඇප් එකේ ඇති බෑග් වර්ග මෙහි ඇතුළත් කරමු
List<BagProduct> tharuBags = [
  BagProduct(
    name: "School Bag",
    imagePath: "assets/school_bag.png",
    price: 1500,
    color: Colors.blue,
  ),
  BagProduct(
    name: "Travel Bag",
    imagePath: "assets/travel_bag.png",
    price: 2500,
    color: Colors.green,
  ),
  BagProduct(
    name: "Hand Bag",
    imagePath: "assets/hand_bag.png",
    price: 1200,
    color: Colors.brown,
  ),
  BagProduct(
    name: "Lunch Bag",
    imagePath: "assets/lunch_bag.png",
    price: 1500,
    color: Colors.purple,
  ),
];
