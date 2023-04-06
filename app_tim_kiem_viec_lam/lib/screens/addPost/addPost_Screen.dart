import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:app_tim_kiem_viec_lam/core/models/model.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/authenciation_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/providers/job_category_provider.dart';
import 'package:app_tim_kiem_viec_lam/core/supabase/supabase.dart';
import 'package:app_tim_kiem_viec_lam/screens/addPost/map.dart';
import 'package:app_tim_kiem_viec_lam/screens/selectJob/selectJob_screen.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart' as p;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/models/user_model.dart';
import '../../core/providers/post_provider.dart';
import '../../core/providers/user_provider.dart';
import '../../utils/postValidator.dart';
import '../../widgets/profile_widget.dart';
import '../../widgets/textfiled_widget.dart';

class AddPostScreen extends StatefulWidget {
  AddPostScreen({super.key, this.user});
  UserModel? user;
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

final ImagePicker _picker = ImagePicker();
final List<XFile> images1 = [];

// Future<void> _getImagesFromGallery(AppLocalizations appLocalization) async {
//   try {
//     final List<XFile>? pickedPhotos = await _picker.pickMultiImage();

//     if (pickedPhotos != null && canAttachImage()) {
//       setState(() {
//         images.addAll((pickedPhotos.length + getImageCount()) > maxImages
//             ? pickedPhotos.take(maxImages - getImageCount())
//             : pickedPhotos);

//         mainImageId ??= pickedPhotos[0].name;
//       });
//     }
//   } catch (error) {
//     context.showErrorSnackBar(message: appLocalization.unexpected_error);
//   }
// }

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();

  late UserProvider userProvider;
  late PostProvider jobProvider;
  // File? _file;
  String? _pathFile;
  XFile? _imageFile;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    userProvider = p.Provider.of<UserProvider>(context, listen: false);
    jobProvider = p.Provider.of<PostProvider>(context, listen: false);
  }

  Future<void> handlePostImage(dynamic imageFile) async {
    final prefs = await SharedPreferences.getInstance();

    PostModel newPost;
    if (imageFile == null) {
      PostModel newPost = PostModel(
        userId: prefs.getString('id').toString(),
        caption: _descriptionController.text.toString(),
        category_job: jobProvider.selectedOption!.jobName.toString(),
        location: jobProvider.address,
        imageurl: "",
        latitude: jobProvider.latitude!.toDouble(),
        longitude: jobProvider.longitude!.toDouble(),
      );
      jobProvider.insertPost(context, newPost);
    }

    try {
      Random random = new Random();
      int randomNumber = random.nextInt(100);
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.name.split('.').last;
      final fileName =
          '${prefs.getString('id')}/${randomNumber}_${imageFile.name}';
      final filePath = fileName;
      await SupabaseBase.supabaseClient.storage.from('post').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );
      final imageUrlResponse = await SupabaseBase.supabaseClient.storage
          .from('post')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      if (imageUrlResponse != null) {
        newPost = PostModel(
          userId: prefs.getString('id').toString(),
          caption: _descriptionController.text.toString(),
          category_job: jobProvider.selectedOption!.jobName.toString(),
          location: jobProvider.address,
          imageurl: imageUrlResponse,
          latitude: jobProvider.latitude!.toDouble(),
          longitude: jobProvider.longitude!.toDouble(),
          // longitude: double.parse(jobProvider.longitude),
          // latitude: jobProvider.latitude,
          // longitude: jobProvider.longitude,
        );
        jobProvider.insertPost(context, newPost);
      }
    } on StorageException catch (error) {
      print(error);
    }
  }

  // _selectImage(BuildContext parentContext) async {
  //   return showDialog(
  //     context: parentContext,
  //     builder: (BuildContext context) {
  //       return SimpleDialog(
  //         title: const Text('Create a Post'),
  //         children: <Widget>[
  //           SimpleDialogOption(
  //               padding: const EdgeInsets.all(20),
  //               child: const Text('Take a photo'),
  //               onPressed: () async {
  //                 final picker = ImagePicker();
  //                 var imageFile = await picker.pickImage(
  //                   source: ImageSource.camera,
  //                   maxWidth: 300,
  //                   maxHeight: 300,
  //                 );
  //                 Navigator.pop(context);

  //                 setState(() {
  //                   // _file = File(imageFile!.path);
  //                   _imageFile = imageFile;
  //                   // _file = File(imageFile);
  //                 });
  //               }),
  //           SimpleDialogOption(
  //               padding: const EdgeInsets.all(20),
  //               child: const Text('Choose from Gallery'),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 final picker = ImagePicker();
  //                 var imageFile = await picker.pickImage(
  //                   source: ImageSource.gallery,
  //                   maxWidth: 300,
  //                   maxHeight: 300,
  //                 );
  //                 setState(() {
  //                   _file = File(imageFile!.path);
  //                   imageFile = imageFile;
  //                 });
  //               }),
  //           SimpleDialogOption(
  //             padding: const EdgeInsets.all(20),
  //             child: const Text("Cancel"),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget build(BuildContext context) {
    final imageProvider = p.Provider.of<PostProvider>(context);
    final provider = p.Provider.of<AuthenciationNotifier>(context);

    return Scaffold(
      body: Stack(children: [
        CustomScrollView(
          slivers: [
            SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: _MyHeader(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            buttonArrow(context),
                            Text(
                              "Thêm bài viết",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        Spacer(),
                        p.Consumer<PostProvider>(
                          builder: (context, jobProvider, _) {
                            return GestureDetector(
                              onTap: () {
                                if (jobProvider.address == null) {
                                  PostValidator.validateJobAddress();
                                  return;
                                } else if (jobProvider.selectedOption == null) {
                                  PostValidator.validateJobTarget("");
                                  return;
                                }
                                handlePostImage(_imageFile);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: HexColor("#ffffff"),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text(
                                  "Đăng",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                      ]),
                )),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                height: MediaQuery.of(context).size.height * 0.71,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      p.Consumer<UserProvider>(
                        builder: (context, userProvider, _) {
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  userProvider.user!.imageUrl == null
                                      ? (CircleAvatar(
                                          radius: 35,
                                          backgroundColor: HexColor("#BB2649"),
                                          child: Text(
                                              "${userProvider.user?.name.toString().substring(0, 1).toUpperCase()}",
                                              style: TextStyle(fontSize: 40))))
                                      : CircleAvatar(
                                          radius: 35,
                                          backgroundColor: HexColor("#BB2649"),
                                          backgroundImage: NetworkImage(
                                              "${userProvider.user!.imageUrl}"),
                                        ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${userProvider.user!.fullname == null ? userProvider.user!.name : userProvider.user!.fullname}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        p.Consumer<PostProvider>(
                                          builder: (context,
                                              jobCategoryProvider, _) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelectJobScreen()));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color:
                                                          HexColor("#BB2649"),
                                                      style: BorderStyle.solid,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                child: Row(children: [
                                                  Icon(
                                                    Icons.work,
                                                    size: 13,
                                                  ),
                                                  Text(
                                                    '${jobCategoryProvider.selectedOption == null ? "Ngành nghề" : jobCategoryProvider.selectedOption!.jobName}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13),
                                                  ),
                                                  Icon(
                                                      Icons
                                                          .keyboard_arrow_down_rounded,
                                                      size: 13),
                                                ]),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       width: 1,
                      //       color: Colors.black,
                      //       style: BorderStyle.none,
                      //     ),
                      //   ),
                      //   height: MediaQuery.of(context).size.width * 0.5,
                      //   width: MediaQuery.of(context).size.width * 0.9,
                      //   // color: HexColor("#BB2649"),
                      //   child: _file == null
                      //       ? Center(
                      //           child: IconButton(
                      //             icon: const Icon(
                      //               Icons.upload,
                      //             ),
                      //             onPressed: () => {_selectImage(context)},
                      //           ),
                      //         )
                      //       : Container(
                      //           child: Image.network(_file!.path),
                      //         ),
                      // ),
                      Consumer<PostProvider>(
                        builder: (context, PostProvider, _) {
                          return jobProvider.address != null
                              ? Container(
                                  child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      "assets/icons/location1.png",
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "${jobProvider.address}",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ))
                              : Container();
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                              hintText: "Nội dung bài viết...",
                              border: InputBorder.none),
                          maxLines: 8,
                        ),
                      ),
                      _imageFile != null
                          ?

                          // Image.network(
                          //     "http://hanoimoi.com.vn/Uploads/tuandiep/2018/4/8/1(1).jpg")
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(File(_imageFile!.path),
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width * 1),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ]))
          ],
        ),
        scrollSelectPost(context)
      ]),
    );
  }

  scrollSelectPost(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      maxChildSize: 0.32,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: HexColor("#BB2649"),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OpenStreetMap(
                                    isSeen: false,
                                  )));
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/icons/location.png',
                            width: 40, height: 40),
                        SizedBox(width: 13.0),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Địa điểm làm việc',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                '*(Địa điểm để giúp ứng viên tìm được nơi làm việc phù hợp.!)',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[200],
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // final picker = ImagePicker();
                      // final imageFile = await picker.pickMultiImage(
                      //   maxWidth: 1200,
                      //   maxHeight: 1200,
                      //   // imageQuality: 100
                      // );
                      // setState(() {
                      //   images1.addAll(imageFile);
                      //   print(images1.map((e) => e.name));
                      //   // _file = File(imageFile!.path);
                      //   // _file = File(imageFile);
                      // });

                      final picker = ImagePicker();
                      final imageFile = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 1200,
                        maxHeight: 1200,
                      );

                      setState(() {
                        _imageFile = imageFile;
                        // _file = File(imageFile!.path);
                        // _file = File(imageFile);
                      });
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/icons/add_image.png',
                            width: 40, height: 40),
                        SizedBox(width: 13.0),
                        Text(
                          'Ảnh/video',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final imageFile = await picker.pickImage(
                        source: ImageSource.camera,
                        maxWidth: 1200,
                        maxHeight: 1200,
                      );

                      setState(() {
                        _imageFile = imageFile;
                        // _file = File(imageFile!.path);
                        // _file = File(imageFile);
                      });
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/icons/camera1.png',
                            width: 40, height: 40),
                        SizedBox(width: 13.0),
                        Text(
                          'Camera',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  buttonArrow(BuildContext context) {
    PostProvider jobCategory =
        p.Provider.of<PostProvider>(context, listen: false);
    return Padding(
        padding: const EdgeInsets.only(right: 5, top: 20, bottom: 20),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            jobCategory.setSelectedOption = null;
          },
          child: Container(
              clipBehavior: Clip.hardEdge,
              height: 55,
              width: 55,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ));
  }
}

class _MyHeader extends SliverPersistentHeaderDelegate {
  _MyHeader({required this.child});

  final Widget child;

  @override
  double get minExtent => 80.0;

  @override
  double get maxExtent => 80.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      color: HexColor("#BB2649").withOpacity(1),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_MyHeader oldDelegate) {
    return false;
  }
}
