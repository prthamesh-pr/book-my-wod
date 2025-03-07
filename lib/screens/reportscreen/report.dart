import 'package:fl_chart/fl_chart.dart'
    show
        BarChart,
        BarChartData,
        BarChartGroupData,
        BarChartRodData,
        FlBorderData,
        FlGridData,
        FlTitlesData;
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReportScreen(),
  ));
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int selectedIndex = 0;
  final List<String> tabs = ["All (950)", "Monthly (700)", "Yearly (200)", "Cancel (50)"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0D1B2A),
        title:
            Text("Report", style: TextStyle(color: Colors.white, fontSize: 18)),
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Earning reports'),
            SizedBox(height: 16),

            _buildCard(
              title: "Total Earning",
              amount: "€ 500 K",
              percentage: "1.6%",
              chartData: [5, 6, 7, 8, 7, 9],
            ),
            SizedBox(height: 16),
            EarningPeriodWidget(),
            SizedBox(height: 16),

            Text('Earning reports'),
            // _buildEarningPeriodCard(),
            SizedBox(height: 16),
            _buildCard(
              title: "Total Members",
              amount: "950",
              percentage: "1.6%",
              chartData: [3, 4, 5, 6, 5, 7],
            ),
            SizedBox(height: 16),
            _buildTabBar(),
            SizedBox(height: 10),
            Expanded(child: _buildUserList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required String amount,
      required String percentage,
      required List<int> chartData}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // First column
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 8),
                Container(
                  height: 1,
                  width: 130,
                  color: Color(0xFF21374D), // Same color as the right container
                ),
                SizedBox(height: 8),
                Text(amount,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("All time update",
                    style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          // Second column (50% width, styled)

          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF21374D),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("↑ $percentage",
                      style:
                          TextStyle(color: Colors.greenAccent, fontSize: 14)),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: BarChart(BarChartData(
                      barGroups: chartData
                          .asMap()
                          .entries
                          .map((e) => BarChartGroupData(x: e.key, barRods: [
                                BarChartRodData(
                                    toY: e.value.toDouble(),
                                    color: Colors.blueAccent)
                              ]))
                          .toList(),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(show: false),
                      gridData: FlGridData(show: false),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningPeriodCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1B263B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Earning Period",
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              Icon(Icons.calendar_today, color: Colors.white54, size: 16),
            ],
          ),
          SizedBox(height: 10),
          Text("16 Jan - 16 Feb 2025",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("One Month Earning: € 100 K",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 5),
          Text("One Month Earning: € 100 K",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

Widget _buildTabBar() {
    return Container(
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
                    fontSize: 14,
                    fontWeight: selectedIndex == idx ? FontWeight.bold : FontWeight.normal,
                    color: selectedIndex == idx ? Colors.blueAccent : Colors.white54,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8),
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
                    left: (MediaQuery.of(context).size.width - 52) / 
                          tabs.length * 
                          selectedIndex +
                          ((MediaQuery.of(context).size.width - 52) / 
                          tabs.length - 60) / 2,
                    child: Container(
                      width: 60,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildUserList() {
    List<String> users = [
      "Makenna Curtis",
      "Kierra Siphron",
      "Cheyenne Levin",
      "Jaylan Lubin",
      "Marcus Dowart",
      "Roger Schleifer",
      "Omar Saris",
      "Hanna Donin",
      "Nolan Vaccaro",
      "Gustavo Bootsh",
      "Nolan George",
      "Desirae Vaccaro"
    ];
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index],
              style: TextStyle(color: Colors.white, fontSize: 14)),
          trailing: Icon(Icons.message, color: Colors.white54, size: 18),
        );
      },
    ); 
  }
}

class EarningPeriodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF152238), // Dark background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Earning Period",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),

          // Date Range with Icon
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Color(0xFF1C2B44), // Slightly lighter dark shade
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "16 Jan - 16 Feb 2025",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Image(
                  image: AssetImage('assets/buttons/calendar-03.png'),
                  width: 18,
                  height: 18,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Earnings Section
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF21374D), // Requested color #21374D
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: Column(
              children: [
                _buildEarningsRow("One Month Earning:", "€ 100 K"),
                Divider(color: Colors.white24, thickness: 1), // Thin line
                _buildEarningsRow("One Month Earning:", "€ 100 K"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsRow(String label, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
          Text(
            amount,
            style: TextStyle(color: Colors.blueAccent, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
