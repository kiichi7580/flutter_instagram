import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.messenger_outline,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            // snapshot.data を使用して処理...
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => Container(
                child: PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              ),
            );
          } else {
            // データがまだ読み込まれていない場合の処理...
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // return ListView.builder(
          //   itemCount: snapshot.data!.docs.length,
          //   itemBuilder: (context, index) => PostCard(
          //     snap: snapshot.data!.docs[index].data(),
          //   ),
          // );
        },
      ),
    );
  }
}
