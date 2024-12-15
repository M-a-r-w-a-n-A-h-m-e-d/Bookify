import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_doctor/Features/home/navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map<String, String>> notifications = [];

  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? notificationsJson = prefs.getString('notifications');
      if (notificationsJson != null) {
        final List<dynamic> decodedData = json.decode(notificationsJson);
        setState(() {
          notifications = decodedData
              .map((item) => Map<String, String>.from(item as Map))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String notificationsJson = json.encode(notifications);
      await prefs.setString('notifications', notificationsJson);
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  void _removeNotification(int index) async {
    setState(() {
      notifications.removeAt(index);
    });
    await _saveNotifications();
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(
                  myIndex: 0,
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text('No notifications available'),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  elevation: 2,
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text(
                      notifications[index]['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${notifications[index]['body']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${notifications[index]['time']}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeNotification(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
