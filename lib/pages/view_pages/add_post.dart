import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tips_note_fluxfire/riverpod/post_user_riverpod.dart';
import 'package:tips_note_fluxfire/utilis/routes.dart';

import 'package:tips_note_fluxfire/widget/materialbutton_widget.dart';
import 'package:tips_note_fluxfire/widget/textformfield_widget.dart';
import 'package:uuid/uuid.dart';

final boolRiverpod = StateProvider<bool>((ref) => false);

class AddPost extends StatefulWidget {
  final String userId;
  final String username;
  const AddPost({
    Key? key,
    required this.userId,
    required this.username,
  }) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _title = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final _isLoadingData = watch(boolRiverpod).state;
          final _userPost = watch(userPostRiverpod);
          return Form(
            key: _key,
            child: ListView(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          height: 80,
                          width: 80,
                          child: Image.network(
                            "https://images.unsplash.com/photo-1545945856-794513f16ac6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=387&q=80",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 3,
                      top: 0,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.upload,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                buildTextFormFieldWidget(
                  controller: _title,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Invalid Status';
                    }
                    return null;
                  },
                  maxLines: 6,
                  maxLength: 500,
                  hintText: "Add Status",
                ),
                const SizedBox(
                  height: 10,
                ),
                _isLoadingData
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : buildMaterialButton(
                        child: const Text("Add Post"),
                        onPressed: () async {
                          final taskId = const Uuid().v4();
                          final isValid = _key.currentState!.validate();
                          if (!isValid) {
                            return;
                          } else {
                            context.read(boolRiverpod).state = true;
                            _key.currentState!.save();
                            await _userPost.insertPost(
                              title: _title.text,
                              photo: '',
                              comment: '',
                              uid: widget.userId,
                              postby: widget.username,
                              postId: taskId,
                            );
                            pop(context);
                            context.read(boolRiverpod).state = false;
                          }
                        }),
              ],
            ),
          );
        },
      ),
    );
  }
}
