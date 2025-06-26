// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SearchfieldWidget extends StatefulWidget {
  final TextEditingController searchController;
  String searchText;
  SearchfieldWidget(
      {super.key, required this.searchController, required this.searchText});

  @override
  State<SearchfieldWidget> createState() => _SearchfieldWidgetState();
}

class _SearchfieldWidgetState extends State<SearchfieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.searchController,
        onChanged: (value) {
          setState(() {
            widget.searchText = value;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.grey, // Hint text color
            fontStyle: FontStyle.italic,
          ),
          suffixIcon: Icon(Icons.search), // Icon after the input
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }
}
