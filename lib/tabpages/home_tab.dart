import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:omoda/views/menupages/settings.dart';
import '../controller/mapcon.dart';
import '../utils/app_colors.dart';
import '../views/menupages/invites.dart';
import '../views/menupages/payment.dart';
import '../views/menupages/promo_codes.dart';
import '../views/menupages/ride_history.dart';
import '../views/menupages/support.dart';
import '../widgets/text_widget.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});


  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();

  List<LatLng> routePoints = [];
  final LatLng startPoint = LatLng(8.5962,123.3627);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(userName: "Harold Andrei Ruiz", userImage: null), // Assign
      appBar: AppBar(

        title: Text(
          "Home",
          style: GoogleFonts.poppins(),

        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the drawer
            },
          ),
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(8.56469, 123.3336),
          initialZoom: 14,
        ),
        children: [
          Stack(
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
              // These widgets should be on top of the map, hence in a stack
              buildProfileTile(name: 'Harold Ruiz', imageUrl: null),
              buildTextField(),
              buildBottomSheet(),
              buildTextFieldForSource(),
            ],
          ),
        ],
      ),
    );
  }


  Widget buildProfileTile({required String? name, required String? imageUrl}) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: name == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        width: Get.width,
        height: Get.width * 0.5,
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(color: Colors.white70),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: imageUrl == null
                    ? const DecorationImage(
                  image: AssetImage('assets/person.png'),
                  fit: BoxFit.fill,
                )
                    : DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Good Morning, ',
                        style:
                        TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      TextSpan(
                        text: name,
                        style: const TextStyle(
                          color: Color(0xFF3C3D37),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Where are you going?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField() {
    return Positioned(
      top: 170,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 4,
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: destinationController,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Search for a destination',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon:
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                if (destinationController.text.isNotEmpty) {
                  await fetchAndSetRoute(destinationController.text);
                }
              },
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Future<void> searchAndShowRoute(String destination) async {
    try {
      // Geocode the destination to get latitude and longitude
      List<Location> locations = await locationFromAddress(destination);

      if (locations.isNotEmpty) {
        double destinationLat = locations.first.latitude;
        double destinationLng = locations.first.longitude;

        // Call your route fetching method here (e.g., using a routing API)
        List<LatLng> route = await fetchRouteToDestination(destinationLat, destinationLng);

        // Update the map with the new polyline
        setState(() {
          routePoints = route;
        });
      } else {
        print('No location found for $destination');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  Future<List<LatLng>> fetchRouteToDestination(double destinationLat, double destinationLng) async {
    // Implement your routing logic here to fetch the route.
    // For example, you can call an API like OpenRouteService or Google Directions API.

    // Dummy route for now:
    return [
      LatLng(8.5896, 123.3336),  // Start point (your current location)
      LatLng(destinationLat, destinationLng), // Destination
    ];
  }

  Widget buildTextFieldForSource() {
    return Positioned(
      top: 230,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 4,
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: sourceController,
          readOnly: true,
          onTap: () async {
            buildSourceSheet(sourceController: sourceController);
          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'From:',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.search),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width * 0.8,
        height: 25,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 4,
              blurRadius: 10,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
        ),
        child: Center(
          child: Container(
            width: Get.width * 0.6,
            height: 4,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }

  buildDrawer({String? userName, String? userImage}) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:
        [

          // Drawer Header

          UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: userImage == null
                    ? const DecorationImage(
                  image: AssetImage('assets/person.png'),
                  fit: BoxFit.fill,
                )
                    : DecorationImage(
                  image: NetworkImage(userImage),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            accountName: Text(userName ?? "Harold Andrei Ruiz"),
            accountEmail: Text(userImage ?? "haroldandrei@gmail.com"),
            decoration: BoxDecoration(
              color: Color(0xFF181C14),
            ),
          ),




          // Drawer Title
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Menu", // Title text
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),

          // Drawer Items
          ListTile(
            title: const Text('Payment History'),
            onTap: () => Get.to(() => const PaymentScreen()),
          ),
          ListTile(
            title: const Text('Ride History'),
            onTap: ()  => Get.to(() => const RideHistoryScreen()),
          ),
          ListTile(
            title: const Text('Invite Friends'),
            onTap: ()  => Get.to(() => const InviteFriendsScreen()),
          ),
          ListTile(
            title: const Text('Promo Codes'),
            onTap: ()  => Get.to(() => const PromoCodePage()),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: ()  => Get.to(() => const SettingsPage()),
          ),
          ListTile(
            title: const Text('Support'),
            onTap: ()  => Get.to(() => const SupportPage()),
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }


  void buildSourceSheet({
    required TextEditingController sourceController,
  }) {

    Get.bottomSheet(
      Container(
        width: Get.width,
        height: Get.height * 0.5,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Select Your Location",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Home Address",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.back(); // Close the bottom sheet
                sourceController.text = "Home Address"; // Set the selected value
              },
              child: _buildAddressContainer("Home Address"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Current Address",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.back();
                sourceController.text = "Current Address";
              },
              child: _buildAddressContainer("Business Address"),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.back();
                sourceController.text = "Search for Address";
              },
              child: _buildAddressContainer("Search for Address"),
            ),
          ],
        ),
      ),
    );
  }

  buildRideConfirmationSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          textWidget(
              text: 'Select an option:',
              fontSize: 18,
              fontWeight: FontWeight.bold),
          const SizedBox(
            height: 20,
          ),
          buildDriversList(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: buildPaymentCardWidget()),
                MaterialButton(
                  onPressed: () {},
                  child: textWidget(
                    text: 'Confirm',
                    color: Colors.white,
                  ),
                  color: AppColors.greenColor,
                  shape: StadiumBorder(),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  buildPaymentCardWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/visa.png',
            width: 40,
          ),
          SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue;
              });
            },
            items: ['Visa', 'MasterCard', 'Amex']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: textWidget(text: value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  int selectedRide = 0;

  get dropdownValue => null;


  buildDriversList() {
    return Container(
      height: 90,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(selectedRide == i),
            );
          },
          itemCount: 3,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }


  buildDriverCard(bool selected) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 85,
      width: 165,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? Color(0xff2DBB54).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? Color(0xff2DBB54) : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: 'Standard',
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                textWidget(
                    text: '\$9.90',
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textWidget(
                    text: '3 MIN',
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ],
            ),
          ),
          Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              child: Image.asset('assets/Mask Group 2.png'))
        ],
      ),
    );
  }



  Widget _buildAddressContainer(String label) {
    return Container(
      width: Get.width,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 4,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }


  /// Fetch route and set polyline points
  Future<void> fetchAndSetRoute(String destination) async {
    try {
      // Geocode destination to get its coordinates
      final destinationCoords = await geocodeDestination(destination);
      if (destinationCoords == null) {
        throw Exception("Unable to find destination coordinates.");
      }

      // Fetch the route between the start point and destination
      final route = await fetchRoute(startPoint, destinationCoords);
      setState(() {
        routePoints = route;
      });
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  /// Geocode destination address using OpenRouteService
  Future<LatLng?> geocodeDestination(String address) async {
    const String apiKey = '5b3ce3597851110001cf624806cb530231bd49338fd6a9a3cd129e38'; // Replace with your API key
    final url =
        'https://api.openrouteservice.org/geocode/search?api_key=$apiKey&text=$address';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['features'].isNotEmpty) {
        final coords = data['features'][0]['geometry']['coordinates'];
        return LatLng(coords[1], coords[0]);
      }
    }
    return null;
  }

  /// Fetch route between start and destination using OpenRouteService
  Future<List<LatLng>> fetchRoute(LatLng start, LatLng end) async {
    const String apiKey = '5b3ce3597851110001cf624806cb530231bd49338fd6a9a3cd129e38'; // Replace with your API key
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'];
      return coordinates
          .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
          .toList();
    } else {
      throw Exception("Failed to fetch route.");
    }
  }

}
