import 'package:flutter/material.dart';

import 'chats_details.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildFilterButton('All', isActive: true),
              const SizedBox(width: 8),
              _buildFilterButton('Unread'),
              const SizedBox(width: 8),
              _buildFilterButton('Groups'),
              const SizedBox(width: 8),
              _buildFilterButton('Staff'),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              _buildSectionHeader('Unread – 2'),
              _buildChatTile(
                context,
                name: 'Maddy',
                message: 'Hi there!',
                subtext: 'How are you today?',
                time: '9:56 AM',
                unreadCount: 3,
                avatar: 'assets/images/avatar1.png',
              ),
              _buildChatTile(
                context,
                name: 'Jillian Jacob',
                message: 'It’s been a while',
                subtext: 'How are you?',
                time: 'Yesterday',
                unreadCount: 2,
                avatar: 'assets/images/avatar2.png',
              ),
              const Divider(height: 32),
              _buildSectionHeader('Others'),
              _buildChatTile(
                context,
                name: 'Victoria Hanson',
                message: 'Photos from holiday',
                subtext: 'Hi, I put together some photos from...',
                time: '5 Mar',
                avatar: 'assets/images/avatar3.png',
              ),
              _buildChatTile(
                context,
                name: 'Victoria Hanson',
                message: 'Lates order delivery',
                subtext: 'Good morning! Hope you are good...',
                time: '4 Mar',
                avatar: 'assets/images/avatar4.png',
              ),
              _buildChatTile(
                context,
                name: 'Peter Landt',
                message: 'Service confirmation',
                subtext: 'Respected Sir, I Peter, your computer...',
                time: '4 Mar',
                avatar: 'assets/images/avatar5.png',
              ),
              _buildChatTile(
                context,
                name: 'Janice Nelson',
                message: 'Re: Blog for beta relea...',
                subtext: 'Hi, Please take a look at the beta...',
                time: '3 Mar',
                avatar: 'assets/images/avatar6.png',
              ),
              _buildChatTile(
                context,
                name: 'James Norris',
                message: 'Fwd: Event Updated',
                subtext: 'samuel@goodman@zara.com Invite...',
                time: '3 Mar',
                avatar: 'assets/images/avatar7.png',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFilterButton(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildChatTile(
    BuildContext context, {
    required String name,
    required String message,
    required String subtext,
    required String time,
    required String avatar,
    int unreadCount = 0,
  }) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailScreen(name: name, avatar: avatar),
          ),
        );
      },
      leading: CircleAvatar(backgroundImage: AssetImage(avatar), radius: 24),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            time,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtext, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      trailing:
          unreadCount > 0
              ? CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue,
                child: Text(
                  '$unreadCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
              : null,
    );
  }
}
