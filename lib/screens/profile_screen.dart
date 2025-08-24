import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF3EBFD);
    const Color headingColor = Color(0xFF6F3FAF);
    const double headerHeight = 60;
    const double navBarHeight = 70;
    const double sidePadding = 18;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double availableHeight = screenHeight -
        headerHeight -
        navBarHeight -
        MediaQuery.of(context).padding.top;

    final double whiteContainerHeight = availableHeight + 22;

    final List<_ProfileTileData> tiles = [
      _ProfileTileData(
        assetIconPath: 'assets/Images/heart.png',
        text: 'My donation',
      ),
      _ProfileTileData(
        assetIconPath: 'assets/Images/bell.png',
        text: 'Donation reminder',
      ),
      _ProfileTileData(
        assetIconPath: 'assets/Images/key.png',
        text: 'Change password',
      ),
      _ProfileTileData(
        assetIconPath: 'assets/Images/setting.png',
        text: 'Settings',
      ),
      _ProfileTileData(
        assetIconPath: 'assets/Images/bell.png',
        text: 'Notifications',
      ),
      _ProfileTileData(
        assetIconPath: 'assets/Images/support.png',
        text: 'Help Center',
      ),
      _ProfileTileData(
        assetIconPath: 'assets/Images/feedback.png',
        text: 'Feedback',
      ),
      _ProfileTileData(
        assetIconPath: 'assets/Images/logout.png',
        text: 'Log Out',
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: headerHeight,
              color: backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: headingColor, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Account',
                      style: TextStyle(
                        color: headingColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: whiteContainerHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22),
                  bottom: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: sidePadding),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFEAEAEA),
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: Color(0xFFAB7DF6),
                          backgroundImage: AssetImage('assets/Images/avatar.png'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              "Name",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "email address",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF3EBFD),
                                  foregroundColor: Color(0xFFAB7DF6),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: Color(0xFFAB7DF6),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Divider(color: Colors.grey.shade200, thickness: 1),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double tileHeight = (constraints.maxHeight) / tiles.length;
                        if (tileHeight < 48) tileHeight = 48;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(tiles.length, (i) {
                            return SizedBox(
                              height: tileHeight,
                              child: _ProfileListTile(
                                assetIconPath: tiles[i].assetIconPath,
                                text: tiles[i].text,
                                onTap: () {
                                  // Do nothing on tap for now
                                },
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar removed as requested
    );
  }
}

class _ProfileTileData {
  final String assetIconPath;
  final String text;
  _ProfileTileData({required this.assetIconPath, required this.text});
}

class _ProfileListTile extends StatelessWidget {
  final String assetIconPath;
  final String text;
  final VoidCallback? onTap;

  const _ProfileListTile({
    super.key,
    required this.assetIconPath,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Image.asset(
                assetIconPath,
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 20),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}