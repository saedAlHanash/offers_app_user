import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:offers_awards/controllers/profile_controller.dart';
import 'package:offers_awards/screens/widgets/custom_image_picker.dart';
import 'package:offers_awards/screens/widgets/custom_light_text.dart';
import 'package:offers_awards/services/profile_services.dart';
import 'package:offers_awards/utils/app_ui.dart';
import 'package:offers_awards/utils/dimensions.dart';

class ProfileHeader extends StatefulWidget {
  final String profileImage;
  final String email;
  final String name;

  const ProfileHeader(
      {Key? key,
      required this.profileImage,
      required this.email,
      required this.name})
      : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _imageFile;
  ProfileController profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              //  _imageFile != null
              //     ? Image.file(
              //         _imageFile!,
              //         fit: BoxFit.cover,
              //       ).image
              //     :
              CachedNetworkImageProvider(
            widget.profileImage,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 2),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.3),
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.padding24,
            vertical: Dimensions.padding8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                title: const Text(
                  'البروفايل',
                  style: TextStyle(
                    color: AppUI.secondaryColor,
                  ),
                ),
                automaticallyImplyLeading: false,
                // leading: IconButton(
                //   onPressed: () {
                //     Get.to(() => const SettingsScreen());
                //   },
                //   icon: SvgPicture.asset(AppAssets.menu),
                // ),
              ),
              SizedBox(
                height: Dimensions.padding16 * 2,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      CustomImagePicker()
                          .pickImageByGallery(context: context)
                          .then((image) {
                        if (image != null ) {
                          ProfileServices.editImage(image).then((value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _imageFile = image;
                                profileController.editProfileImage(value);
                              });
                            }
                          });
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(Dimensions.padding8),
                          child: ClipRRect(
                            borderRadius: Dimensions.borderRadius50,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.width * 0.2,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppUI.greyCardColor,
                              ),
                              child: _imageFile != null
                                  ? Image.file(
                                      _imageFile!,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.2,
                                      fit: BoxFit.cover,
                                    )
                                  : widget.profileImage.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: widget.profileImage,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.person,
                                            color: AppUI.buttonTextColor,
                                            size: Dimensions.icon21,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          color: AppUI.buttonTextColor,
                                          size: Dimensions.icon21,
                                        ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: Dimensions.padding4,
                          top: Dimensions.padding4,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppUI.greyCardColor,
                            ),
                            padding: EdgeInsets.all(Dimensions.padding4),
                            child: const Icon(
                              Icons.edit,
                              color: AppUI.buttonTextColor,
                              size: Dimensions.icon16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.padding16,
                        horizontal: Dimensions.padding8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomLightText(
                          text: widget.name,
                          // fontSize: Dimensions.font14,
                        ),
                        SizedBox(height: Dimensions.padding4),
                        CustomLightText(
                          text: widget.email,
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.font14,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
