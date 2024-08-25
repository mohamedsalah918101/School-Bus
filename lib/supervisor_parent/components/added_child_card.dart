import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class AddedChildCard extends StatefulWidget {
  const AddedChildCard({super.key});

  @override
  State<AddedChildCard> createState() => _AddedChildCardState();
}

class _AddedChildCardState extends State<AddedChildCard> {
  final _firestore = FirebaseFirestore.instance;
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchSecondUserData();
  }

  Future<Map<String, dynamic>> _fetchSecondUserData() async {
    try {
      final userDoc = await _firestore
          .collection('parent')
          .doc(sharedpref!.getString('id'))
          .get();
      if (userDoc.exists) {
        return {
          'name': userDoc['secondParentName'],
          'phoneNumber': userDoc['secondParentNumber'],
          'imageUrl': userDoc['secondParentImage'],
        };
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Container());
        } else if (snapshot.hasError) {
          return Center(child: Container());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final data = snapshot.data!;
          return SizedBox(
            width: double.infinity,
            height: 90,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  width: 1,
                  color: const Color(0xFF432B72),
                ),
              ),
              child: Padding(
                padding: (sharedpref?.getString('lang') == 'ar')
                    ? const EdgeInsets.only(top: 17.0, right: 12)
                    : const EdgeInsets.only(top: 17.0, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildUserImage(data['imageUrl']),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: const Color(0xFF432B72),
                                    fontSize: 17,
                                    fontFamily: 'Poppins-SemiBold',
                                    fontWeight: FontWeight.w600,
                                    height: 0.94,
                                  ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/call_icon.png',
                                    width: 12,
                                    height: 12,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    data['phoneNumber'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: const Color(0xFF919191),
                                          fontSize: 12,
                                          fontFamily: 'Poppins-Light',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: Container());
        }
      },
    );
  }

  Widget _buildUserImage(String imageUrl) {
    return imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            height: 50,
            width: 50,
          )
        : Image.asset(
            'assets/images/add_additional_data.png',
            height: 50,
            width: 50,
          );
  }
}
