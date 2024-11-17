import 'package:flutter/material.dart';
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
  const LeaderboardCard({super.key});

  @override
  State<LeaderboardCard> createState() => _LeaderboardCardState();
}

// class _LeaderboardCardState extends State<LeaderboardCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.black,
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.circular(6.0),
//         gradient: LinearGradient(
//           colors: [
//             Color(0xFFDDE6F7),
//             Color(0xFFC9D6E9),
//           ],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       padding: EdgeInsets.symmetric(
//         horizontal: 12.0,
//         vertical: 6.0,
//       ),
//       margin: EdgeInsets.only(
//         top: 6.0,
//         left: 6.0,
//         right: 6.0,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(4.0),
//                   border: Border.all(
//                     width: 2.0,
//                     color: AppColors.sky,
//                     style: BorderStyle.solid,
//                   ),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12.0,
//                     vertical: 3.0,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.gold,
//                     borderRadius: BorderRadius.circular(4.0),
//                     border: Border.all(
//                       width: 2.0,
//                       color: const Color(0xFFF8DE79),
//                       style: BorderStyle.solid,
//                     ),
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFFF8DE79),
//                         Color(0xFFEEBF33),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                   child: Center(
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         Text(
//                           "1",
//                           style: TextStyle(
//                             fontSize: 20.00,
//                             foreground: Paint()
//                               ..style = PaintingStyle.stroke
//                               ..strokeWidth = 3.0
//                               ..color = Colors.black,
//                           ),
//                         ),
//                         Text(
//                           "1",
//                           style: TextStyle(
//                             fontSize: 20.00,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12.00),
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: AppColors.coral,
//                     width: 2.0,
//                   ),
//                 ),
//                 child: CircleAvatar(
//                   radius: 20.0,
//                   backgroundImage: AssetImage('dzakwan.jpg'),
//                   backgroundColor: Colors.white,
//                 ),
//               ),
//               SizedBox(width: 12.00),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Text(
//                         "Dzakwan Irfan Ramdhani",
//                         style: TextStyle(
//                           fontSize: 16.00,
//                           foreground: Paint()
//                             ..style = PaintingStyle.stroke
//                             ..strokeWidth = 3.0
//                             ..color = Colors.black,
//                         ),
//                       ),
//                       Text(
//                         "Dzakwan Irfan Ramdhani",
//                         style: TextStyle(
//                           fontSize: 16.00,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     "FSRD",
//                     style: TextStyle(
//                       fontSize: 12.00,
//                       color: AppColors.coral,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           // SvgPicture.asset('soedirman.svg'),
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 3.0,
//             ),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF8D9EB8),
//                   Color(0xFFA1B1C8),
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(4.0),
//               boxShadow: [
//                 const BoxShadow(
//                   color: Colors.black,
//                 ),
//                 const BoxShadow(
//                   color: Colors.black,
//                   spreadRadius: -16.0,
//                   blurRadius: 20.0,
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Text(
//                     "390",
//                     style: TextStyle(
//                       fontSize: 20.00,
//                       foreground: Paint()
//                         ..style = PaintingStyle.stroke
//                         ..strokeWidth = 3.0
//                         ..color = Colors.black,
//                     ),
//                   ),
//                   Text(
//                     "390",
//                     style: TextStyle(
//                       fontSize: 20.00,
//                       fontWeight: FontWeight.w800,
//                       color: AppColors.lavender,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             right: 60,
//             child: SvgPicture.asset('soedirman.svg'),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _LeaderboardCardState extends State<LeaderboardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
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
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            width: 2.0,
                            color: const Color(0xFFF8DE79),
                            style: BorderStyle.solid,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFF8DE79),
                              Color(0xFFEEBF33),
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
                                "1",
                                style: TextStyle(
                                  fontSize: 20.00,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3.0
                                    ..color = Colors.black,
                                ),
                              ),
                              Text(
                                "1",
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
                  ),
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
                      backgroundImage: AssetImage('dzakwan.jpg'),
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
                            "Dzakwan Irfan Ramdhani",
                            style: TextStyle(
                              fontSize: 16.00,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3.0
                                ..color = Colors.black,
                            ),
                          ),
                          Text(
                            "Dzakwan Irfan Ramdhani",
                            style: TextStyle(
                              fontSize: 16.00,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "FSRD",
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
                        "390",
                        style: TextStyle(
                          fontSize: 20.00,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3.0
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        "390",
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
          Positioned(
            bottom: -5,
            right: 85.0,
            child: SvgPicture.asset('soedirman.svg', width: 50),
          ),
        ],
      ),
    );
  }
}
