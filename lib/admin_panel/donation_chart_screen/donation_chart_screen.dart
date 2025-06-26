import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonationChartScreen extends StatefulWidget {
  static const String id = 'donationChartScreen';

  @override
  _DonationChartScreenState createState() => _DonationChartScreenState();
}

class _DonationChartScreenState extends State<DonationChartScreen> {
  List<PieChartSectionData> pieSections = [];
  String selectedRange = 'Daily';
  Map<String, int> groupedData = {};

  @override
  void initState() {
    super.initState();
    fetchDummyData();
  }

  void fetchDummyData() {
    // Dummy donation timestamps
    List<DateTime> dummyDonations = [
      DateTime.now().subtract(Duration(days: 0)),
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now().subtract(Duration(days: 3)),
      DateTime.now().subtract(Duration(days: 7)),
      DateTime.now().subtract(Duration(days: 10)),
      DateTime.now().subtract(Duration(days: 15)),
      DateTime.now().subtract(Duration(days: 25)),
      DateTime.now().subtract(Duration(days: 35)),
      DateTime.now().subtract(Duration(days: 40)),
    ];

    Map<String, int> tempData = {};

    for (DateTime dt in dummyDonations) {
      String key;

      if (selectedRange == 'Daily') {
        key = DateFormat('yyyy-MM-dd').format(dt);
      } else if (selectedRange == 'Weekly') {
        key = '${dt.year}-W${weekNumber(dt)}';
      } else {
        key = DateFormat('yyyy-MM').format(dt);
      }

      tempData[key] = (tempData[key] ?? 0) + 1;
    }

    tempData = Map.fromEntries(
        tempData.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

    final total = tempData.values.fold<int>(0, (sum, item) => sum + item);
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.amber,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.red,
      Colors.indigo
    ];

    List<PieChartSectionData> tempSections = [];
    int index = 0;

    if (tempData.isEmpty) {
      tempSections.add(PieChartSectionData(
        value: 100,
        color: Colors.grey,
        title: 'No Data',
        titleStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        radius: 80,
      ));
    } else {
      tempData.forEach((label, count) {
        final percentage = total == 0 ? 0.0 : (count / total) * 100;
        tempSections.add(
          PieChartSectionData(
            value: percentage,
            color: colors[index % colors.length],
            title: '$label\n${percentage.toStringAsFixed(1)}%',
            titleStyle: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
            radius: 80,
          ),
        );
        index++;
      });
    }

    setState(() {
      groupedData = tempData;
      pieSections = tempSections;
    });
  }

  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final diff = date.difference(firstDayOfYear).inDays;
    return ((diff + firstDayOfYear.weekday) / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donation Chart')),
      body: Column(
        children: [
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: selectedRange,
            items: ['Daily', 'Weekly', 'Monthly']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedRange = value!;
                fetchDummyData(); // refresh dummy data
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: pieSections.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PieChart(
                      PieChartData(
                        sections: pieSections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 4,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}














// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DonationChartScreen extends StatefulWidget {
//   static const String id = 'donationChartScreen';

//   @override
//   _DonationChartScreenState createState() => _DonationChartScreenState();
// }

// class _DonationChartScreenState extends State<DonationChartScreen> {
//   List<PieChartSectionData> pieSections = [];
//   String selectedRange = 'Daily';
//   Map<String, int> groupedData = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     final querySnapshot =
//         await FirebaseFirestore.instance.collection('donations').get();

//     final donations = querySnapshot.docs;

//     Map<String, int> tempData = {};

//     for (var doc in donations) {
//       Timestamp ts = doc['timestamp'];
//       DateTime dt = ts.toDate();
//       String key;

//       if (selectedRange == 'Daily') {
//         key = DateFormat('yyyy-MM-dd').format(dt);
//       } else if (selectedRange == 'Weekly') {
//         key = '${dt.year}-W${weekNumber(dt)}';
//       } else {
//         key = DateFormat('yyyy-MM').format(dt);
//       }

//       tempData[key] = (tempData[key] ?? 0) + 1;
//     }

//     tempData = Map.fromEntries(
//         tempData.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));

//     final total = tempData.values.fold<int>(0, (sum, item) => sum + item);
//     final colors = [
//       Colors.green,
//       Colors.blue,
//       Colors.amber,
//       Colors.purple,
//       Colors.orange,
//       Colors.teal,
//       Colors.red,
//       Colors.indigo
//     ];

//     List<PieChartSectionData> tempSections = [];
//     int index = 0;

//     if (tempData.isEmpty) {
//       tempSections.add(PieChartSectionData(
//         value: 100,
//         color: Colors.grey,
//         title: 'No Data',
//         titleStyle: TextStyle(
//             fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
//         radius: 80,
//       ));
//     } else {
//       tempData.forEach((label, count) {
//         final percentage = total == 0 ? 0.0 : (count / total) * 100;
//         tempSections.add(
//           PieChartSectionData(
//             value: percentage,
//             color: colors[index % colors.length],
//             title: '$label\n${percentage.toStringAsFixed(1)}%',
//             titleStyle: TextStyle(
//                 fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
//             radius: 80,
//           ),
//         );
//         index++;
//       });
//     }

//     setState(() {
//       groupedData = tempData;
//       pieSections = tempSections;
//     });
//   }

//   int weekNumber(DateTime date) {
//     final firstDayOfYear = DateTime(date.year, 1, 1);
//     final diff = date.difference(firstDayOfYear).inDays;
//     return ((diff + firstDayOfYear.weekday) / 7).ceil();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Donation Chart')),
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//           DropdownButton<String>(
//             value: selectedRange,
//             items: ['Daily', 'Weekly', 'Monthly']
//                 .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedRange = value!;
//                 fetchData();
//               });
//             },
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: pieSections.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: PieChart(
//                       PieChartData(
//                         sections: pieSections,
//                         centerSpaceRadius: 40,
//                         sectionsSpace: 4,
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
