import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

//   data.map((image) => image['urls']['regular']): Here,
//   we are using the map method on the data list.
//   This method applies a transformation function to each element of the list and
//   returns a new iterable with the transformed values.
//   In our case, for each image object in the data list, we are accessing the 'urls' key and
//   then the 'regular' key to retrieve the URL of the regular-sized image.

//  .toList(): The toList method is used to convert the iterable returned by map into a list.
//   Since imageUrls is of type List<String>, we need to convert the iterable of URLs into a list.

//  .cast<String>(): The cast method is used to cast the elements of the list to a specific type.
//  In this case, we want to ensure that each element in the list is of type String.
//  Although we retrieved URLs from the data map, they are stored as dynamic objects due to the nature of the jsonDecode function.
//  Therefore, we cast each element to String to ensure the imageUrls list contains only strings.

//  Finally, we assign the resulting list of URLs to the imageUrls variable.

  Future<void> fetchImages() async {
    final response = await http.get(
        Uri.parse('https://api.unsplash.com/photos/random?count=10'),
        headers: {
          'Authorization':
              'Client-ID 1wIzBUP53DChMkRil4WWzJyMKrqdc9JbSyOH2SUFNbI',
        });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        imageUrls = data
            .map((image) => image['urls']['regular'])
            .toList()
            .cast<String>();
      });
    } else {
      print('Failed to fetch images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return const AppDrawer();
        //         },
        //       ),
        //     );
        //   },
        //   icon: const Icon(
        //     Icons.menu,
        //     color: Colors.black,
        //   ),
        // ),
        title: const Text(
          'Unsplash Images',
          style: TextStyle(
            color: Color.fromARGB(255, 16, 2, 206),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Type to Search',
                  border: OutlineInputBorder(),
                  icon: Icon(
                    Icons.search,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1.5,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const MyLogin();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
