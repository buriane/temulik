import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temulik/constants/colors.dart';

class TabLeaderBoard extends StatelessWidget {
  final String tab1;
  final String tab2;
  final Widget page1;
  final Widget page2;

  const TabLeaderBoard({
    super.key,
    required this.tab1,
    required this.tab2,
    required this.page1,
    required this.page2,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: AppColors.green,
            indicatorWeight: 3,
            labelColor: AppColors.green,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: tab1),
              Tab(text: tab2),
            ],
          ),
          title: const Center(child: Text('Leaderboard')),
          elevation: 0,
        ),
        body: TabBarView(
          children: [page1, page2],
        ),
      ),
    );
  }
}

class LeaderboardCard extends StatelessWidget {
  static const double _borderRadius = 6.0;
  static const double _padding = 12.0;
  static const double _avatarRadius = 20.0;

  final int rank;
  final String name;
  final String faculty;
  final int points;
  final String image;
  final VoidCallback? onTap;

  const LeaderboardCard({
    super.key,
    required this.rank,
    required this.name,
    required this.faculty,
    required this.points,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          _buildCardContent(),
          _buildWatermark(),
        ],
      ),
    );
  }

  Widget _buildCardContent() {
    return Container(
      decoration: _buildCardDecoration(),
      padding: const EdgeInsets.symmetric(
        horizontal: _padding,
        vertical: 6.0,
      ),
      margin: const EdgeInsets.only(
        top: 6.0,
        left: 6.0,
        right: 6.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildUserInfo(),
          _buildPointsDisplay(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        RankDisplay(rank: rank),
        const SizedBox(width: _padding),
        _buildAvatar(),
        const SizedBox(width: _padding),
        _buildNameAndFaculty(),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.coral,
          width: 2.0,
        ),
      ),
      child: CircleAvatar(
        radius: _avatarRadius,
        backgroundImage: AssetImage(image),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildNameAndFaculty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StrokedText(
          text: name.length > 20 ? name.substring(0, 20) + '...' : name,
          fontSize: 16.0,
        ),
        Text(
          faculty,
          style: const TextStyle(
            fontSize: 12.00,
            color: AppColors.coral,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPointsDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 3.0,
      ),
      decoration: _buildPointsDecoration(),
      child: Center(
        child: StrokedText(
          text: points.toString(),
          fontSize: 20.0,
          textColor: AppColors.lavender,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildWatermark() {
    return Positioned(
      bottom: 0.5,
      right: 115.0,
      child: SvgPicture.asset(
        'soedirman.svg',
        height: 50.0,
        colorFilter: ColorFilter.mode(
          AppColors.sky,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.black,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(_borderRadius),
      gradient: const LinearGradient(
        colors: [
          Color(0xFFDDE6F7),
          Color(0xFFC9D6E9),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  BoxDecoration _buildPointsDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFF8D9EB8),
          Color(0xFFA1B1C8),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(4.0),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
        ),
        BoxShadow(
          color: Colors.black,
          spreadRadius: -16.0,
          blurRadius: 20.0,
        ),
      ],
    );
  }
}

class RankDisplay extends StatelessWidget {
  final int rank;

  const RankDisplay({
    super.key,
    required this.rank,
  });

  List<Color> _getRankColors() {
    switch (rank) {
      case 1:
        return [
          AppColors.gold,
          const Color(0xFFF8DE79),
          const Color(0xFFEEBF33)
        ];
      case 2:
        return [
          AppColors.silver,
          const Color(0xFFE2EAF7),
          const Color(0xFFCFDBEC)
        ];
      case 3:
        return [
          AppColors.bronze,
          const Color(0xFFEDA367),
          const Color(0xFFDF9355)
        ];
      default:
        return [
          AppColors.darkGrey,
          const Color(0xFFA1B1C8),
          const Color(0xFF8D9EB8)
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getRankColors();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          width: 2.0,
          color: AppColors.sky,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 3.0,
        ),
        decoration: BoxDecoration(
          color: colors[0],
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            width: 2.0,
            color: colors[2],
          ),
          gradient: LinearGradient(
            colors: [colors[1], colors[2]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: StrokedText(
            text: rank.toString(),
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}

class StrokedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;

  const StrokedText({
    super.key,
    required this.text,
    required this.fontSize,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3.0
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
