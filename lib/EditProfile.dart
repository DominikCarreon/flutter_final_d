import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.orange,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _isEditing = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 0) _isEditing = false; 
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget profileTab = _isEditing 
      ? EditProfilePage(onBack: () => setState(() => _isEditing = false)) 
      : ViewProfilePage(onEdit: () => setState(() => _isEditing = true));

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          profileTab,
          const Center(child: Text("Friends Screen", style: TextStyle(fontSize: 24))),
          const Center(child: Text("Settings Screen", style: TextStyle(fontSize: 24))),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF121212),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.group_outlined), activeIcon: Icon(Icons.group), label: 'Friends'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}


class ViewProfilePage extends StatelessWidget {
  final VoidCallback onEdit;
  const ViewProfilePage({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [

          Center(
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.orange, Colors.redAccent]),
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Alex Chen", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const Text("Senior Mobile Developer", style: TextStyle(color: Colors.orange, fontSize: 16)),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              Text(" San Francisco, CA", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Passionate about building beautiful, performant mobile experiences. 5+ years crafting apps that users love.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 24),
          // Clickable Social Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.code, "GitHub"),
              _socialIcon(Icons.business_center, "LinkedIn"),
              _socialIcon(Icons.flutter_dash, "Twitter"),
            ],
          ),
          const SizedBox(height: 32),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statBox("24", "Projects"),
              _statBox("1.2K", "Followers"),
              _statBox("89", "Following"),
            ],
          ),
          const SizedBox(height: 32),
          // Skills Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.work_outline, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text("Skills & Expertise", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ["Flutter", "Dart", "React", "TypeScript", "Node.js", "Firebase"].map((s) => _skillChip(s)).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Clickable Edit Profile Button
          InkWell(
            onTap: onEdit,
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(colors: [Color(0xFFFF5252), Color(0xFFFFB74D)]),
              ),
              child: const Center(child: Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, String platform) {
    return InkWell(
      onTap: () => print("Clicked $platform"),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white70, size: 22),
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
          child: Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _skillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

// --- EDIT PROFILE PAGE ---
class EditProfilePage extends StatelessWidget {
  final VoidCallback onBack;
  const EditProfilePage({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: onBack),
        title: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Image with Camera Icon
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(radius: 65, backgroundColor: Colors.orange, child: CircleAvatar(radius: 63, backgroundImage: NetworkImage('https://i.pravatar.cc/300'))),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _editField("Full Name", "Alex Chen"),
            _editField("Job Title", "Senior Mobile Developer"),
            _editField("Bio", "Passionate about building beautiful, performant mobile experiences.", maxLines: 3),
            _editField("Email", "alex.chen@example.com"),
            _editField("Location", "San Francisco, CA"),
            _editField("Website", "https://alexchen.dev"),
            const SizedBox(height: 40),
            // Clickable Save Changes Button
            GestureDetector(
              onTap: onBack,
              child: const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _editField(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}