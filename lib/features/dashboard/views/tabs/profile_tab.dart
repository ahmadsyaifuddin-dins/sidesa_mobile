import 'package:flutter/material.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_info_card.dart';
import '../widgets/profile/profile_menu_card.dart';
import '../widgets/profile/profile_logout_button.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // HAPUS backgroundColor: Colors.grey[50] agar otomatis ngikutin ThemeConfig
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            SizedBox(height: 20),
            ProfileInfoCard(),
            SizedBox(height: 25),
            ProfileMenuCard(),
            SizedBox(height: 30),
            ProfileLogoutButton(),
            SizedBox(height: 130), 
          ],
        ),
      ),
    );
  }
}