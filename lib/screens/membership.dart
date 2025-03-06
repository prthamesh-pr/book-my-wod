import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';

class MembershipPlanScreen extends StatefulWidget {
  @override
  _MembershipPlanScreenState createState() => _MembershipPlanScreenState();
}

class _MembershipPlanScreenState extends State<MembershipPlanScreen> {
  int selectedIndex = 0; // Default selected tab

  final List<String> tabs = ["Trail", "Monthly", "Yearly"];

  // Mock Data
  final List<Map<String, String>> mockData = [
    {"name": "Makenna Curtis", "price": "€ 80", "expireDate": "20 Jan 2024"},
    {"name": "Kierra Siphron", "price": "€ 80", "expireDate": "20 Jan 2024"},
    {"name": "Cheyenne Levin", "price": "€ 80", "expireDate": "20 Jan 2024"},
    {"name": "Jaylon Lubin", "price": "€ 80", "expireDate": "20 Jan 2024"},
    {"name": "Marcus Dorwart", "price": "€ 80", "expireDate": "20 Jan 2024"},
    {"name": "Roger Schleifer", "price": "€ 80", "expireDate": "20 Jan 2024"},
    {"name": "Omar Saris", "price": "€ 80", "expireDate": "20 Jan 2024"},
    {"name": "Hanna Donin", "price": "€ 80", "expireDate": "20 Jan 2024"},
    {"name": "Nolan Vaccaro", "price": "€ 80", "expireDate": "20 Jan 2024"},
    {"name": "Desirae Vaccaro", "price": "€ 80", "expireDate": "20 Jan 2024"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20), // Match the style in the image
          onPressed: () {
          },
        ),
        title: Text("Membership", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),


      body: Column(
        children: [
          // Tab Bar (Trail, Monthly, Yearly)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: tabs.asMap().entries.map((entry) {
                int idx = entry.key;
                String name = entry.value;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = idx;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selectedIndex == idx ? Colors.blue : Colors.white60,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 40,
                        height: 2,
                        color: selectedIndex == idx ? Colors.blue : Colors.transparent,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Membership Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 50,
                  headingRowColor: MaterialStateColor.resolveWith((states) => customGrey),
                  dataRowColor: MaterialStateColor.resolveWith((states) => Colors.black),
                  border: TableBorder.all(color: customWhite, width: 1),
                  columns: [
                    DataColumn(
                        label: Text("Member Name", style: headerStyle)),
                    DataColumn(
                        label: Text("Plan Price", style: headerStyle)),
                    DataColumn(
                        label: Text("Expire Date", style: headerStyle)),
                  ],
                  rows: mockData.map((plan) {
                    return DataRow(


                        cells: [
                      DataCell(Text(plan["name"]!, style: contentStyle)),
                      DataCell(Text(plan["price"]!, style: contentStyle)),
                      DataCell(Text(plan["expireDate"]!, style: boldStyle)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),

          // Bottom Indicator
          Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}

// Text Styles
final TextStyle headerStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
final TextStyle contentStyle = TextStyle(fontSize: 14, color: Colors.white70);
final TextStyle boldStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
