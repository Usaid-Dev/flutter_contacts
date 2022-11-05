import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/utils/default_button.dart';
import '../app_contact.dart';
import '../components/contact_avatar.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails(this.contact,
      {required this.onContactUpdate, required this.onContactDelete});

  final AppContact contact;
  final Function(AppContact) onContactUpdate;
  final Function(AppContact) onContactDelete;
  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  @override
  Widget build(BuildContext context) {
    List<String> actions = <String>['Edit', 'Delete'];

    showDeleteConfirmation() {
      AlertDialog alert = AlertDialog(
        title: const Text("Delete Contact"),
        content: const Text("Are you sure you want to delete this contact"),
        actions: <Widget>[
          DefaultButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.blue,
            child: const Text("Cancel"),
          ),
          DefaultButton(
            onPressed: () async {
              await ContactsService.deleteContact(widget.contact.info);
              widget.onContactDelete(widget.contact);
              Navigator.of(context).pop();
            },
            color: Colors.red,
            child: const Text("Delete"),
          ),
        ],
      );

      showDialog(
          context: context,
          builder: ((context) {
            return alert;
          }));
    }

    onAction(String action) async {
      switch (action) {
        case 'Edit':
          try {
            Contact updatedcontact =
                await ContactsService.openExistingContact(widget.contact.info);
            setState(() {
              widget.contact.info = updatedcontact;
            });
            widget.onContactUpdate(widget.contact);
          } on FormOperationException catch (e) {
            switch (e.errorCode) {
              case FormOperationErrorCode.FORM_OPERATION_CANCELED:
              case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
              case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                print(e.toString());
            }
          }
          break;
        case 'Delete':
          showDeleteConfirmation();
          break;
      }
      print(action);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 180,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Center(child: ContactAvatar(widget.contact, 100)),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PopupMenuButton(
                          onSelected: onAction,
                          itemBuilder: (BuildContext context) {
                            return actions.map((String action) {
                              return PopupMenuItem(
                                value: action,
                                child: Text(action),
                              );
                            }).toList();
                          }),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
                ListTile(
                  title: const Text("First Name"),
                  trailing: Text(widget.contact.info.givenName ?? ""),
                ),
                ListTile(
                  title: const Text("Last name"),
                  trailing: Text(widget.contact.info.familyName ?? ""),
                ),
                Column(
                  children: <Widget>[
                    Column(
                      children: widget.contact.info.phones!
                          .map(
                            (i) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: ListTile(
                                title: Text(i.label ?? ""),
                                trailing: Text(i.value ?? ""),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
