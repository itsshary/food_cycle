import 'package:flutter/material.dart';
import 'package:food_cycle/resources/componets/custom_button/custom_button.dart';
import 'package:food_cycle/screens/donater_screen/donator_active_donation/view_needy_profile.dart';

class ViewDetailsDonation extends StatefulWidget {
  final String itemname;
  final String images;
  final String activeuseruid;
  final String quantity;
  final String pickingtime;
  final String endtime;

  final String description;
  final int km;
  final String donationstatus;
  final String foodstatus;
  final String donationId; // Donation document ID

  const ViewDetailsDonation({
    super.key,
    required this.itemname,
    required this.images,
    required this.donationId,
    required this.quantity,
    required this.activeuseruid,
    required this.km,
    required this.donationstatus,
    required this.endtime,
    required this.pickingtime,
    required this.foodstatus,
    required this.description,
  });

  @override
  State<ViewDetailsDonation> createState() => _ViewDetailsDonationState();
}

class _ViewDetailsDonationState extends State<ViewDetailsDonation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Completed Donations",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(widget.images, fit: BoxFit.fill),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.itemname,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Donation Status: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.donationstatus == "active" ? "Active" : "Inactive",
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.donationstatus == "active"
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Quantity: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.quantity,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Food Status: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.foodstatus,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Timing Range: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "${widget.pickingtime} ---- ${widget.endtime}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Distance: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "${widget.km.toString()} km",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.description,
                  maxLines: 7,
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(height: 50.0),
                CustomButton(
                  text: 'View Needy Profile',
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewNeedyProfile(
                                  useruid: widget.activeuseruid,
                                )));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
