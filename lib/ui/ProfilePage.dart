import 'dart:io';
import 'package:chatapp/ui/Main_page.dart';
import 'package:chatapp/ux/FirebaseService.dart';
import 'package:chatapp/ux/GetIt.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  int _themeValue = 1;
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SafeArea(child: SingleChildScrollView(
        child:Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child:
                        _image == null
                            ? Image.network(
                              "https://imgs.search.brave.com/LiuI83vxS82ZNllheTy12yvXkniiyov184EFUIuThsE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzLzYxL2Y3/LzVlLzYxZjc1ZWE5/YTY4MGRlZjJlZDFj/NjkyOWZlNzVhZWVl/LmpwZw",
                              fit: BoxFit.cover,
                            )
                            : Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      setState(() {
                        _image = File(image.path);
                      });
                    }
                  },
                  child: const Text("Change Image"),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 300,
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Card(
            color: Colors.white,
            shadowColor: Colors.white,
            borderOnForeground: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Profile", style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  const Text(
                    "Themes",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _themeValue,
                        onChanged: (value) {
                          setState(() {
                            _themeValue = value as int;
                          });
                        },
                      ),
                      const Text("Light"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 2,
                        groupValue: _themeValue,
                        onChanged: (value) {
                          setState(() {
                            _themeValue = value as int;
                          });
                        },
                      ),
                      const Text("Dark"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                bool? result;
                if (_image == null ) {
                  result = await getIt<Firebaseservice>().setProfile(
                    null,
                    isImage:false,
                    name:name,
                  );
                }
                else{
                  result = await getIt<Firebaseservice>().setProfile(
                    _image,
                    isImage: true,
                   name: name,
                  );
                }
                if (result!) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile updated successfully!"),
                    ),
                  );
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Main_Page()), (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to update profile.")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a name.")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
 
      ))   );
  }
}
