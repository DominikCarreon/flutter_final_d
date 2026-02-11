import 'package:flutter/material.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey : Colors.grey[700];

    final List<Map<String, String>> friends = [
      {"name": "Michael Park", "role": "iOS Developer"},
      {"name": "Emily Davis", "role": "Full Stack Engineer"},
      {"name": "James Wilson", "role": "DevOps Engineer"},
      {"name": "Lisa Chen", "role": "UX Researcher"},
      {"name": "David Kim", "role": "Backend Developer"},
      {"name": "Anna Martinez", "role": "Flutter Developer"},
    ];

    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent to show gradient
      appBar: AppBar(
        title: Text("Friends", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt_1, color: textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Search friends...",
                hintStyle: TextStyle(color: subtitleColor),
                prefixIcon: Icon(Icons.search, color: subtitleColor),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), 
                  borderSide: BorderSide.none
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return Card(
                  color: cardColor,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.orange.withOpacity(0.2),
                      backgroundImage: const NetworkImage('https://i.pravatar.cc/100'),
                      onBackgroundImageError: (_, __) {}, 
                      child: const Icon(Icons.person, color: Colors.orange),
                    ),
                    title: Text(
                      friends[index]['name']!, 
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        friends[index]['role']!, 
                        style: TextStyle(color: subtitleColor, fontSize: 13)
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.message_outlined, size: 20, color: subtitleColor),
                        onPressed: () {},
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}