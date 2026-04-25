import 'package:flutter/material.dart';
import 'package:sign_up_in/component/color.dart';
import 'package:sign_up_in/page/profile/profile_setting.dart';
import 'package:sign_up_in/services/api_service.dart';
import 'package:sign_up_in/services/session_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<Map<String, dynamic>> _loadProfile() async {
    final userId = await SessionService.getUserId();
    if (userId == null) {
      throw Exception('Chua co session dang nhap.');
    }

    final profile = await ApiService.getProfile(userId);
    await SessionService.saveUser(profile);
    return profile;
  }

  Widget _buildPhotoCard(
    String imagePath, {
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Text(
                'Khong the tai profile.\n${snapshot.error ?? ''}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final profile = snapshot.data!;
        final photos = List<Map<String, dynamic>>.from(
          profile['myPhotos'] as List? ?? const [],
        );
        final avatarImage =
            profile['avatarImage'] as String? ?? 'assets/profile/profile2.png';

        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                centerTitle: true,
                pinned: false,
                expandedHeight: 170,
                clipBehavior: Clip.none,
                floating: true,
                flexibleSpace: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: EdgeInsets.zero,
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/profile/profile1.png',
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    final updatedProfile = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProfileSetting(profile: profile),
                                      ),
                                    );
                                    if (updatedProfile is Map<String, dynamic>) {
                                      setState(() {
                                        _profileFuture =
                                            Future<Map<String, dynamic>>.value(
                                              updatedProfile,
                                            );
                                      });
                                    } else {
                                      setState(() {
                                        _profileFuture = _loadProfile();
                                      });
                                    }
                                  },
                                ),
                                SizedBox(height: 20),
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 15,
                      bottom: -70,
                      child: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(avatarImage),
                              ),
                              Positioned(
                                left: 40,
                                bottom: -10,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  profile['username'] as String? ?? '',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  profile['email'] as String? ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(top: 100),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My Photos",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_double_arrow_right,
                                size: 24,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 14),
                        if (photos.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Khong co anh profile.'),
                          )
                        else
                          SizedBox(
                            height: 250,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    for (var i = 0; i < photos.take(3).length; i++)
                                      Expanded(
                                        child: _buildPhotoCard(
                                          photos[i]['image'] as String? ?? '',
                                          height: 123,
                                          margin: EdgeInsets.only(
                                            left: i == 0 ? 0 : 8,
                                            right:
                                                i == photos.take(3).length - 1
                                                ? 0
                                                : 8,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                if (photos.length > 3)
                                  Expanded(
                                    child: _buildPhotoCard(
                                      photos[3]['image'] as String? ?? '',
                                      height: 130,
                                      width: double.infinity,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
