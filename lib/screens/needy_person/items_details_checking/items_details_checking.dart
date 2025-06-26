import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_cycle/provider/donation_datails_vm.dart';
import 'package:food_cycle/resources/componets/custom_button/custom_button.dart';
import 'package:food_cycle/screens/needy_person/items_details_checking/widget/build_card_widget.dart';
import 'package:food_cycle/screens/needy_person/items_details_checking/widget/flow_build_widget.dart';
import 'package:food_cycle/screens/needy_person/items_details_checking/widget/show_status_widget.dart';
import 'package:food_cycle/utils/extension.dart';

class DetailsScreen extends StatefulWidget {
  final String itemname;
  final String donatername;
  final String images;
  final String quantity;
  final String pickingtime;
  final String endtime;
  final String location;
  final String description;
  final int km;
  final String foodstatus;
  final String donationId;

  const DetailsScreen({
    super.key,
    required this.itemname,
    required this.images,
    required this.donationId,
    required this.quantity,
    required this.km,
    required this.location,
    required this.endtime,
    required this.pickingtime,
    required this.foodstatus,
    required this.description,
    required this.donatername,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final DonationDetailsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = DonationDetailsViewModel();
    viewModel.fetchDonationDetails(widget.donationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Donation Details",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(widget.images,
                    fit: BoxFit.cover, width: double.infinity, height: 250),
              ),
            ),
            const SizedBox(height: 20),
            buildCard(
              children: [
                buildInfoRow(Icons.fastfood, "Food Item", widget.itemname),
                buildInfoRow(Icons.person, "Donator Name", widget.donatername),
                buildInfoRow(Icons.access_time, "Pickup Time",
                    "${widget.pickingtime} - ${widget.endtime}"),
                buildInfoRow(Icons.place, "Location", widget.location),
                buildInfoRow(
                    Icons.description, "Description", widget.description),
              ],
            ),
            10.sH,
            buildCard(
              children: [
                buildStatusRow(viewModel.donationStatus),
                buildInfoRow(Icons.category, "Quantity", widget.quantity),
                buildInfoRow(
                    Icons.check_circle, "Food Status", widget.foodstatus),
                buildInfoRow(
                    Icons.directions_walk, "Distance", "${widget.km} km"),
              ],
            ),
            const SizedBox(height: 20),
            viewModel.donationStatus == 'inactive'
                ? CustomButton(
                    text: "Activate Donation",
                    color: Colors.green,
                    onTap: () {
                      viewModel.activateDonation(
                          widget.donationId,
                          FirebaseAuth.instance.currentUser!.uid.toString(),
                          widget.itemname,
                          widget.description,
                          widget.images,
                          widget.pickingtime,
                          widget.endtime,
                          widget.location,
                          widget.foodstatus);
                    })
                : Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 30.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: const Center(
                      child: Text(
                        'Not Avaialbe',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
