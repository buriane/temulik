import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temulik/bloc/auth_bloc.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/complete_profile_page.dart';
import 'package:temulik/ui/login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PengaturanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // Navigasi ke halaman login dan hapus semua route sebelumnya
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
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
                    // Navigasi ke halaman profil
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => CompleteProfilePage()),
                    );
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                child: GestureDetector(
                  onTap: () {
                    // Tampilkan dialog konfirmasi keluar
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/alert.svg',
                                    width: 24, height: 24),
                                SizedBox(width: 8),
                                Text('Peringatan',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: SvgPicture.asset('assets/cancel.svg',
                                  width: 14, height: 14),
                            ),
                          ],
                        ),
                        content: Text(
                          'Apakah Anda yakin ingin keluar?',
                          style: TextStyle(fontSize: 18),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(SignOut());
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.green,
                            ),
                            child: Text('Ya',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ],
                      ),
                    );
                  },
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text("versi 1.8.4",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
