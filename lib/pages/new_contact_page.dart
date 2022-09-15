import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/helper_functions.dart';

class NewContactPage extends StatefulWidget {
  static const String routeName = '/new_contact';

  const NewContactPage({Key? key}) : super(key: key);

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  String? dob;
  String? imagePath;
  ImageSource source = ImageSource.camera;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contact'),
        actions: [
          IconButton(
            onPressed: _saveContact,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 24.0,
          ),
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Card(
                      elevation: 5.0,
                      child: imagePath == null
                          ? const Icon(Icons.person, size: 70.0)
                          : Image.file(File(imagePath!), fit: BoxFit.cover),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          source = ImageSource.camera;
                          _getImage();
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Camera'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          source = ImageSource.gallery;
                          _getImage();
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Gallery'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Contact Name*',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Text field must not be empty';
                }
                if (value.length > 20) {
                  return 'Name should be less than or equals 20 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _mobileController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Mobile Number*',
                prefixIcon: Icon(Icons.call),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Text field must not be empty';
                }
                if (value.length != 11 && value.length != 14) {
                  return 'Invalid mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.call),
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Street Address',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: _showCalender,
                      label: const Text('Show Date Picker'),
                    ),
                    Text(dob == null ? 'No date chosen' : dob!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _saveContact() {
    formKey.currentState?.validate();
  }

  _showCalender() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (dateTime != null) {
      setState(() {
        dob = getFormattedDate(dateTime, 'dd/MM/yyyy');
      });
    }
  }

  void _getImage() async {
    final xFile = await ImagePicker().pickImage(source: source);

    if (xFile != null) {
      setState(() {
        imagePath = xFile.path;
      });
    }
  }
}
