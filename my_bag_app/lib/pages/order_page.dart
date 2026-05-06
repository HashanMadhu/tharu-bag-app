import 'package:flutter/material.dart'; // Flutter Material package එක import කිරීම
import 'package:url_launcher/url_launcher.dart'; // url_launcher package එක import කිරීම

// දෙවැනි පිටුව
// මුලින්ම StatefulWidget එක නිර්මාණය කරමු
class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _nameController = TextEditingController();

  // 1. පියවර: මෙන්න Logic එක තිබිය යුතු තැන (Variable & Function)
  String selectedBagType = 'School Bag';

  String getBagImage(String type) {
    switch (type) {
      case 'School Bag':
        return 'assets/school_bag.png';
      case 'Travel Bag':
        return 'assets/travel_bag.png';
      case 'Hand Bag':
        return 'assets/hand_bag.png';
      case 'Lunch Bag':
        return 'assets/lunch_bag.png';
      default:
        return 'assets/bag_logo.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ඇණවුම් පෝරමය"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        // Screen එක Scroll කිරීමට හැකි වීමට (Keyboard එක ආ විට වැදගත් වේ)
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // පින්තූරය පෙන්වන තැන
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Image.asset(
                getBagImage(selectedBagType), // Logic එක මෙතැනට සම්බන්ධ වේ
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "ඔබේ නම",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            SizedBox(height: 20),

            // Dropdown එක
            DropdownButtonFormField<String>(
              value: selectedBagType,
              decoration: InputDecoration(
                labelText: "බෑග් වර්ගය තෝරන්න",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: ['School Bag', 'Travel Bag', 'Hand Bag', 'Lunch Bag']
                  .map(
                    (String value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (String? newValue) {
                // 2. පියවර: තිරය Refresh කිරීමට setState භාවිතා කිරීම
                setState(() {
                  selectedBagType = newValue!;
                });
              },
            ),

            SizedBox(height: 20),

            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "දුරකථන අංකය",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                String name = _nameController.text;
                String myNumber = "94742599932";
                String message =
                    "Tharu Bag Center - නව ඇණවුමක්!\n\n"
                    "පාරිභෝගික නම: $name\n"
                    "බෑග් වර්ගය: $selectedBagType";

                var whatsappUrl =
                    "https://wa.me/$myNumber?text=${Uri.encodeComponent(message)}";
                Uri uri = Uri.parse(whatsappUrl);

                if (name.isNotEmpty) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('කරුණාකර ඔබේ නම ඇතුළත් කරන්න')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "තහවුරු කරන්න",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
