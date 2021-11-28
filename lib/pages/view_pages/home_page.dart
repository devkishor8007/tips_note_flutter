import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tips_note_fluxfire/pages/view_pages/add_post.dart';
import 'package:tips_note_fluxfire/riverpod/post_user_riverpod.dart';
import 'package:tips_note_fluxfire/riverpod/sample_riverpod.dart';
import 'package:tips_note_fluxfire/utilis/routes.dart';
import 'package:tips_note_fluxfire/utilis/utilis.dart';
import 'package:tips_note_fluxfire/widget/drawer_widget.dart';
import 'package:tips_note_fluxfire/widget/textformfield_widget.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  String? currentuserName;
  String? userIds;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    final DocumentSnapshot userDocs = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .get();

    currentuserName = userDocs.get('name');
    userIds = userDocs.get('uid');

    setState(() {});
  }

  void getPostTitle() async {
    final DocumentSnapshot postDocs = await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.uid)
        .get();

    currentStus = postDocs.get('title');

    setState(() {});
  }

  String? currentStus;

  final TextEditingController _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read(appname),
        ),
      ),
      drawer: DrawerWidget(
        username: currentuserName ?? "",
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          push(
              context,
              AddPost(
                userId: user!.uid,
                username: currentuserName!,
              ));
        },
      ),
      body: Consumer(builder: (context, watch, child) {
        final getData = watch(getAllPostRiverpod);
        final crudData = watch(userPostRiverpod);

        return getData.when(
            data: (data) {
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final postData = data[index].date!.toDate();
                    currentStus = data[index].title!;
                    final date =
                        '${postData.year}-${postData.month}-${postData.day}';
                    return Card(
                      elevation: 10.0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.black,
                                ),
                                const SizedBox(
                                  width: 13,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data[index].postby ?? ""),
                                    Text(
                                      date,
                                      style: buildOtherTextStyle(
                                        context,
                                        fontsize: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .fontSize,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 5),
                                  child: widget.uid == data[index].uid
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.lightBlueAccent,
                                                blurRadius: 15.0,
                                              ),
                                            ],
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return Container(
                                                          height: 300,
                                                          color: Colors.grey,
                                                          child: Column(
                                                            children: [
                                                              buildTextFormFieldWidget(
                                                                controller:
                                                                    _title,
                                                                validator:
                                                                    (val) {
                                                                  if (val!
                                                                      .isEmpty) {
                                                                    return 'Invalid Status';
                                                                  }
                                                                  return null;
                                                                },
                                                                maxLines: 6,
                                                                maxLength: 500,
                                                                hintText:
                                                                    "Add Status",
                                                              ),
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  await crudData
                                                                      .updatePost(
                                                                    updateId: data[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    title: _title
                                                                        .text,
                                                                  );
                                                                  pop(context);
                                                                  _title
                                                                      .clear();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Edit"),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await crudData.deletePost(
                                                      data[index].id);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content:
                                                          Text('Delete post'),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(data[index].title ?? ""),
                            const SizedBox(
                              height: 12,
                            ),
                            data[index].photo == ''
                                ? const Text('')
                                : Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.deepPurpleAccent,
                                          blurRadius: 5.0,
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height / 2 -
                                            60,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      data[index].photo.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ],
                        ),

// widget.uid == data[index].uid
//                               ? Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade100,
//                                     boxShadow: const [
//                                       BoxShadow(
//                                         color: Colors.lightBlueAccent,
//                                         blurRadius: 15.0,
//                                       ),
//                                     ],
//                                     borderRadius: const BorderRadius.all(
//                                       Radius.circular(50),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                           Icons.edit,
//                                           size: 20,
//                                         ),
//                                       ),
//                                       IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                           Icons.delete,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : null

                        // subtitle: AnimatedSwitcher(
                        //   duration: const Duration(milliseconds: 500),
                        //   child: iscomment.isComment
                        //       ? Row(
                        //           children: [
                        //             Flexible(
                        //               flex: 3,
                        //               child: buildTextFormFieldWidget(
                        //                 controller: _comment,
                        //                 hintText: "Add comment",
                        //                 maxLines: 6,
                        //                 maxLength: 200,
                        //               ),
                        //             ),
                        //             Flexible(
                        //                 // flex: 1,
                        //                 child: Column(
                        //               children: [
                        //                 Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: MaterialButton(
                        //                     onPressed: () {
                        //                       try {
                        //                         final generatedId =
                        //                             const Uuid().v4();
                        //                         iscommentPost.insertUser(
                        //                             postname: "kishor",
                        //                             comment: _comment.text,
                        //                             uid: widget.uid,
                        //                             generatId: generatedId,
                        //                             postId: widget.uid);
                        //                         ScaffoldMessenger.of(context)
                        //                             .showSnackBar(
                        //                           const SnackBar(
                        //                             content: Text(
                        //                                 "Success Add comment"),
                        //                           ),
                        //                         );
                        //                         Navigator.pop(context);
                        //                       } catch (e) {
                        //                         e.toString();
                        //                       }
                        //                     },
                        //                     child: const Text("Post"),
                        //                   ),
                        //                 ),
                        //                 MaterialButton(
                        //                   onPressed: () {
                        //                     iscomment.cancelComment();
                        //                   },
                        //                   child: const Text("Cancel"),
                        //                 ),
                        //               ],
                        //             ))
                        //           ],
                        //         )
                        //       : TextButton.icon(
                        //           onPressed: () {
                        //             iscomment.cancelComment();
                        //           },
                        //           icon: const Icon(
                        //             Icons.comment,
                        //             color: Colors.grey,
                        //           ),
                        //           label: Text(
                        //             data[index].count.toString(),
                        //           ),
                        //         ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        // TextButton.icon(
                        //   onPressed: () {},
                        //   icon: const Icon(
                        //     Icons.thumb_up,
                        //     color: Colors.grey,
                        //   ),
                        //   label: Text(
                        //     data[index].count.toString(),
                        //   ),
                        // ),
                        // AnimatedSwitcher(
                        //   duration: const Duration(milliseconds: 500),
                        //   child: iscomment.isComment
                        //       ? Row(
                        //           children: [
                        //             Flexible(
                        //               flex: 3,
                        //               child: buildTextFormFieldWidget(
                        //                 controller: _comment,
                        //                 hintText: "Add comment",
                        //                 maxLines: 6,
                        //                 maxLength: 200,
                        //               ),
                        //             ),
                        //             Flexible(
                        //                 child: Column(
                        //               children: [
                        //                 Padding(
                        //                   padding:
                        //                       const EdgeInsets.all(8.0),
                        //                   child: MaterialButton(
                        //                     onPressed: () {
                        //                       try {
                        //                         final generatedId =
                        //                             const Uuid().v4();
                        //                         iscommentPost.insertUser(
                        //                             postname: "kishor",
                        //                             comment: _comment.text,
                        //                             uid: widget.uid,
                        //                             generatId: generatedId,
                        //                             postId: widget.uid);
                        //                         ScaffoldMessenger.of(
                        //                                 context)
                        //                             .showSnackBar(
                        //                           const SnackBar(
                        //                             content: Text(
                        //                                 "Success Add comment"),
                        //                           ),
                        //                         );
                        //                       } catch (e) {
                        //                         e.toString();
                        //                       }
                        //                     },
                        //                     child: const Text("Post"),
                        //                   ),
                        //                 ),
                        //                 MaterialButton(
                        //                   onPressed: () {
                        //                     iscomment.cancelComment();
                        //                   },
                        //                   child: const Text("Cancel"),
                        //                 ),
                        //               ],
                        //             ))
                        //           ],
                        //         )
                        //       : TextButton.icon(
                        //           onPressed: () {
                        //             iscomment.cancelComment();
                        //           },
                        //           icon: const Icon(
                        //             Icons.comment,
                        //             color: Colors.grey,
                        //           ),
                        //           label: Text(
                        //             data[index].count.toString(),
                        //           ),
                        //         ),
                      ),
                    );
                  });
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stackTrace) => Container());
      }),
    );
  }
}
