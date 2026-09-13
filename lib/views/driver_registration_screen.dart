import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/driver_model.dart';

class DriverRegistrationScreen extends StatefulWidget {
  final String phoneNumber;
  final String uid;

  const DriverRegistrationScreen({
    super.key,
    required this.phoneNumber,
    required this.uid,
  });

  @override
  _DriverRegistrationScreenState createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();

  File? _profileImage;
  File? _aadharImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // ছবি তোলার বা গ্যালারি থেকে নেওয়ার ফাংশন
  Future<void> _pickImage(bool isProfile) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isProfile) {
          _profileImage = File(pickedFile.path);
        } else {
          _aadharImage = File(pickedFile.path);
        }
      });
    }
  }

  // ফায়ারবেস স্টোরেজে ছবি আপলোড করে লিংক পাওয়ার ফাংশন
  Future<String> _uploadImage(File image, String folderName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
        '$folderName/${widget.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  // ডাটা সেভ করার মূল ফাংশন
  Future<void> _registerDriver() async {
    if (_formKey.currentState!.validate()) {
      if (_profileImage == null || _aadharImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'দয়া করে ড্রাইভারের ছবি এবং আধার কার্ডের ছবি আপলোড করুন',
            ),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // ১. ছবিগুলো ফায়ারবেস স্টোরেজে আপলোড করা
        String profileUrl = await _uploadImage(
          _profileImage!,
          'driver_profiles',
        );
        String aadharUrl = await _uploadImage(_aadharImage!, 'driver_adhars');

        // ২. মডেল তৈরি করা
        DriverModel newDriver = DriverModel(
          uid: widget.uid,
          name: _nameController.text.trim(),
          phone: widget.phoneNumber,
          aadharNumber: _aadharController.text.trim(),
          profileImageUrl: profileUrl,
          aadharImageUrl: aadharUrl,
          isVerified: false, // অ্যাডমিন ভেরিফাই না করা পর্যন্ত ফলস থাকবে
        );

        // ৩. ফায়ারবেস ক্লাউড ফায়ারস্টোরে সেভ করা
        await firestore.FirebaseFirestore.instance
            .collection('drivers')
            .doc(widget.uid)
            .set(newDriver.toMap());

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'রেজিস্ট্রেশন সফল হয়েছে! অ্যাডমিন অ্যাপ্রুভালের জন্য অপেক্ষা করুন।',
            ),
          ),
        );

        // পরবর্তী স্ক্রিনে যাওয়ার কোড এখানে যুক্ত করা যাবে
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ত্রুটি হয়েছে: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'ড্রাইভারের নাম'),
                validator: (value) => value!.isEmpty ? 'নাম লিখুন' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _aadharController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'পরিচয়পত্র / আধার নম্বর',
                ),
                validator: (value) => value!.isEmpty ? 'নম্বর লিখুন' : null,
              ),
              const SizedBox(height: 20),
              // প্রোফাইল ছবি তোলার বাটন
              ListTile(
                title: const Text('ড্রাইভারের ছবি'),
                trailing: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () => _pickImage(true),
                ),
              ),
              if (_profileImage != null)
                Image.file(_profileImage!, height: 100, width: 100),

              const SizedBox(height: 10),
              // আধার কার্ডের ছবি তোলার বাটন
              ListTile(
                title: const Text('আধার কার্ডের ছবি'),
                trailing: IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () => _pickImage(false),
                ),
              ),
              if (_aadharImage != null)
                Image.file(_aadharImage!, height: 100, width: 100),

              const SizedBox(height: 30),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _registerDriver,
                    child: const Text('সাবমিট করুন'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
