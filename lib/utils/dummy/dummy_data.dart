import 'package:food_cycle/resources/toast_ms/toast_msg.dart';
import 'package:geocoding/geocoding.dart';

class DummyData {
  static final List<Map<String, String>> foodCategories = [
    {
      'name': 'Chicken',
      'imageUrl':
          'https://images.pexels.com/photos/616354/pexels-photo-616354.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'name': 'Rice',
      'imageUrl':
          'https://images.pexels.com/photos/3727196/pexels-photo-3727196.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'name': 'Bread',
      'imageUrl':
          'https://images.pexels.com/photos/166021/pexels-photo-166021.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'name': 'Fruits',
      'imageUrl':
          'https://images.pexels.com/photos/1132047/pexels-photo-1132047.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
    {
      'name': 'Vegetables',
      'imageUrl':
          'https://images.pexels.com/photos/406152/pexels-photo-406152.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    },
  ];

  // for images
  static final List<String> carouselImages = [
    "https://quotefancy.com/media/wallpaper/3840x2160/7832376-Robin-Norwood-Quote-Hungry-people-make-poor-shoppers.jpg",
    "https://www.brainyquote.com/photos_tr/en/a/adlaistevensoni/137732/adlaistevensoni1.jpg",
    "https://quotefancy.com/media/wallpaper/3840x2160/7832376-Robin-Norwood-Quote-Hungry-people-make-poor-shoppers.jpg",
    "https://quotefancy.com/media/wallpaper/3840x2160/6417271-Lemony-Snicket-Quote-Hungry-people-should-be-fed-It-takes-some.jpg",
  ];

  // location conver screen
  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      ToastMsg().showToast(e.toString());
    }
    return "Address not found";
  }

  static final List<String> images = [
    "assets/images/kind.png",
    "assets/images/hands.png",
    "assets/images/box.png",
  ];

  static final List<String> taglines = [
    "Give a Little, Change a Lot.",
    "Every Act of Kindness Counts.",
    "Be the Hope Someone Needs Today.",
  ];
}
