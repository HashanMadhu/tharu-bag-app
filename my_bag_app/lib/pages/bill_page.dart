import 'package:flutter/material.dart';


class BillPage extends StatelessWidget {
  // OrderPage එකෙන් එවන දත්ත ලබා ගැනීමට මෙන්න මේ විචල්‍යයන් (Variables) සාදා ගනිමු
  final String customerName;
  final String bagType;

  const BillPage({
    super.key, 
    required this.customerName, 
    required this.bagType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 20),
                  const Text(
                    'Order Confirmed!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 40),
                  
                  // විස්තර පෙන්වන කොටස
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Customer Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(customerName),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bag Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(bagType),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context), // නැවත Order Page එකට යාමට
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    child: const Text('Back to Home', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
