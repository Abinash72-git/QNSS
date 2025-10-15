import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soapy/pages/appdrawer.dart';
import 'package:soapy/pages/notificationpage.dart';
import 'package:soapy/pages/userprofilepage.dart';
import 'package:soapy/provider/UserProvider.dart';
import 'package:soapy/util/appconstant.dart';
import 'package:soapy/util/bottomNav.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/dottedLine.dart';
import 'package:soapy/util/servicecard.dart';
import 'package:soapy/util/style.dart';
import 'package:intl/intl.dart';

// Static list to track completed companies
final List<String> _completedCompanies = [];

class Homepage extends StatefulWidget {
  final String? completedCompany;
  const Homepage({super.key, this.completedCompany});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  UserProvider get provider => context.read<UserProvider>();
  int _selectedIndex = -1;

  late List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  // Date navigation
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    getJobdetails();

    _applyCompletedCompanies();

    if (widget.completedCompany != null &&
        !_completedCompanies.contains(widget.completedCompany)) {
      _completedCompanies.add(widget.completedCompany!);
      updateCompletedStatus(widget.completedCompany!);
    }
  }

  // Navigate to previous day
  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    getJobdetails();
  }

  // Navigate to next day
  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    getJobdetails();
  }

  // Format date for display
  String _getFormattedDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    if (selected == today) {
      return "Today Job List";
    } else if (selected == today.subtract(const Duration(days: 1))) {
      return "Yesterday Job List";
    } else if (selected == today.add(const Duration(days: 1))) {
      return "Tomorrow Job List";
    } else {
      return DateFormat('dd MMM yyyy').format(_selectedDate);
    }
  }

  // Future<void> getJobdetails() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? mobileNumber = prefs.getString(AppConstants.USERMOBILE);

  //   try {
  //     // Format date for API call
  //     String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

  //     // Fetch employee details from API with date parameter
  //     final response = await provider.fetchEmployeeDetails(
  //       mobileNumber.toString(),
  //       // date: formattedDate, // Pass the selected date to API
  //     );

  //     if (response != null &&
  //         response.success &&
  //         response.data.customers.isNotEmpty) {
  //       List<Map<String, dynamic>> apiItems = [];

  //       for (var customer in response.data.customers) {
  //         final imageIndex = (customer.name.hashCode % 4) + 1;
  //         final distanceValue = (0.5 + (customer.name.hashCode % 45) / 10)
  //             .toStringAsFixed(1);

  //         final addressHash = customer.address.hashCode;
  //         final latOffset = (addressHash % 100) / 1000.0;
  //         final lngOffset = ((addressHash ~/ 100) % 100) / 1000.0;
  //         // final baseLat = 13.0827;
  //         // final baseLng = 80.2707;
  //         final baseLat = 1.043772525862291;
  //         final baseLng = 103.91073918650804;

  //         apiItems.add({
  //           "image": "assets/$imageIndex.jpg",
  //           "company": customer.selectedProperty.factoryName,
  //           "subtitle": customer.serviceType.name,
  //           "location": customer.address,
  //           'lat': baseLat + latOffset,
  //           'lng': baseLng + lngOffset,
  //           "timeRange":
  //               "${customer.shiftName.startTime} to ${customer.shiftName.endTime}",
  //           "distance": "$distanceValue km",
  //           "completed": false,
  //         });
  //       }

  //       setState(() {
  //         items = apiItems;
  //         isLoading = false;
  //       });
  //     } else {
  //       // Fallback to sample data based on date
  //       setState(() {
  //         items = _getSampleDataForDate(_selectedDate);
  //         isLoading = false;
  //       });

  //       Fluttertoast.showToast(
  //         msg: "No jobs scheduled for this date",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.orange,
  //         textColor: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     print("Error loading data: $e");
  //     setState(() {
  //       items = _getSampleDataForDate(_selectedDate);
  //       isLoading = false;
  //     });

  //     Fluttertoast.showToast(
  //       msg: "Error loading data",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   } finally {
  //     _applyCompletedCompanies();

  //     if (widget.completedCompany != null &&
  //         !_completedCompanies.contains(widget.completedCompany)) {
  //       _completedCompanies.add(widget.completedCompany!);
  //       updateCompletedStatus(widget.completedCompany!);
  //     }

  //     if (mounted) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }

Future<void> getJobdetails() async {
  setState(() {
    isLoading = true;
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? mobileNumber = prefs.getString(AppConstants.USERMOBILE);

  try {
    // Format date for API call
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    // Fetch employee details from API with date parameter
    final response = await provider.fetchEmployeeDetails(
      mobileNumber.toString(),
      // date: formattedDate, // Pass the selected date to API
    );

    if (response != null &&
        response.success &&
        response.data.customers.isNotEmpty) {
      List<Map<String, dynamic>> apiItems = [];

      // Base coordinates that you want to use
      final baseLat = 1.043772525862291;
      final baseLng = 103.91073918650804;
      
      // Define small, controlled offsets for nearby points
      final List<Map<String, double>> offsets = [
        {'lat': 0.000, 'lng': 0.000},      // Same location
        {'lat': 0.002, 'lng': 0.003},      // ~300m north-east
        {'lat': -0.001, 'lng': 0.004},     // ~450m south-east
        {'lat': -0.003, 'lng': -0.002},    // ~400m south-west
        {'lat': 0.004, 'lng': -0.001},     // ~450m north-west
        {'lat': 0.001, 'lng': 0.005},      // ~550m east
        {'lat': -0.004, 'lng': 0.001},     // ~450m south
        {'lat': 0.000, 'lng': -0.004},     // ~400m west
        {'lat': 0.005, 'lng': 0.000},      // ~500m north
        {'lat': 0.003, 'lng': 0.004},      // ~500m north-east
      ];

      for (var i = 0; i < response.data.customers.length; i++) {
        var customer = response.data.customers[i];
        final imageIndex = (customer.name.hashCode % 4) + 1;
        final distanceValue = (0.5 + (customer.name.hashCode % 45) / 10)
            .toStringAsFixed(1);
            
        // Get consistent offset based on index
        final offsetIndex = i % offsets.length;
        final offset = offsets[offsetIndex];

        apiItems.add({
          "image": "assets/$imageIndex.jpg",
          "company": customer.selectedProperty.factoryName,
          "subtitle": customer.serviceType.name,
          "location": customer.address,
          'lat': baseLat + offset['lat']!,  // Base coordinates + small offset
          'lng': baseLng + offset['lng']!,  // Base coordinates + small offset
          "timeRange":
              "${customer.shiftName.startTime} to ${customer.shiftName.endTime}",
          "distance": "$distanceValue km",
          "completed": false,
        });
      }

      setState(() {
        items = apiItems;
        isLoading = false;
      });
    } else {
      // Fallback to sample data based on date
      setState(() {
        items = _getSampleDataForDate(_selectedDate);
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: "No jobs scheduled for this date",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    }
  } catch (e) {
    print("Error loading data: $e");
    setState(() {
      items = _getSampleDataForDate(_selectedDate);
      isLoading = false;
    });

    Fluttertoast.showToast(
      msg: "Error loading data",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  } finally {
    _applyCompletedCompanies();

    if (widget.completedCompany != null &&
        !_completedCompanies.contains(widget.completedCompany)) {
      _completedCompanies.add(widget.completedCompany!);
      updateCompletedStatus(widget.completedCompany!);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}


  // Generate sample data based on date (for demo purposes)
  List<Map<String, dynamic>> _getSampleDataForDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    // Return different data based on the day
    if (selected == today) {
      return [
        {
          "image": "assets/1.jpg",
          "company": "PT Yokohama Industrial Products",
          "subtitle": "Quick wash and fold",
          "location": 'Ramar Koil St, Chennai, Nandambakkam, Tamil Nadu 600089',
          'lat': 13.0827,
          'lng': 80.2707,
          "timeRange": "7.00AM to 8.00AM",
          "distance": "0.5 km",
          "completed": false,
        },
        {
          "image": "assets/2.jpg",
          "company": "PT Daikin Industries",
          "subtitle": "Dry cleaning",
          "location": 'Anna Nagar, Chennai, Tamil Nadu 600040',
          'lat': 13.0850,
          'lng': 80.2101,
          "timeRange": "8.30AM to 9.30AM",
          "distance": "1.2 km",
          "completed": false,
        },
      ];
    } else if (selected.isBefore(today)) {
      // Past dates - show completed jobs
      return [
        {
          "image": "assets/3.jpg",
          "company": "EKK Eagle Industry",
          "subtitle": "Premium laundry",
          "location": 'T. Nagar, Chennai, Tamil Nadu 600017',
          'lat': 13.0418,
          'lng': 80.2341,
          "timeRange": "10.00AM to 11.00AM",
          "distance": "2.8 km",
          "completed": true,
        },
      ];
    } else {
      // Future dates - show scheduled jobs
      return [
        {
          "image": "assets/4.jpg",
          "company": "PT ABB Sakthi Industry",
          "subtitle": "Steam ironing",
          "location": 'ECR, Chennai, Tamil Nadu 600119',
          'lat': 12.8847,
          'lng': 80.2378,
          "timeRange": "11.30AM to 12.30PM",
          "distance": "3.1 km",
          "completed": false,
        },
        {
          "image": "assets/1.jpg",
          "company": "Nanaking Industry",
          "subtitle": "Express delivery",
          "location": 'Adyar, Chennai, Tamil Nadu 600020',
          'lat': 13.0067,
          'lng': 80.2206,
          "timeRange": "1.00PM to 2.00PM",
          "distance": "4.5 km",
          "completed": false,
        },
      ];
    }
  }

  void _applyCompletedCompanies() {
    if (_completedCompanies.isEmpty) return;

    for (var item in items) {
      if (_completedCompanies.contains(item["company"])) {
        item["completed"] = true;
      }
    }
  }

  void updateCompletedStatus(String completedCompany) {
    for (int i = 0; i < items.length; i++) {
      if (items[i]["company"] == completedCompany) {
        setState(() {
          items[i]["completed"] = true;
          items[i]["completedAt"] = DateTime.now().toString();

          if (!_completedCompanies.contains(completedCompany)) {
            _completedCompanies.add(completedCompany);
          }
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: false,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColor.blackColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Image.asset(
            "assets/icons/Qnss1.png",
            fit: BoxFit.contain,
            width: size.width * 0.35,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            width: size.width * 0.1,
            height: size.height * 0.045,
            decoration: BoxDecoration(
              color: AppColor.loginText,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              iconSize: 22,
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.notifications, color: AppColor.blackColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: size.width * 0.1,
            height: size.height * 0.045,
            decoration: BoxDecoration(
              color: AppColor.loginText,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              iconSize: 22,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.account_circle,
                color: AppColor.blackColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Qnss-bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            DottedLine(
              height: 1,
              color: Colors.white,
              dotRadius: 1,
              spacing: 2,
            ),

            // Date Navigation Header with Arrows
            Container(
              width: size.width * 0.8,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColor.titleButton,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Day Arrow
                  GestureDetector(
                    onTap: _goToPreviousDay,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Date Text
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            _getFormattedDate(),
                            style: Styles.textStyleSmall3(
                              context,
                              color: AppColor.whiteColor,
                            ),
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('EEEE').format(_selectedDate),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            textScaler: const TextScaler.linear(1),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Next Day Arrow
                  GestureDetector(
                    onTap: _goToNextDay,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.whiteColor,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        // Show toast for refresh
                        // Fluttertoast.showToast(
                        //   msg: "Refreshing job list...",
                        //   toastLength: Toast.LENGTH_SHORT,
                        //   gravity: ToastGravity.CENTER,
                        //   backgroundColor: Colors.blue,
                        //   textColor: Colors.white,
                        // );

                        // Refresh the job details
                        await getJobdetails();

                        // Show success toast
                        Fluttertoast.showToast(
                          msg: "Job list refreshed!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                      },
                      color: AppColor.loginButton,
                      backgroundColor: Colors.white,
                      child: items.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          size: 64,
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No jobs scheduled for this date',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Pull down to refresh',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(10),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return ServiceCard(
                                  imagePath: item["image"]!,
                                  company: item["company"]!,
                                  subtitle: item["subtitle"]!,
                                  location: item["location"],
                                  timeRange: item["timeRange"],
                                  distance: item["distance"],
                                  lat: item["lat"],
                                  lng: item["lng"],
                                  isCompleted: item["completed"] == true,
                                  completedAt: item["completedAt"],
                                  onStartPressed: () {
                                    print(
                                      'Start pressed for: ${item["company"]}',
                                    );
                                  },
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            print("History clicked");
          } else if (index == 1) {
            print("Support clicked");
          } else if (index == 2) {
            print("Location clicked");
          }
          print("Bottom nav tapped: $index");
        },
        items: items,
      ),
    );
  }
}
