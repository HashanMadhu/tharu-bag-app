import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 🎯 WhatsApp open කිරීමට අවශ්‍යයි

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // 🎯 WhatsApp එකට පාරිභෝගිකයාව රැගෙන යන Function එක
  Future<void> _launchWhatsApp() async {
    // 💡 94XXXXXXXXX වෙනුවට ඔයාගේ සැබෑ WhatsApp අංකය දාන්න (උදා: 94712345678)
    const String phoneNumber = "94742599932";
    const String message =
        "Hello Tharu Bag Center, මට බෑග් ඇණවුමක් පිළිබඳව විස්තර දැනගන්න අවශ්‍යයි.";

    final Uri whatsappUri = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $whatsappUri';
      }
    } catch (e) {
      print("Error opening WhatsApp: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("අප ගැන (About Us)"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ⛰️ 1. ඉහළ Header කොටස (Logo සහ ආයතනයේ නම)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.shopping_bag,
                      size: 55,
                      color: Colors.brown[700],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Tharu Bag Center",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "උසස් තත්ත්වයේ බෑග් නිෂ්පාදකයෝ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[100],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📝 2. අපේ කතාව (Our Story Card)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.brown),
                          SizedBox(width: 10),
                          Text(
                            "අපේ කතාව (Our Story)",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        "Tharu Bag Center වෙත සාදරයෙන් පිළිගනිමු! අපි වසර ගණනාවක විශ්වාසය හා පළපුරුද්ද සමඟින්, පාරිභෝගික ඔබගේ අවශ්‍යතාවලට සරිලන පරිදි උසස්ම තත්ත්වයේ අමුද්‍රව්‍ය භාවිතයෙන් විවිධ මාදිලියේ බෑග් වර්ග නිෂ්පාදනය කර සාධාරණ මිල ගණන් යටතේ බෙදා හරිනු ලබන්නෙමු.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🎯 3. අපගේ විශේෂත්වයන් (Features)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star_border, color: Colors.brown),
                          SizedBox(width: 10),
                          Text(
                            "අපගේ විශේෂත්වයන්",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10),
                      _FeatureRow(
                        icon: Icons.verified,
                        text: "100% දේශීය නිමාව සහ උසස් ප්‍රමිතිය",
                      ),
                      _FeatureRow(
                        icon: Icons.local_shipping,
                        text: "දිවයින පුරා කඩිනම් ඇණවුම් සැපයීම",
                      ),
                      _FeatureRow(
                        icon: Icons.monetization_on,
                        text: "නිෂ්පාදකයන්ගෙන්ම සෘජුවම සාධාරණ මිල ගණන්",
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 📞 4. සම්බන්ධ කරගත හැකි තොරතුරු සහ WhatsApp (Contact Us Card)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.contact_phone_outlined,
                            color: Colors.brown,
                          ),
                          SizedBox(width: 10),
                          // 💡 Overflow නොවීමට Expanded කර ඇත
                          Expanded(
                            child: Text(
                              "සම්බන්ධ කර ගැනීමට (Contact Us)",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),

                      // ලිපිනය
                      const ListTile(
                        leading: Icon(Icons.location_on, color: Colors.brown),
                        title: Text("ලිපිනය"),
                        subtitle: Text("ලංකා බැංකුව ඉදිරිපිට , පොල්පිතිගම"),
                        contentPadding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 10),

                      // දුරකථන අංකය
                      const ListTile(
                        leading: Icon(Icons.phone, color: Colors.brown),
                        title: Text("දුරකථන අංකය"),
                        subtitle: Text("+94 742 599 933"),
                        contentPadding: EdgeInsets.zero,
                      ),

                      const SizedBox(height: 15),

                      // 🟢 මෙන්න WhatsApp බොත්තම (WhatsApp Button)
                      ElevatedButton.icon(
                        onPressed: _launchWhatsApp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF25D366,
                          ), // WhatsApp Green
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.chat, size: 22),
                        label: const Text(
                          "WhatsApp හරහා සම්බන්ධ වන්න",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Features පේළි සඳහා පොදු Widget එකක්
class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
