import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'dart:io';
import 'Friends.dart';
import 'Settings.dart'; 
import 'AboutMe.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    // I kept your credentials here so it works immediately for you
    url: 'https://jfatjhfczazwdiyhavwt.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmYXRqaGZjemF6d2RpeWhhdnd0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA4MzE3MDUsImV4cCI6MjA4NjQwNzcwNX0.kUNoBPIj7CnkVFUehlFg6BlEGpqXoqpiQd51529GGK8', 
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;

  void toggleTheme(bool isOn) {
    setState(() {
      _isDarkMode = isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode 
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.transparent,
              cardColor: const Color(0xFF1E1E1E),
              appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Color(0xFF121212)),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.transparent,
              cardColor: Colors.grey[100],
              appBarTheme: const AppBarTheme(foregroundColor: Colors.black),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.white),
            ),
      home: MainNavigation(isDarkMode: _isDarkMode, onThemeChanged: toggleTheme),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const MainNavigation({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _isEditing = false;

  Map<String, String> profileData = {
    'name': 'Dominik V. Carreon',
    'title': 'Senior Mobile Developer',
    'bio': 'Passionate about building beautiful, performant mobile experiences. 5+ years crafting apps that users love.',
    'location': 'Metro Manila, Pasay City',
    'imagePath': '',
    'skills': 'Flutter, Dart, Firebase, UI/UX Design, Git, REST APIs, Agile Methodologies,React Native, Vercel, Figma, Vite, Node.js, Express.js, MongoDB, SQL, Python, Java', 
    'games': 'Valorant, League of Legends, CS2, Mobile Legends, Genshin Impact, Among Us, Call of Duty Mobile, Apex Legends Mobile, PUBG Mobile, Clash Royale', 
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index != 0) _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Structure was broken here. I fixed the list logic.
    final List<Widget> pages = [
      _isEditing 
          ? EditProfilePage(
              currentData: profileData,
              onSave: (newData) => setState(() {
                profileData = newData;
                _isEditing = false;
              }),
              onCancel: () => setState(() => _isEditing = false),
            ) 
          : ViewProfilePage(
              data: profileData,
              onEdit: () => setState(() => _isEditing = true),
            ),
      const FriendsPage(),
      SettingsPage(
        isDarkMode: widget.isDarkMode, 
        onThemeChanged: widget.onThemeChanged
      ),
    ];

    final gradientColors = widget.isDarkMode 
        ? [const Color(0xFF121212), const Color(0xFF2C1F1F)]
        : [const Color(0xFFFFF5F5), const Color(0xFFFFF0E0)];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: widget.isDarkMode ? const Color(0xFF121212) : Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Friends'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class ViewProfilePage extends StatelessWidget {
  final Map<String, String> data;
  final VoidCallback onEdit;
  const ViewProfilePage({super.key, required this.data, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey : Colors.black54;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey[200]!;
    final iconColor = isDark ? Colors.grey : Colors.grey[700];

    ImageProvider backgroundImage;
    if (data['imagePath'] != null && data['imagePath']!.isNotEmpty) {
      backgroundImage = FileImage(File(data['imagePath']!));
    } else {
      backgroundImage = const NetworkImage('https://media.licdn.com/dms/image/v2/D4E03AQEAFJoPMNhcdQ/profile-displayphoto-shrink_800_800/B4EZWpOwHuGwAc-/0/1742300971993?e=1772064000&v=beta&t=F_MOdKxnTQUQseHAdqajVKl3YuHWzr9eMBoCji4Fkf8');
    }

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
              child: CircleAvatar(
                radius: 60,
                backgroundImage: backgroundImage,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(data['name']!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
          Text(data['title']!, style: const TextStyle(color: Colors.orange, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: subTextColor),
              Text(" ${data['location']}", style: TextStyle(color: subTextColor)),
            ],
          ),
          const SizedBox(height: 16),
          Text(data['bio']!, textAlign: TextAlign.center, style: TextStyle(color: subTextColor, height: 1.5)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.terminal, 'https://github.com/DominikCarreon', cardColor, iconColor), 
              _socialIcon(Icons.business, 'https://www.linkedin.com/in/dominik-carreon-8053b83a7/', cardColor, iconColor), 
              _socialIcon(Icons.email_outlined, 'mailto:dvcarreon@student.apc.edu.ph', cardColor, iconColor),
            ],
          ),
          const SizedBox(height: 32),
          
          // --- STATS ROW UPDATED ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statBox("69", "Publish Projects", textColor, subTextColor),
              
              // FIX: REAL-TIME CONNECTION COUNT FROM SUPABASE
              StreamBuilder<List<Map<String, dynamic>>>(
                // This listens to the database in real-time
                stream: Supabase.instance.client.from('friends').stream(primaryKey: ['id']),
                builder: (context, snapshot) {
                  String count = "..."; 
                  if (snapshot.hasData) {
                    // Counts the actual number of friends in your database
                    count = snapshot.data!.length.toString();
                  }
                  return _statBox(count, "Connections", textColor, subTextColor);
                },
              ),
              
              _statBox("420", "Followers", textColor, subTextColor),
            ],
          ),
          // -------------------------

          const SizedBox(height: 32),
          
          AboutMeSection(
            title: "My Skills", 
            content: data['skills']!, 
            cardColor: cardColor, 
            textColor: textColor, 
            isDark: isDark
          ),
          const SizedBox(height: 16),
          AboutMeSection(
            title: "Games I Play", 
            content: data['games']!, 
            cardColor: cardColor, 
            textColor: textColor, 
            isDark: isDark
          ),

          const SizedBox(height: 40),
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

  Widget _socialIcon(IconData icon, String urlString, Color? bgColor, Color? iconColor) {
    return InkWell(
      onTap: () async {
        final Uri url = Uri.parse(urlString);
        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          debugPrint('Could not launch $url');
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _statBox(String value, String label, Color valueColor, Color labelColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
          child: Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: labelColor, fontSize: 12)),
      ],
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final Map<String, String> currentData;
  final Function(Map<String, String>) onSave;
  final VoidCallback onCancel;

  const EditProfilePage({super.key, required this.currentData, required this.onSave, required this.onCancel});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController titleController;
  late TextEditingController bioController;
  late TextEditingController locationController;
  late TextEditingController skillsController; 
  late TextEditingController gamesController;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentData['name']);
    titleController = TextEditingController(text: widget.currentData['title']);
    bioController = TextEditingController(text: widget.currentData['bio']);
    locationController = TextEditingController(text: widget.currentData['location']);
    skillsController = TextEditingController(text: widget.currentData['skills']); 
    gamesController = TextEditingController(text: widget.currentData['games']);
    _selectedImagePath = widget.currentData['imagePath'];
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() { _selectedImagePath = image.path; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldFillColor = isDark ? const Color(0xFF1E1E1E) : (Colors.grey[200] ?? Colors.grey);
    final textColor = isDark ? Colors.white : Colors.black;

    ImageProvider backgroundImage;
    if (_selectedImagePath != null && _selectedImagePath!.isNotEmpty) {
      backgroundImage = FileImage(File(_selectedImagePath!));
    } else {
      backgroundImage = const NetworkImage('https://media.licdn.com/dms/image/v2/D4E03AQEAFJoPMNhcdQ/profile-displayphoto-shrink_800_800/B4EZWpOwHuGwAc-/0/1742300971993?e=1772064000&v=beta&t=F_MOdKxnTQUQseHAdqajVKl3YuHWzr9eMBoCji4Fkf8');
    }

    return Scaffold(
      backgroundColor: Colors.transparent, // Update here for gradient
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor), 
          onPressed: widget.onCancel
        ),
        title: Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(radius: 65, backgroundColor: Colors.orange, child: CircleAvatar(radius: 63, backgroundImage: backgroundImage)),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _editField("Full Name", nameController, fieldFillColor, textColor),
            _editField("Job Title", titleController, fieldFillColor, textColor),
            _editField("Bio", bioController, fieldFillColor, textColor, maxLines: 3),
            _editField("Location", locationController, fieldFillColor, textColor),
            
            _editField("Skills (comma separated)", skillsController, fieldFillColor, textColor),
            _editField("Games (comma separated)", gamesController, fieldFillColor, textColor),

            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => widget.onSave({
                'name': nameController.text,
                'title': titleController.text,
                'bio': bioController.text,
                'location': locationController.text,
                'skills': skillsController.text, 
                'games': gamesController.text,   
                'imagePath': _selectedImagePath ?? '',
              }),
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(colors: [Color(0xFFFF5252), Color(0xFFFFB74D)]),
                ),
                child: const Center(child: Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editField(String label, TextEditingController controller, Color fillColor, Color textColor, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}