import 'package:contact_app/pages/contact_details_page.dart';
import 'package:contact_app/pages/contact_home_pahe.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: ContactHomePage.routeName,
      routes: {
        ContactHomePage.routeName: (context) => const ContactHomePage(),
        NewContactPage.routeName: (context) => const NewContactPage(),
        ContactDetailsPage.routeName: (context) => const ContactDetailsPage(),
      },
    );
  }
}
