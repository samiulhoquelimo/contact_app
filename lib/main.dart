import 'package:contact_app/pages/contact_details_page.dart';
import 'package:contact_app/pages/contact_home_page.dart';
import 'package:contact_app/pages/new_contact_page.dart';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ContactProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        ContactHomePage.routeName : (context) => ContactHomePage(),
        NewContactPage.routeName : (context) => NewContactPage(),
        ContactDetailsPage.routeName : (context) => ContactDetailsPage(),
      },
    );
  }
}


