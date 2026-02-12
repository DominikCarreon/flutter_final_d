import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ChatPage.dart'; // Ensure this import is correct

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _supabase = Supabase.instance.client;
  String _searchQuery = "";

  // 1. ADD FRIEND DIALOG
  Future<void> _showAddFriendDialog() async {
    final nameController = TextEditingController();
    final roleController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => _buildDialog(
        context, 
        title: "Add New Friend", 
        nameController: nameController, 
        roleController: roleController, 
        onSave: () async {
          if (nameController.text.isNotEmpty && roleController.text.isNotEmpty) {
            await _supabase.from('friends').insert({
              'name': nameController.text,
              'role': roleController.text,
              'avatar_url': 'https://i.pravatar.cc/150?u=${DateTime.now().millisecondsSinceEpoch}',
            });
            if (mounted) {
              Navigator.pop(context);
              setState(() {}); 
            }
          }
        },
      ),
    );
  }

  // 2. EDIT FRIEND DIALOG
  Future<void> _showEditFriendDialog(Map<String, dynamic> friend) async {
    final nameController = TextEditingController(text: friend['name']);
    final roleController = TextEditingController(text: friend['role']);

    await showDialog(
      context: context,
      builder: (context) => _buildDialog(
        context, 
        title: "Edit Friend", 
        nameController: nameController, 
        roleController: roleController, 
        onSave: () async {
          if (nameController.text.isNotEmpty && roleController.text.isNotEmpty) {
            await _supabase.from('friends').update({
              'name': nameController.text,
              'role': roleController.text,
            }).eq('id', friend['id']); // Update specific ID
            
            if (mounted) {
              Navigator.pop(context);
              setState(() {}); 
            }
          }
        },
      ),
    );
  }

  // 3. DELETE FRIEND FUNCTION
  Future<void> _deleteFriend(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text("Delete Friend?", style: TextStyle(color: Colors.red)),
        content: const Text("Are you sure you want to remove this friend?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _supabase.from('friends').delete().eq('id', id);
      setState(() {}); // Refresh list
    }
  }

  // Helper widget to avoid duplicate dialog code
  Widget _buildDialog(BuildContext context, {
    required String title, 
    required TextEditingController nameController, 
    required TextEditingController roleController,
    required VoidCallback onSave
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Text(title, style: TextStyle(color: textColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(hintText: "Name (e.g. John Doe)"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: roleController,
            style: TextStyle(color: textColor),
            decoration: const InputDecoration(hintText: "Role (e.g. UI/UX Designer)"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: onSave,
          child: const Text("Save", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey : Colors.grey[700];

    var query = _supabase.from('friends').select().order('name', ascending: true);
    final stream = _searchQuery.isEmpty 
        ? query 
        : _supabase.from('friends').select().ilike('name', '%$_searchQuery%').order('name', ascending: true);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("Friends", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt_1, color: textColor),
            onPressed: _showAddFriendDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: textColor),
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search friends...",
                hintStyle: TextStyle(color: subtitleColor),
                prefixIcon: Icon(Icons.search, color: subtitleColor),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading friends", style: TextStyle(color: textColor)));
                }
                final friends = snapshot.data ?? [];
                if (friends.isEmpty) {
                  return Center(child: Text("No friends found.", style: TextStyle(color: textColor)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
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
                          backgroundImage: NetworkImage(friend['avatar_url'] ?? ''),
                          onBackgroundImageError: (_, __) {}, 
                          child: const Icon(Icons.person, color: Colors.orange),
                        ),
                        title: Text(
                          friend['name'], 
                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            friend['role'], 
                            style: TextStyle(color: subtitleColor, fontSize: 13)
                          ),
                        ),
                        // 4. UPDATED TRAILING: Popup Menu for Edit/Delete/Chat
                        trailing: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: subtitleColor),
                          color: cardColor,
                          onSelected: (value) {
                            if (value == 'chat') {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ChatPage(friendId: friend['id'], friendName: friend['name']),
                              ));
                            } else if (value == 'edit') {
                              _showEditFriendDialog(friend);
                            } else if (value == 'delete') {
                              _deleteFriend(friend['id']);
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'chat',
                              child: Row(children: [Icon(Icons.message, color: Colors.orange, size: 20), SizedBox(width: 8), Text('Message', style: TextStyle(color: textColor))]),
                            ),
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(children: [Icon(Icons.edit, color: Colors.blue, size: 20), SizedBox(width: 8), Text('Edit', style: TextStyle(color: textColor))]),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 20), SizedBox(width: 8), Text('Delete', style: TextStyle(color: textColor))]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}