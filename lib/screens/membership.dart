import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/database/models/membership_model.dart';

class MembershipPlanScreen extends StatefulWidget {
  @override
  _MembershipPlanScreenState createState() => _MembershipPlanScreenState();
}

class _MembershipPlanScreenState extends State<MembershipPlanScreen> {
  late Future<List<MembershipPlan>> _membershipPlans;
  int selectedIndex = 0; // Default: "Trail" tab

  @override
  void initState() {
    super.initState();
    _membershipPlans = fetchMembershipPlans();
  }

  Future<List<MembershipPlan>> fetchMembershipPlans() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('membershipplan').select();
    print("Supabase Response: $response"); // Debugging output

    if (response.isEmpty) {
      print("No membership plans found in database.");
      return [];
    }
    return response.map((json) => MembershipPlan.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: Text("Membership"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Bar (Trail, Monthly, Yearly)
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["Trail", "Monthly", "Yearly"].asMap().entries.map((entry) {
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
                      color: selectedIndex == idx ? Colors.blue : Colors.white60,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Membership Table
          Expanded(
            child: FutureBuilder<List<MembershipPlan>>(
              future: _membershipPlans,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading membership plans", style: TextStyle(color: Colors.white)));
                }

                final plans = snapshot.data ?? [];
                if (plans.isEmpty) {
                  return Center(child: Text("No membership plans available", style: TextStyle(color: Colors.white)));
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Table Headers
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        color: Colors.blueGrey.shade900,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Member Name", style: headerStyle),
                            Text("Plan Price", style: headerStyle),
                            Text("Expire Date", style: headerStyle),
                          ],
                        ),
                      ),

                      // Table Content
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: plans.length,
                        itemBuilder: (context, index) {
                          final plan = plans[index];
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(plan.details, style: contentStyle),
                                Text("€ ${plan.price}", style: contentStyle),
                                Text("20 Jan 2024", style: contentStyle), // Dummy Expiry Date
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Indicator
          Container(
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
