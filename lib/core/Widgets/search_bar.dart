import 'package:flutter/material.dart';

Widget MySearch({
  required BuildContext context,
  required String msg,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(13.0),
    ),
    child: ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      leading: const Icon(Icons.search, color: Colors.grey),
      trailing: const Icon(
        Icons.mic_none,
        color: Colors.grey,
      ),
      title: Text(
        msg,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    ),
  );
}
