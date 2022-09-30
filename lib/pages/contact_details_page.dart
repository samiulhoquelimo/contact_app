import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/helper_functions.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = '/details';

  const ContactDetailsPage({Key? key}) : super(key: key);

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final id = argList[0];
    final name = argList[1];
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => FutureBuilder<ContactModel>(
          future: provider.getById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final contact = snapshot.data!;
              return ListView(
                children: [
                  contact.image == null
                      ? Image.asset(
                          'assets/placeholder.png',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(contact.image!),
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                  ListTile(
                      title: Text(contact.mobile),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _callContact(contact.mobile);
                            },
                            icon: const Icon(Icons.call),
                          ),
                          IconButton(
                            onPressed: () {
                              _smsContact(contact.mobile);
                            },
                            icon: const Icon(Icons.sms),
                          ),
                        ],
                      )),
                  ListTile(
                      title: Text(contact.email!.isEmpty
                          ? 'Email not set yet'
                          : contact.email!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showUpdateDialog(
                                  context: context,
                                  title: 'Email',
                                  onSaved: (value) async {
                                    await provider.updateById(
                                        id, tblContactColEmail, value);
                                    setState(() {});
                                  });
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          if (contact.email!.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                _emailContact(contact.email!);
                              },
                              icon: const Icon(Icons.email),
                            ),
                        ],
                      )),
                  ListTile(
                      title: Text(contact.streetAddress!.isEmpty
                          ? 'Address not set yet'
                          : contact.streetAddress!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showUpdateDialog(
                                context: context,
                                title: 'Address',
                                onSaved: (value) async {
                                  await provider.updateById(
                                      id, tblContactColAddress, value);
                                  setState(() {});
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          if (contact.streetAddress!.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                _mapContact(contact.streetAddress!);
                              },
                              icon: const Icon(Icons.location_city),
                            ),
                        ],
                      )),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to fetch data'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _callContact(String mobile) async {
    Uri mobileUrl = Uri.parse("tel:$mobile");
    if (await canLaunchUrl(mobileUrl)) {
      await launchUrl(mobileUrl);
    } else {
      showMsg(context, 'Cannot perform this operation');
    }
  }

  void _smsContact(String sms) async {
    Uri smsUrl = Uri.parse("sms:$sms");
    if (await canLaunchUrl(smsUrl)) {
      await launchUrl(smsUrl);
    } else {
      showMsg(context, 'Cannot perform this operation');
    }
  }

  void _emailContact(String email) async {
    final Uri emailUrl = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Send from Contact App',
    );
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    } else {
      showMsg(context, 'Cannot perform this operation');
    }
  }

  void _mapContact(String address) async {
    final Uri mapUrl = Uri.parse('https://www.google.com/maps/place/$address');
    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl);
    } else {
      showMsg(context, 'Cannot perform this operation');
    }
  }
}
