import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/ui/components/components.dart';
import 'package:temulik/ui/home_page.dart';
import '../bloc/profile_bloc.dart';

final List<String> _faculties = [
  'Fakultas Pertanian',
  'Fakultas Biologi',
  'Fakultas Ekonomi dan Bisnis',
  'Fakultas Peternakan',
  'Fakultas Hukum',
  'Fakultas Ilmu Sosial dan Politik',
  'Fakultas Kedokteran',
  'Fakultas Teknik',
  'Fakultas Ilmu Budaya',
  'Fakultas Ilmu-Ilmu Kesehatan',
  'Fakultas Matermatika dan Ilmu Pengetahuan Alam',
  'Fakultas Perikanan dan Ilmu Kelautan',
];

final Map<String, List<String>> _departments = {
  'Fakultas Pertanian': [
    'Agribisnis',
    'Agroteknologi',
    'Teknik Pertanian',
    'Ilmu Tanah',
    'Proteksi Tanaman',
    'Teknologi Pangan',
  ],
  'Fakultas Biologi': [
    'Biologi',
  ],
  'Fakultas Ekonomi dan Bisnis': [
    'Akuantansi',
    'Manajemen',
    'Ekonomi Pembangunan',
    'Administrasi Perkantoran',
    'Ilmu Ekonomi',
  ],
  'Fakultas Peternakan': [
    'Peternakan',
  ],
  'Fakultas Hukum': [
    'Ilmu Hukum',
  ],
  'Fakultas Ilmu Sosial dan Politik': [
    'Ilmu Politik',
    'Ilmu Komunikasi',
    'Administrasi Negara',
    'Sosiologi',
    'Hubungan Internasional',
  ],
  'Fakultas Kedokteran': [
    'Pendidikan Dokter',
    'Pendidikan Dokter Gigi',
  ],
  'Fakultas Teknik': [
    'Informatika',
    'Teknik Elektro',
    'Teknik Sipil',
    'Teknik Industri',
    'Teknik Geologi',
    'Teknik Mesin',
    'Teknik Komputer',
  ],
  'Fakultas Ilmu Budaya': [
    'Sastra Inggris',
    'Sastra Indonesia',
    'Sastra Jepang',
    'Sastra Mandarin',
    'Pendidikan Bahasa Inggris',
    'Pendidikan Bahasa Indonesia',
  ],
  'Fakultas Ilmu-Ilmu Kesehatan': [
    'Keperawatan',
    'Keperawatan Internasional',
    'Ilmu Gizi',
    'Kesehatan Masyarakat',
    'Farmasi',
    'Pendidikan Jasmani, Kesehatan, dan Rekreasi',
  ],
  'Fakultas Matermatika dan Ilmu Pengetahuan Alam': [
    'Matematika',
    'Fisika',
    'Kimia',
    'Statistika',
    'Aktuaria',
  ],
  'Fakultas Perikanan dan Ilmu Kelautan': [
    'Perikanan',
    'Kelautan',
    'Akuakultur',
    'Management Sumberdaya Perairan',
  ],
};

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late UserProfile _profile;
  bool _termsAccepted = false;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _profile = UserProfile(email: '');
    context.read<ProfileBloc>().add(LoadProfile());
  }

  List<Widget> _buildFormFields(ProfileState state) {
    return [
      _buildPhotoUploadWidget(state),
      TextFormField(
        initialValue: _profile.fullName,
        decoration: InputDecoration(
          labelText: 'Nama Lengkap',
          errorStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan nama lengkap Anda';
          }
          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
            return 'Nama lengkap hanya boleh mengandung huruf';
          }
          if (value.length > 20) {
            return 'Nama lengkap tidak boleh lebih dari 20 karakter';
          }
          return null;
        },
        onSaved: (value) => _profile = _profile.copyWith(fullName: value),
      ),
      TextFormField(
        initialValue: _profile.nim,
        decoration: InputDecoration(
          labelText: 'NIM',
          errorStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Masukkan NIM Anda';
          if (!RegExp(r'^[A-Z][0-9][A-Z][0-9]{6}$').hasMatch(value))
            return 'Format NIM tidak valid';
          return null;
        },
        onSaved: (value) => _profile = _profile.copyWith(nim: value),
      ),
      DropdownButtonFormField<String>(
        value: _faculties.contains(_profile.faculty) ? _profile.faculty : null,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Fakultas',
          errorStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        items: _faculties.map((String faculty) {
          return DropdownMenuItem(
            value: faculty,
            child: Text(
              faculty,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          );
        }).toList(),
        validator: (value) => value == null ? 'Pilih fakultas Anda' : null,
        onChanged: (String? newValue) {
          setState(() {
            _profile = _profile.copyWith(
              faculty: newValue,
              department: null,
            );
          });
        },
        onSaved: (value) => _profile = _profile.copyWith(faculty: value),
      ),
      DropdownButtonFormField<String>(
        value: _profile.faculty != null &&
                _departments[_profile.faculty]!.contains(_profile.department)
            ? _profile.department
            : null,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Jurusan',
          errorStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        dropdownColor: Colors.white,
        items: _profile.faculty == null
            ? []
            : (_departments[_profile.faculty] ?? []).map((String department) {
                return DropdownMenuItem(
                  value: department,
                  child: Text(
                    department,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                );
              }).toList(),
        validator: (value) => value == null ? 'Pilih Jurusan Anda' : null,
        onChanged: _profile.faculty == null
            ? null
            : (String? newValue) {
                setState(() {
                  _profile = _profile.copyWith(department: newValue);
                });
              },
        onSaved: (value) => _profile = _profile.copyWith(department: value),
      ),
      TextFormField(
        initialValue: _profile.year?.toString(),
        decoration: InputDecoration(
          labelText: 'Angkatan',
          errorStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty)
            return 'Masukkan tahun angkatan Anda';
          final year = int.tryParse(value);
          if (year == null || year < 2010 || year > DateTime.now().year) {
            return 'Masukkan tahun yang valid antara 2010 hingga ${DateTime.now().year}';
          }
          return null;
        },
        onSaved: (value) =>
            _profile = _profile.copyWith(year: int.parse(value!)),
      ),
      TextFormField(
        initialValue: _profile.whatsapp,
        decoration: InputDecoration(
          labelText: 'No. WhatsApp',
          errorStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Masukkan nomor WhatsApp Anda';
          }
          if (!RegExp(r'^08\d{8,11}$').hasMatch(value)) {
            return 'Format nomor WhatsApp tidak valid';
          }
          return null;
        },
        onSaved: (value) => _profile = _profile.copyWith(whatsapp: value),
      ),
      TextFormField(
        initialValue: _profile.address,
        decoration: InputDecoration(
          labelText: 'Alamat Rumah/Kos',
          errorStyle: TextStyle(color: Colors.red),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty)
            return 'Masukkan alamat rumah/kos Anda';
          return null;
        },
        onSaved: (value) => _profile = _profile.copyWith(address: value),
      ),
      CheckboxListTile(
        title: RichText(
          text: TextSpan(
            text: 'Dengan klik tombol ini, kamu menyetujui ',
            style: TextStyle(color: Colors.black87, fontSize: 12),
            children: [
              TextSpan(
                text: 'Syarat & Ketentuan',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' serta ',
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ),
              TextSpan(
                text: 'Kebijakan Privasi',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' lapor barang hilang di Temulik.',
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ),
            ],
          ),
        ),
        value: _termsAccepted,
        onChanged: (value) => setState(() => _termsAccepted = value!),
        controlAffinity: ListTileControlAffinity.leading,
      ),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          child: Text('Update'),
          onPressed: _termsAccepted ? _submitForm : null,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lengkapi Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false, // Ini akan membuat title berada di kiri
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileComplete && !_isInitialLoad) {
            showDialog(
              context: context,
              builder: (context) => SuccessDialog(
                title: 'Berhasil!',
                message: 'Informasi berhasil diubah',
                iconColor: Colors.white,
                iconBackgroundColor: AppColors.green,
                buttonColor: AppColors.green,
                buttonText: 'Kembali ke Home',
                icon: Icons.thumb_up,
                onOkPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                    (route) => false,
                  );
                },
              ),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is ProfileIncomplete || state is ProfileComplete) {
            setState(() {
              _profile = state.profile;
              _isInitialLoad = false;
            });
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileIncomplete || state is ProfileComplete) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Wrap(
                    runSpacing: 10.0,
                    children: [
                      Center(child: _buildPhotoUploadWidget(state)),
                      ...(_buildFormFields(state).sublist(1))
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(color: AppColors.green),
            );
          }
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<ProfileBloc>().add(UpdateProfile(_profile));
    }
  }

  Widget _buildPhotoUploadWidget(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: _profile.photoUrl != null
                      ? Image.network(
                          _profile.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 64,
                              color: Colors.grey[400],
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.green,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : Icon(
                          Icons.person,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  onPressed: state is ProfileUpdating
                      ? null
                      : () => _showPhotoSourceDialog(context),
                ),
              ),
            ],
          ),
          if (state is ProfileUpdating)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Uploading...'),
            )
          else if (_profile.photoUrl == null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Tambah Foto Profil',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPhotoSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Sumber Foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                        const PickAndUploadProfilePhoto(
                            source: ImageSource.gallery),
                      );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                        const PickAndUploadProfilePhoto(
                            source: ImageSource.camera),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
