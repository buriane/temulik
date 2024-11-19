import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temulik/constants/colors.dart';

class TabLeaderBoard extends StatefulWidget {
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
  State<TabLeaderBoard> createState() => _TabLeaderBoardState();
}

class _TabLeaderBoardState extends State<TabLeaderBoard> {
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
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: widget.tab1),
              Tab(text: widget.tab2),
            ],
          ),
          title: const Center(child: Text('Leaderboard')),
          elevation: 0,
        ),
        body: TabBarView(
          children: [
            widget.page1,
            widget.page2,
          ],
        ),
      ),
    );
  }
}

class LeaderboardCard extends StatefulWidget {
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
  State<LeaderboardCard> createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(6.0),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDDE6F7),
                  Color(0xFFC9D6E9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            margin: EdgeInsets.only(
              top: 6.0,
              left: 6.0,
              right: 6.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Rank(rank: widget.rank),
                    SizedBox(width: 12.00),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.coral,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: AssetImage(widget.image),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12.00),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 16.00,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 3.0
                                  ..color = Colors.black,
                              ),
                            ),
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 16.00,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.faculty,
                          style: TextStyle(
                            fontSize: 12.00,
                            color: AppColors.coral,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF8D9EB8),
                        Color(0xFFA1B1C8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black,
                      ),
                      const BoxShadow(
                        color: Colors.black,
                        spreadRadius: -16.0,
                        blurRadius: 20.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          widget.points.toString(),
                          style: TextStyle(
                            fontSize: 20.00,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 3.0
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          widget.points.toString(),
                          style: TextStyle(
                            fontSize: 20.00,
                            fontWeight: FontWeight.w800,
                            color: AppColors.lavender,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
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
          ),
        ],
      ),
    );
  }
}

class Rank extends StatelessWidget {
  final rank;
  const Rank({
    super.key,
    required this.rank,
  });

  List<Color> rankColor() {
    switch (rank) {
      case 1:
        return [AppColors.gold, Color(0xFFF8DE79), Color(0xFFEEBF33)];
      case 2:
        return [AppColors.silver, Color(0xFFE2EAF7), Color(0xFFCFDBEC)];
      case 3:
        return [AppColors.bronze, Color(0xFFEDA367), Color(0xFFDF9355)];
      default:
        return [AppColors.darkGrey, Color(0xFFA1B1C8), Color(0xFF8D9EB8)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            width: 2.0,
            color: AppColors.sky,
            style: BorderStyle.solid,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 3.0,
          ),
          decoration: BoxDecoration(
            color: rankColor()[0],
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              width: 2.0,
              color: rankColor()[2],
              style: BorderStyle.solid,
            ),
            gradient: LinearGradient(
              colors: [
                rankColor()[1],
                rankColor()[2],
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  rank.toString(),
                  style: TextStyle(
                    fontSize: 20.00,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3.0
                      ..color = Colors.black,
                  ),
                ),
                Text(
                  rank.toString(),
                  style: TextStyle(
                    fontSize: 20.00,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
