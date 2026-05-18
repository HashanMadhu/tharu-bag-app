import 'package:flutter/material.dart';

class BillPage extends StatelessWidget {
  // 💡 ප්‍රමාණය සහ මුළු මුදල ලබා ගැනීමට අලුත් විචල්‍යයන් දෙකක් එකතු කළා
  final String customerName;
  final String bagType;
  final int contact;
  final String address;
  final int quantity;
  final double totalPrice;

  const BillPage({
    super.key, 
    required this.customerName, 
    required this.bagType,
    required this.contact,
    required this.address,
    required this.quantity, // 👈 Required කළා
    required this.totalPrice, // 👈 Required කළා
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
          // 💡 දිග ලිපිනයක් ආවොත් Card එක Screen එකෙන් එළියට පනින්නේ නැති වෙන්න SingleChildScrollView එකක් දැම්මා
          child: SingleChildScrollView(
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
                    
                    // --- 👤 Customer Name ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Customer Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(customerName),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // --- 🎒 Bag Type ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bag Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                        // දිග බෑග් නමක් තිබුණොත් Overflow නොවෙන්න Expanded කළා
                        Expanded(
                          child: Text(
                            bagType,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 🔢 Quantity (අලුතින් එකතු කළා) ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          "$quantity",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 💵 Total Amount (අලුතින් එකතු කළා) ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          "Rs. ${totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // --- 📞 Contact ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Contact:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("0$contact"), // දුරකථන අංකයට ඉදිරියෙන් 0 පෙන්වීමට
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // --- 📍 Address ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            address,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        minimumSize: const Size(double.infinity, 45), // බටන් එක ලස්සනට දිගට පෙනෙන්න
                      ),
                      child: const Text('Go to Home', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}