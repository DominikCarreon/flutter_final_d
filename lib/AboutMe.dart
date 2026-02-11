import 'package:flutter/material.dart';

class AboutMeSection extends StatelessWidget {
  final String title;
  final String content;
  final Color cardColor;
  final Color textColor;
  final bool isDark;

  const AboutMeSection({
    super.key,
    required this.title,
    required this.content,
    required this.cardColor,
    required this.textColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    List<String> items = content.split(',').where((e) => e.trim().isNotEmpty).toList();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title, 
            style: const TextStyle(
              color: Colors.orange, 
              fontWeight: FontWeight.bold, 
              fontSize: 16
            )
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey.shade300
                  ),
                ),
                child: Text(
                  item.trim(), 
                  style: TextStyle(color: textColor, fontSize: 14)
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}