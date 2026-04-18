import 'package:flutter/material.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_info_card.dart';
import '../widgets/profile/profile_menu_card.dart';
import '../widgets/profile/profile_logout_button.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: const [
            ProfileHeader(),
            SizedBox(height: 20),
            ProfileInfoCard(),
            SizedBox(height: 25),
            ProfileMenuCard(),
            SizedBox(height: 30),
            ProfileLogoutButton(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}