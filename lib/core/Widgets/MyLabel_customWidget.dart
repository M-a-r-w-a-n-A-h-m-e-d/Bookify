import 'package:flutter/material.dart';

Widget MyLabel({
  required BuildContext context,
  required String msg,
  required VoidCallback onTap,
  Color? color,
  required IconData icon,
  TextStyle? msgStyle,
}) {
  return Container(
    margin: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(11.0),
    ),
    child: ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).colorScheme.onPrimary,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      leading: Icon(icon,color: color,),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            msg,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          Icon(Icons.arrow_forward_ios,color: Colors.grey.shade700,size: 17),
        ],
      ),
    ),
  );
}
