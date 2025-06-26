import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerList() {
  return ListView.builder(
    itemCount: 5,
    padding: const EdgeInsets.all(10),
    itemBuilder: (context, index) {
      return buildShimmerEffect();
    },
  );
}

Widget buildShimmerEffect() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 20, width: double.infinity, color: Colors.grey),
                    const SizedBox(height: 5),
                    Container(height: 15, width: 100, color: Colors.grey),
                    const SizedBox(height: 5),
                    Container(height: 15, width: 50, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
