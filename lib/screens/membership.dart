import 'package:bookmywod_admin/shared/constants/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MembershipPlanScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

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
      // Remove the backgroundColor property
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {},
        ),
        title: Text("Membership", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF04101C), // Match with gradient start color
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF04101C), Color(0xFF152536)],
          ),
        ),
        child: Column(
          children: [
            // Tab Bar (Trail, Monthly, Yearly)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Row(
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
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedIndex == idx
                                ? Colors.blue
                                : Colors.white60,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: double.infinity,
                      height: 2,
                      color: Color(0xFF334658),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            left: (MediaQuery.of(context).size.width - 30) /
                                    tabs.length *
                                    selectedIndex +
                                ((MediaQuery.of(context).size.width - 30) /
                                            tabs.length - 30)/2,
                            child: Container(
                              width: 70,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Membership Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF334658), width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: DataTable(
                        columnSpacing: 50,
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => customGrey),
                        dataRowColor: MaterialStateColor.resolveWith(
                            (states) => Color(0xFF1A2D40)),
                        border: TableBorder(
                          horizontalInside:
                              BorderSide(color: Color(0xFF334658), width: 1),
                          verticalInside:
                              BorderSide(color: Color(0xFF334658), width: 1),
                        ),
                        columns: [
                          DataColumn(
                              label: Text("Member Name", style: headerStyle)),
                          DataColumn(
                              label: Text("Plan Price", style: headerStyle)),
                          DataColumn(
                              label: Text("Expire Date", style: headerStyle)),
                        ],
                        rows: mockData.map((plan) {
                          return DataRow(cells: [
                            DataCell(Text(plan["name"]!, style: contentStyle)),
                            DataCell(Text(plan["price"]!, style: contentStyle)),
                            DataCell(
                                Text(plan["expireDate"]!, style: boldStyle)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Bottom Indicator
            // Bottom Indicator
            Padding(
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  // Add your button action here
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                          'assets\buttons\Group 19.png'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.keyboard_arrow_down,
                        color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Text Styles
final TextStyle headerStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
final TextStyle contentStyle = TextStyle(fontSize: 14, color: Colors.white70);
final TextStyle boldStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
