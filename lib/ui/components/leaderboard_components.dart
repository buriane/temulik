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
          title: const Center(
            child: Text(
              'Leaderboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
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
          // _buildWatermark(),
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
        backgroundImage: NetworkImage(image),
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
          style: TextStyle(
            fontSize: 12.0,
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
      width: 60.0,
      decoration: _buildPointsDecoration(),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: StrokedText(
              text: points.toString(),
              fontSize: 20.0,
              textColor: AppColors.lavender,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
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
      border: Border.all(
        color: AppColors.sky,
        width: 2.0,
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          spreadRadius: -16.0,
          blurRadius: 20.0,
        ),
      ],
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
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          width: 2.0,
          color: AppColors.sky,
        ),
      ),
      child: Container(
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
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: StrokedText(
                text: rank.toString(),
                fontSize: 20.0,
              ),
            ),
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
  final Color strokeColor;
  final double strokeWidth;
  final FontWeight fontWeight;

  const StrokedText({
    super.key,
    required this.text,
    required this.fontSize,
    this.textColor = Colors.white,
    this.strokeColor = Colors.black,
    this.strokeWidth = 3.0,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StrokeTextPainter(
        text: text,
        fontSize: fontSize,
        textColor: textColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        fontWeight: fontWeight,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.transparent,
          fontWeight: fontWeight,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class StrokeTextPainter extends CustomPainter {
  final String text;
  final double fontSize;
  final Color textColor;
  final Color strokeColor;
  final double strokeWidth;
  final FontWeight fontWeight;

  StrokeTextPainter({
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.strokeColor,
    required this.strokeWidth,
    required this.fontWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = strokeColor,
    );

    final textStyle2 = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    final textPainter2 = TextPainter(
      text: TextSpan(text: text, style: textStyle2),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();

    textPainter.paint(canvas, Offset.zero);
    textPainter2.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
