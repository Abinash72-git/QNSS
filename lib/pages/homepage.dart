import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soapy/pages/appdrawer.dart';
import 'package:soapy/pages/notificationpage.dart';
import 'package:soapy/pages/userprofilepage.dart';
import 'package:soapy/util/bottomNav.dart';
import 'package:soapy/util/colors.dart';
import 'package:soapy/util/dottedLine.dart';
import 'package:soapy/util/servicecard.dart';
import 'package:soapy/util/style.dart';

// Static list to track completed companies
final List<String> _completedCompanies = [];

class Homepage extends StatefulWidget {
  final String? completedCompany;
  const Homepage({super.key, this.completedCompany});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = -1;

  final List<Map<String, dynamic>> items = [
    {
      "image": "assets/1.jpg",
      "company": "PT Yokohama Industrial Products",
      "subtitle": "Quick wash and fold",
      "location": 'Ramar Koil St, Chennai, Nandambakkam, Tamil Nadu 600089',
      'lat': 13.0827,
      'lng': 80.2707,
      "timeRange": "7.00AM to 8.00AM",
      "distance": "0.5 km",
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
    },
    {
      "image": "assets/3.jpg",
      "company": "EKK Eagle Industry",
      "subtitle": "Premium laundry",
      "location": 'T. Nagar, Chennai, Tamil Nadu 600017',
      'lat': 13.0418,
      'lng': 80.2341,
      "timeRange": "10.00AM to 11.00AM",
      "distance": "2.8 km",
    },
    {
      "image": "assets/4.jpg",
      "company": "PT ABB Sakthi Industry",
      "subtitle": "Steam ironing",
      "location": 'ECR, Chennai, Tamil Nadu 600119',
      'lat': 12.8847,
      'lng': 80.2378,
      "timeRange": "11.30AM to 12.30PM",
      "distance": "3.1 km",
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
    },
  ];

  @override
  void initState() {
    super.initState();

    // First apply all previously completed companies
    _applyCompletedCompanies();

    // Then check if we have a new completed company from navigation
    if (widget.completedCompany != null &&
        !_completedCompanies.contains(widget.completedCompany)) {
      _completedCompanies.add(widget.completedCompany!);
      updateCompletedStatus(widget.completedCompany!);
    }
  }

  // Apply all tracked completed companies to the items list
  void _applyCompletedCompanies() {
    if (_completedCompanies.isEmpty) return;

    setState(() {
      // Update all items that match any company in the completed list
      for (var item in items) {
        if (_completedCompanies.contains(item["company"])) {
          item["completed"] = true;
        }
      }
    });
  }

  void updateCompletedStatus(String completedCompany) {
    // Update the status in the items list
    for (int i = 0; i < items.length; i++) {
      if (items[i]["company"] == completedCompany) {
        setState(() {
          items[i]["completed"] = true;
          items[i]["completedAt"] = DateTime.now().toString();

          // Ensure it's in the static tracking list
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
      extendBody: false, // Don't extend body behind bottom nav
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
            Container(
              width: size.width * 0.45,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.titleButton,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'Today Job List',
                  style: Styles.textStyleSmall3(
                    context,
                    color: AppColor.whiteColor,
                  ),
                  textScaler: TextScaler.linear(1),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
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
                    onStartPressed: () {
                      print('Start pressed for: ${item["company"]}');
                    },
                  );
                },
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

          // Handle navigation for each index
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
