import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kids_republik/main.dart';

final collectionReference = FirebaseFirestore.instance.collection('BabyData');
class SlideshowScreen extends StatefulWidget {

  SlideshowScreen({key});

  @override
  _SlideshowScreenState createState() => _SlideshowScreenState();
}

class _SlideshowScreenState extends State<SlideshowScreen> {
  List<String> photoUrls = [];
  List<String> childNames = [];

  @override
  void initState() {
    super.initState();
    fetchChildData();
  }

  Future<void> fetchChildData() async {
    try {
      final babySnapshot = await FirebaseFirestore.instance
          .collection('BabyData')
          .where('fathersEmail', isEqualTo: useremail)
          .get();

      if (babySnapshot.docs.isNotEmpty) {
        final activitySnapshot = await FirebaseFirestore.instance
            .collection('Activity')
            .where('id', whereIn: babySnapshot.docs)
            .get();

        if (activitySnapshot.docs.isNotEmpty) {
          for (var doc in activitySnapshot.docs) {
            final List<String> names_ = List.from(doc.get('childFullName'));
            final List<String> photos = List.from(doc.get('image_'));
            photoUrls.addAll(photos);
            childNames.addAll(names_);
          }
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Activity Slideshow'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 010),
            child: StreamBuilder<QuerySnapshot>(
              stream: collectionReference
                  .where('fathersEmail', isEqualTo: useremail)
              // 'Todlers' )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: CircularProgressIndicator(),
                    ),
                  ); // Show loading indicator
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // return EmptyBackground(
                  //   title: 'Curently, No student is assigned this class',
                  // ); // No data
                }

                // Data is available, build the list
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 1.0, top: 1),
                      child: Divider(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    );
                  },
                  primary: false,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final childData = snapshot.data!.docs[index].data()
                    as Map<String, dynamic>;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Picture, Name and fathers name of child
                        Container(
                          width: mQ.width*0.18,
                          height: mQ.height*0.1,
                          child: Column(children: [
                            (childData['picture'] == '')
                                ? Image.asset(
                              'assets/staff.jpg',
                              //color: kprimary,
                              width: mQ.width * 0.12,
                              fit: BoxFit.contain,
                            )
                                : Image.network(
                              childData['picture'],
                              //color: kprimary,
                              width: mQ.width * 0.12,
                              fit: BoxFit.scaleDown,
                            ),
                            Text(
                              "${childData['childFullName']}  ${childData['fathersName']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87.withOpacity(0.7),
                                  fontSize: 10),
                            ),
                          ]),
                        ),
                        // Reports and consents
                        Container(
                          width: mQ.width*0.58,
                          height: mQ.height*0.1,
                          child: Row(
                            children: [

                            ],
                          ),
                        ),

                      ],
                    );
                  },
                );
              },
            ),
          ),

          // Text('${childNames}'),
          // Text('${photoUrls}'),
          // Center(
          //   child: photoUrls.isNotEmpty
          //       ? CarouselSlider(
          //     items: photoUrls
          //         .map((photoUrl) => Image.network(photoUrl))
          //         .toList(),
          //     options: CarouselOptions(
          //       height: 200,
          //       aspectRatio: 16 / 9,
          //       enlargeCenterPage: true,
          //       enableInfiniteScroll: false,
          //     ),
          //   )
          //       : Text('No photos found for the child.'),
          // ),
        ],
      ),
    );
  }
}
