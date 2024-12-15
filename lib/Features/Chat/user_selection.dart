import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSelectionPage extends StatefulWidget {
  @override
  _UserSelectionPageState createState() => _UserSelectionPageState();
}

class _UserSelectionPageState extends State<UserSelectionPage> {
  late String _currentUserId;
  List<String> _userList = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
      await _loadUsers();
    } else {
      setState(() {
        _errorMessage = 'No user is logged in.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUsers() async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .listen((snapshot) {
        setState(() {
          _userList = snapshot.docs
              .where((doc) => doc.id != _currentUserId)
              .map((doc) => doc.id)
              .toList();
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load users: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToChat(String otherUserId) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ChatPage(
    //       currentUserId: _currentUserId,
    //       otherUserId: otherUserId,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _userList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_userList[index]),
                      onTap: () => _navigateToChat(_userList[index]),
                    );
                  },
                ),
    );
  }
}
