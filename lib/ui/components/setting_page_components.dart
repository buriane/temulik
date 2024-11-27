import 'package:flutter/material.dart';

class PengaturanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengaturan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Image.asset(
                  'assets/profile.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  "Profil",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: Image.asset('assets/forward.png',
                    width: 9, fit: BoxFit.contain),
                onTap: () {
                  // Tambahkan navigasi ke halaman profil jika diperlukan
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Image.asset(
                  'assets/bookmark.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                title: Row(
                  children: [
                    Text(
                      "Pantauan",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/locked.png',
                            width: 12,
                            height: 12,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "coming soon",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Image.asset(
                  'assets/forward-grey.png',
                  width: 9,
                  fit: BoxFit.contain,
                ),
                onTap: null, // Disable tap untuk item ini
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Image.asset(
                  'assets/bantuan.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
                title: Row(
                  children: [
                    Text(
                      "Bantuan",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/locked.png',
                            width: 12,
                            height: 12,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "coming soon",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Image.asset(
                  'assets/forward-grey.png',
                  width: 9,
                  fit: BoxFit.contain,
                ),
                onTap: null, // Disable tap untuk item ini
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 52.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logout.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Keluar Akun",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text("versi 1.0.0",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
