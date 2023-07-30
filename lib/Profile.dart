import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import '../../Components/custombutton.dart';

import '../../Models/User.dart';
import 'Components/customfield.dart';

class Profile extends StatefulWidget {
  const Profile(
      {Key? key,
      required this.name,
      required this.email,
      required this.phone,
      required this.nid})
      : super(key: key);
  // final CurrentUser user;
  final String name, email, phone, nid;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late CurrentUser user;
  @override
  void initState() {
    super.initState();
    // user = widget.user;
    _name.text = widget.name;
    _email.text = widget.email;
    _phone.text = widget.phone;
    _nid.text = widget.nid;
  }

  bool _loadImageError = false;
  File? file;
  String name = '';
  String url = '';
  UploadTask? task;
  final ref = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance.currentUser;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _nid = TextEditingController();

  // ImagePicker imagePicker = ImagePicker();
  String imageUrl = '';
  String uniqueFileName = '';
  // XFile? file, xfile;
  Reference _refStorage = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  try {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (result != null) {
                      File c = File(result.files.single.path.toString());
                      setState(() {
                        file = c;
                        name = result.names.toString();
                      });
                    }
                    name = DateTime.now().millisecondsSinceEpoch.toString() +
                        p.extension(file!.path);
                    task =
                        _refStorage.child('Avatars').child(name).putFile(file!);
                    TaskSnapshot? snapshot = await task;
                    url = (await snapshot?.ref.getDownloadURL())!;

                    if (url != null) {
                      {
                        auth?.updatePhotoURL(url);
                        await ref.doc('${auth?.uid}').update({
                          'image': url,
                        });
                      }

                      file = null;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Something went wrong.')));
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${error.toString()}')));
                  }
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage('${auth?.photoURL}'),
                ),
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintText: "Name",
                icon: Icons.account_box,
                cont: _name,
              ),
              SizedBox(height: 10),
              CustomTextField(
                hintText: "Email",
                icon: Icons.account_box,
                cont: _email,
              ),
              SizedBox(height: 10),
              CustomTextField(
                hintText: "Phone Number",
                icon: Icons.confirmation_num,
                cont: _phone,
              ),
              SizedBox(height: 10),
              CustomTextField(
                hintText: "NID",
                icon: Icons.confirmation_num,
                cont: _nid,
              ),
              SizedBox(height: 25),
              CustomButton(
                txt: 'Update',
                action: () async {
                  try {
                    auth?.updateDisplayName(_name.text);
                    auth?.updateEmail(_email.text);

                    await ref.doc('${auth?.uid}').update({
                      'name': _name.text,
                      'email': _email.text,
                      'phone': _phone.text,
                      'nid': _nid.text,
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Updated Successfully!')));
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('${e}')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}