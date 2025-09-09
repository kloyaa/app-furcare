import 'dart:math';

import 'package:flutter/material.dart';

List<Image> carouselItemsAlwaysRandom() {
  final List<String> imagePaths = [
    'assets/carousel_1.jpeg',
    'assets/carousel_2.jpeg',
    'assets/carousel_3.jpeg',
    'assets/carousel_4.jpeg',
    'assets/carousel_5.jpeg',
    'assets/carousel_6.jpeg',
    'assets/carousel_7.jpeg',
    'assets/carousel_8.jpeg',
  ];

  // Create a new Random instance each time for different results
  final random = Random();
  final shuffledPaths = List<String>.from(imagePaths)..shuffle(random);

  return shuffledPaths.map((path) => Image.asset(path)).toList();
}
