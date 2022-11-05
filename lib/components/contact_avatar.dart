import 'package:flutter/material.dart';
import '../app_contact.dart';
import '../utils/color_gradient.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar(this.contact, this.size, {super.key});
  final AppContact contact;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, gradient: getColorGradient(contact.color)),
        child: (contact.info.avatar != null && contact.info.avatar!.isNotEmpty)
            ? CircleAvatar(
                backgroundImage: MemoryImage(contact.info.avatar!),
              )
            : CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(contact.info.initials(),
                    style: const TextStyle(color: Colors.white))));
  }
}
