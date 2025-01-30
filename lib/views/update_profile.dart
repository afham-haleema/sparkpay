import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sparkpay/controllers/db_service.dart';
import 'package:sparkpay/providers/user_provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nationalIdController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    final user = Provider.of<UserProvider>(context, listen: false);
    nameController.text = user.name;
    emailController.text = user.email;
    phoneController.text = user.phone;
    nationalIdController.text = user.nationalID;
    nationalityController.text = user.nationality;
    dobController.text = user.dob;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 23, 50, 97),
        foregroundColor: Colors.white,
        title: Text(
          'Update Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nameController,
                    validator: (value) =>
                        value!.isEmpty ? 'Name cant be empty' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('Name'),
                        hintText: 'Enter name'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Email Address',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) =>
                        value!.isEmpty ? 'Email cant be empty' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('Email'),
                        hintText: 'Enter email'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Mobile number',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: phoneController,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'phone no. cant be empty' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('Mobile number'),
                        hintText: 'Enter number',
                        prefix: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '+973',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Nationality',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nationalityController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('Nationality'),
                        hintText: 'Enter nationality'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'National ID',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: nationalIdController,
                    validator: (value) =>
                        value!.isEmpty ? 'ID cant be empty' : null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('national ID'),
                        hintText: 'Enter CPR'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'DOB',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: dobController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Text('DOB'),
                        hintText: 'Enter dob'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            var data = {
                              'name': nameController.text,
                              'email': emailController.text,
                              'phone': phoneController.text,
                              'nationalID': nationalIdController.text,
                              'nationality': nationalityController.text,
                              'dob': dobController.text
                            };
                            await DbService().updateUserData(extraData: data);
                            Provider.of<UserProvider>(context, listen: false)
                                .loadUserdata();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Profile Updated')));
                          }
                        },
                        child: Text('Update Profile'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 23, 50, 97),
                            foregroundColor: Colors.white),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
