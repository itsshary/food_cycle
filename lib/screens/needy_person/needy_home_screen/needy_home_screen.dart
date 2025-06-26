// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:food_cycle/models/donation_model.dart';
import 'package:food_cycle/routes/routes_name.dart';
import 'package:food_cycle/screens/needy_person/complete_donation/widget/shimmereeffectcomplete.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/widgets/appbar_widget.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/widgets/badge_widget.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/widgets/card_donation_widget.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/widgets/padding_widget.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/widgets/searchfield.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/widgets/singlechildscrollview_product.dart';
import 'package:food_cycle/screens/needy_person/needy_home_screen/widgets/slider_widget.dart';
import 'package:food_cycle/services/firestore_service.dart';
import 'package:food_cycle/utils/color_resources.dart';
import 'package:food_cycle/notification/notification_service/notification_service_screen_logic.dart';
import 'package:food_cycle/notification/server_key/server_key.dart';
import 'package:food_cycle/utils/dimensions.dart';

class NeedyHomeScreen extends StatefulWidget {
  const NeedyHomeScreen({super.key});

  @override
  State<NeedyHomeScreen> createState() => _NeedyHomeScreenState();
}

class _NeedyHomeScreenState extends State<NeedyHomeScreen> {
  String selectedCategory = "";
  final TextEditingController searchController = TextEditingController();
  String searchText = "";
  NotificationServiceScreenLogic notificationrequest =
      NotificationServiceScreenLogic();

  ServerKey serverKey = ServerKey();
  @override
  void initState() {
    super.initState();
    notificationrequest.requestNotificationPermission();
    notificationrequest.getDeviceToken();
    notificationrequest.firebaseInit(context);
    notificationrequest.setupInteractMessage(context);
    serverKey.getServerKeyToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      appBar: AppBar(
          backgroundColor: ColorResources.primaryColor,
          automaticallyImplyLeading: false,
          actions: const [
            BadgeWidget(),
          ],
          title: const AppbarWidget()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: SearchfieldWidget(
                        searchController: searchController,
                        searchText: searchText,
                      )),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.settings_input_component_outlined,
                          color: ColorResources.primaryColor),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routesname.filterSearchScreen);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SliderWidget(),
            const PaddingWidget(title: 'Food Category'),
            SinglechildscrollviewProduct(
              selectedCategory: selectedCategory,
            ),
            const PaddingWidget(title: "All Donation's"),
            StreamBuilder<List<DonationModel>>(
              stream: FirestoreService().getDonations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Shimmereeffectcomplete();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No donations available."));
                }

                final filteredDonations = snapshot.data!
                    .where((donation) => donation.foodItem
                        .toLowerCase()
                        .contains(searchText.toLowerCase()))
                    .toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeExtraSmall5),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: filteredDonations.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<Map<String, dynamic>?>(
                          future: FirestoreService()
                              .getUserById(filteredDonations[index].uid),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Shimmereeffectcomplete();
                            }
                            return CardDonationWidget(
                              donation: filteredDonations[index],
                              userData: userSnapshot.data,
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
