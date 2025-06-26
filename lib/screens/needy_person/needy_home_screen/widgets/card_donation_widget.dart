import 'package:flutter/material.dart';
import 'package:food_cycle/models/donation_model.dart';
import 'package:food_cycle/screens/needy_person/items_details_checking/items_details_checking.dart';
import 'package:food_cycle/utils/color_resources.dart';
import 'package:food_cycle/utils/dummy/dummy_data.dart';

class CardDonationWidget extends StatelessWidget {
  final DonationModel donation;
  final Map<String, dynamic>? userData;

  const CardDonationWidget(
      {super.key, required this.donation, required this.userData});

  @override
  Widget build(BuildContext context) {
    final String donatorName = userData != null
        ? "${userData!['firstName'] ?? ''} ${userData!['lastName'] ?? ''}"
            .trim()
        : "Unknown Donator";
    final String donatorImage = userData?['image'] ?? '';
    final Map<String, dynamic> location = userData?['location'] ?? {};
    final double latitude = location['latitude'] ?? 0.0;
    final double longitude = location['longitude'] ?? 0.0;

    return GestureDetector(
      onTap: () async {
        String address =
            await DummyData.getAddressFromLatLng(latitude, longitude);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(
              description: donation.description,
              donatername: donatorName,
              donationId: donation.donationId,
              endtime: donation.endTime,
              foodstatus: donation.foodType,
              images: donation.imageUrl,
              itemname: donation.foodItem,
              km: donation.distance,
              location: address,
              pickingtime: donation.startTime,
              quantity: donation.quantity,
            ),
          ),
        );
      },
      child: Card(
        color: ColorResources.primaryColorshades100,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  donation.imageUrl.isEmpty
                      ? 'https://via.placeholder.com/80'
                      : donation.imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(donation.foodItem,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text("Quantity: ${donation.quantity}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54)),
                    Text("Type: ${donation.foodType}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54)),
                    Text(
                        "Available: ${donation.startTime} - ${donation.endTime}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(donatorImage)),
                        const SizedBox(width: 8),
                        Text(donatorName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
