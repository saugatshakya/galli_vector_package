import 'dart:math';

import 'package:flutter/material.dart';
import 'package:galli_vector_package/galli_vector_package.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> getLocation() async {
    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.denied ||
        permissionStatus == LocationPermission.deniedForever) {
      permissionStatus = await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
              child: FutureBuilder(
                  future: getLocation(),
                  builder: (context, snap) {
                    return GalliMap(
                      size: (
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height
                      ),
                      showCurrentLocation: false,
                      authToken: "349ebf7c-9980-483d-8b16-6b193617ed52",
                    );
                  }))),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // GalliMapController? controller;

  @override
  void initState() {
    super.initState();
    // controller = GalliController(
    //   authKey: AppUrls.galliMapsToken,
    //   zoom: 17,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GalliMap(
                  size: (width: 300, height: 300),
                  authToken: "token",
                  initialCameraPostion: CameraPosition(
                    target: LatLng(27.15136361613, 85.136136136151),
                  ),
                  // showSearchWidget: false,
                  // showThree60Widget: false,
                  showCurrentLocation: true,
                  showCurrentLocationButton: false,
                  showCompass: true,
                  compassPosition: (
                    offset: const Point(16, 16),
                    position: CompassViewPosition.topRight
                  ),
                  onMapCreated: (controller) async {
                    // controller.addListener(() {
                    //   controller.cameraPosition!.target;
                    // });
                    // controller.addGalliMarker(
                    //   GalliMarkerOptions(
                    //     geometry: LatLng(
                    //         orderProvider.orderPickedDetails!.userInfo.latitude,
                    //         orderProvider
                    //             .orderPickedDetails!.userInfo.longitude),
                    //   ),
                    // );
                    // controller.addGalliMarker(
                    //   GalliMarkerOptions(
                    //     geometry: orderProvider
                    //         .orderPickedDetails!.route.latLngs.last,
                    //     iconColor: "#FF0000",
                    //   ),
                    // );
                    // setState(() {});
                  },
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.all(16.0),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.5),
              //         spreadRadius: 2,
              //         blurRadius: 5,
              //         offset: const Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Order ID: ${orderProvider.orderPickedDetails!.id}',
              //             style:
              //                 Theme.of(context).textTheme.titleLarge?.copyWith(
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //           ),
              //           if (orderProvider
              //               .orderPickedDetails!.userInfo.homeImage.isNotEmpty)
              //             TextButton(
              //               onPressed: () {
              //                 final imageUrl = AppUrls.homeImageUrl.replaceAll(
              //                     "id",
              //                     orderProvider.orderPickedDetails!.id
              //                         .toString());
              //                 navigate(
              //                   context,
              //                   route: NavigationConstants.viewImageRoute,
              //                   extra: imageUrl,
              //                 );
              //               },
              //               child: Text(
              //                 'View Image',
              //                 style: Theme.of(context)
              //                     .textTheme
              //                     .bodyMedium
              //                     ?.copyWith(
              //                       fontWeight: FontWeight.bold,
              //                       decoration: TextDecoration.underline,
              //                     ),
              //               ),
              //             ),
              //         ],
              //       ),
              //       SizedBox(height: 8.h),
              //       ListTile(
              //         contentPadding: EdgeInsets.zero,
              //         title: Text(
              //           'Name: ${orderProvider.orderPickedDetails!.customer.name}',
              //         ),
              //         subtitle: Text(
              //           'Address: ${orderProvider.orderPickedDetails!.userInfo.address}',
              //         ),
              //         trailing: GestureDetector(
              //           onTap: () async {
              //             final phone =
              //                 orderProvider.orderPickedDetails!.customer.phone;
              //             callNumber(phone);
              //           },
              //           child: const CircleAvatar(
              //             backgroundColor: AppColors.primaryColor,
              //             child: Icon(
              //               Icons.call,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(height: 16.h),
              //       Consumer<OrderProvider>(builder: (_, provider, __) {
              //         return GeneralElevatedButton(
              //           title: "Reached Location",
              //           onPressed: () async {
              //             // TODO: If image is not clicked, navigate to image click screen
              //             // Else navigate to payment confirm screen

              //             print(orderProvider.orderPickedDetails!.userInfo
              //                     .homeImage.isEmpty &&
              //                 !provider.hasUploadedHomeImage);

              //             if (orderProvider.orderPickedDetails!.userInfo
              //                     .homeImage.isEmpty &&
              //                 !provider.hasUploadedHomeImage) {
              //               XFile? pickedFile = await ImagePicker().pickImage(
              //                 source: ImageSource.camera,
              //               );
              //               final imageFile = File(pickedFile?.path ?? "");
              //               showLoading(context);
              //               await provider.uploadHomeImage(imageFile);
              //               removeLoading(context);
              //               navigate(context,
              //                   route: NavigationConstants.orderPaymentRoute);
              //             } else {
              //               navigate(context,
              //                   route: NavigationConstants.orderPaymentRoute);
              //             }
              //           },
              //         );
              //       })
              //     ],
              //   ),
              // ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 8,
            left: 16,
            child: InkWell(
              onTap: () {},
              child: const CircleAvatar(
                backgroundColor: Color(
                  0xffEEEEEE,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
