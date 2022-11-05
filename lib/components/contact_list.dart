import 'package:flutter/material.dart';
import 'package:flutter_contacts/app_contact.dart';
import 'package:flutter_contacts/components/contact_avatar.dart';
import 'package:flutter_contacts/pages/contact_detail.dart';

class ContactsList extends StatelessWidget {
  final List<AppContact> contacts;
  Function() reloadContacts;

  ContactsList({Key? key, required this.contacts, required this.reloadContacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          AppContact contact = contacts[index];

          return ListTile(
              onTap: (() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ContactDetails(
                    contact,
                    onContactUpdate: (AppContact _contact) {
                      reloadContacts();
                    },
                    onContactDelete: (AppContact _contact) {
                      reloadContacts();
                      Navigator.of(context).pop();
                    },
                  ),
                ));
              }),
              title: Text(contact.info.displayName.toString()),
              subtitle: Text("${contact.info.phones?.elementAt(0).value}"),
              leading: ContactAvatar(contact, 36));
        },
      ),
    );
  }
}
