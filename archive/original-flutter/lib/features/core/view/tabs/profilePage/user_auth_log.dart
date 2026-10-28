// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/firebase_constants.dart';
import 'package:explorer/misc/state_widgets.dart';

class UserAuthLogPage extends ConsumerWidget {
  const UserAuthLogPage({Key? key, required this.userData}) : super(key: key);
  

  final AuthLogData userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          title:  Text(userData.name),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream:
                FBC.loginCollection.where('user', isEqualTo: userData.uid).snapshots(),
            builder: (context, snap) {
              if (snap.hasData) {
                final data = snap.data!.docs;
                if (data.isNotEmpty) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final user = data[index].data();
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Neumorphic(
                          padding: EdgeInsets.all(20.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['type'] == 0 ? 'Login' : 'Logout',
                                style: KEltTextStyle.blackTitleText,
                              ),
                              AppSpacerH(10.h),
                              Text(
                                DateFormat.yMd().add_jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        user['time'] as int,
                                      ),
                                    ),
                                style: KEltTextStyle.subtitleText,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No Log Found'),
                  );
                }
              } else {
                return const Center(
                  child: Text('Error'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class AuthLogData {
  final String name;
  final String uid;
  AuthLogData({
    required this.name,
    required this.uid,
  });
}
