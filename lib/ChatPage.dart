import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart'; 

class ChatPage extends StatefulWidget {
  final int friendId;
  final String friendName;

  const ChatPage({super.key, required this.friendId, required this.friendName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  

  final String _apiKey = 'AIzaSyCf5gohjyRaSUHA0WC2_svVmETzeaqZc08'; 
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-1.5-flash-001', apiKey: _apiKey);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    try {
      await _supabase.from('messages').insert({
        'friend_id': widget.friendId,
        'content': text,
        'is_from_user': true,
      });

      _messageController.clear();


      if (widget.friendName.contains("AI")) {
        try {
          final content = [Content.text(text)];
          final response = await _model.generateContent(content);
          final aiReply = response.text ?? "I am listening...";

          await _supabase.from('messages').insert({
            'friend_id': widget.friendId,
            'content': aiReply,
            'is_from_user': false, 
          });
        } catch (aiError) {

          await _supabase.from('messages').insert({
            'friend_id': widget.friendId,
            'content': "AI Error: $aiError", 
            'is_from_user': false, 
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bubbleColorUser = Colors.orange;
    final bubbleColorFriend = isDark ? const Color(0xFF1E1E1E) : Colors.grey[300];

    final gradientColors = isDark 
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
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.friendName, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20, color: textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _supabase.from('messages').stream(primaryKey: ['id']).eq('friend_id', widget.friendId).order('created_at', ascending: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator(color: Colors.orange));
                  }
                  final messages = snapshot.data ?? [];
                  if (messages.isEmpty) return Center(child: Text("Say hi!", style: TextStyle(color: Colors.grey)));

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['is_from_user'] as bool;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          constraints: const BoxConstraints(maxWidth: 250),
                          decoration: BoxDecoration(
                            color: isMe ? bubbleColorUser : bubbleColorFriend,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(msg['content'], style: TextStyle(color: isMe ? Colors.white : textColor)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.orange),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}