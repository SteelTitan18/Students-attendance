import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_detector/focus_detector.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Navigation Basics',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getUserInformations();
  }

  String _userInfos = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        getUserInformations();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Accueil'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 50),
                  child: QrImage(
                data: _userInfos,
                version: QrVersions.auto,
                size: 250.0,
              )),
              TextFormField(
                controller: _lastnameController,
                decoration: const InputDecoration(
                  hintText: 'Entrer votre nom',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration (
                  hintText: 'Entrer vos prenoms',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _matriculeController,
                decoration: const InputDecoration(
                  hintText: 'Entrer votre numero matricule',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              Container(
                padding: const EdgeInsets.all(32),
                child: ElevatedButton(
                  onPressed: () {
                    saveUserInformations();
                    getUserInformations();
                  },
                  child: const Text('Enregistrer'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getUserInformations() async {
    final prefs = await SharedPreferences.getInstance();
    final firstname = prefs.getString('firstname') ?? '';
    final lastname = prefs.getString('lastname') ?? '';
    final matricule = prefs.getString('matricule') ?? '';
    setState(() {
      _userInfos = '$matricule $lastname $firstname';
    });
  }

  Future saveUserInformations() async {
    final String matricule = _matriculeController.text.toString();
    final String firstname = _firstnameController.text.toString();
    final String lastname = _lastnameController.text.toString();

    if (lastname.isEmpty || firstname.isEmpty || matricule.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("matricule", matricule);
    prefs.setString("lastname", lastname);
    prefs.setString("firstname", firstname);
  }
}