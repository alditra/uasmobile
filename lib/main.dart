import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Character {
  final String id;
  final String name;
  final String school;
  final String birthday;
  final String photoUrl;
  final String image;
  final String imageSchool;
  final String damageType;

  Character({
    required this.id,
    required this.name,
    required this.school,
    required this.birthday,
    required this.photoUrl,
    required this.image,
    required this.imageSchool,
    required this.damageType,
  });
}

class CharacterListScreen extends StatefulWidget {
  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  List<Character> characters = [];

  Future<void> fetchCharacters() async {
    final response = await http
        .get(Uri.parse("https://api-blue-archive.vercel.app/api/characters"));
    final data = json.decode(response.body);

    if (response.statusCode == 200 && data["message"] == "success") {
      List<dynamic> characterData = data["data"];
      List<Character> characterList = characterData.map((character) {
        return Character(
          id: character["_id"],
          name: character["name"],
          school: character["school"],
          birthday: character["birthday"],
          photoUrl: character["photoUrl"],
          image: character["image"],
          imageSchool: character["imageSchool"],
          damageType: character["damageType"],
        );
      }).toList();

      setState(() {
        characters = characterList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Character List'),
      ),
      body: ListView.builder(
        itemCount: characters.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.network(characters[index].photoUrl),
              title: Text(characters[index].name),
              subtitle: Text(characters[index].school),
              onTap: () {
                // Handle character tap
              },
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CharacterListScreen(),
  ));
}
