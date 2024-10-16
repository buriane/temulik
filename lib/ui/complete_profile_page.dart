import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/profile_bloc.dart';
import 'home_page.dart';

final List<String> _faculties = [
  'Fakultas Kedokteran',
  'Fakultas Teknik',
  'Fakultas Ilmu Sosial dan Politik',
  'Fakultas Ekonomi dan Bisnis',
  'Fakultas Biologi',
  'Fakultas Hukum',
  'Fakultas Pertanian',
  'Fakultas Peternakan',
  'Fakultas MIPA',
  // Add other faculties as needed
];

final Map<String, List<String>> _departments = {
  'Fakultas Teknik': [
    'Teknik Informatika',
    'Teknik Elektro',
    'Teknik Sipil',
    'Teknik Industri',
    // Add other departments
  ],
  'Fakultas MIPA': [
    'Matematika',
    'Fisika',
    'Kimia',
    'Biologi',
    // Add other departments
  ],
  // Add departments for other faculties
};

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late UserProfile _profile;
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _profile = context.read<ProfileBloc>().state.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lengkapi Profil')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileComplete) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ProfileIncomplete || state is ProfileComplete) {
            setState(() {
              _profile = state.profile;
            });
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Photo upload widget
                  _buildPhotoUploadWidget(state),
                  // Full name input
                  TextFormField(
                    initialValue: _profile.fullName,
                    decoration: InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your full name';
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value))
                        return 'Please enter only letters';
                      return null;
                    },
                    onSaved: (value) =>
                        _profile = _profile.copyWith(fullName: value),
                  ),
                  // NIM input
                  TextFormField(
                    initialValue: _profile.nim,
                    decoration: InputDecoration(labelText: 'NIM'),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your NIM';
                      if (!RegExp(r'^[A-Z][0-9][A-Z][0-9]{6}$').hasMatch(value))
                        return 'Invalid NIM format';
                      return null;
                    },
                    onSaved: (value) =>
                        _profile = _profile.copyWith(nim: value),
                  ),
                  DropdownButtonFormField<String>(
                    value: _profile.faculty,
                    decoration: InputDecoration(labelText: 'Faculty'),
                    items: _faculties.map((String faculty) {
                      return DropdownMenuItem(
                        value: faculty,
                        child: Text(faculty),
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'Please select your faculty' : null,
                    onChanged: (String? newValue) {
                      setState(() {
                        _profile = _profile.copyWith(
                          faculty: newValue,
                          department:
                              null, // Reset department when faculty changes
                        );
                      });
                    },
                    onSaved: (value) =>
                        _profile = _profile.copyWith(faculty: value),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _profile.department,
                    decoration: InputDecoration(labelText: 'Department'),
                    items: _profile.faculty == null
                        ? []
                        : (_departments[_profile.faculty] ?? [])
                            .map((String department) {
                            return DropdownMenuItem(
                              value: department,
                              child: Text(department),
                            );
                          }).toList(),
                    validator: (value) =>
                        value == null ? 'Please select your department' : null,
                    onChanged: _profile.faculty == null
                        ? null
                        : (String? newValue) {
                            setState(() {
                              _profile =
                                  _profile.copyWith(department: newValue);
                            });
                          },
                    onSaved: (value) =>
                        _profile = _profile.copyWith(department: value),
                  ),
                  // Year input
                  TextFormField(
                    initialValue: _profile.year?.toString(),
                    decoration: InputDecoration(labelText: 'Year'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your year';
                      final year = int.tryParse(value);
                      if (year == null ||
                          year < 2010 ||
                          year > DateTime.now().year) {
                        return 'Please enter a valid year between 2010 and ${DateTime.now().year}';
                      }
                      return null;
                    },
                    onSaved: (value) =>
                        _profile = _profile.copyWith(year: int.parse(value!)),
                  ),
                  // WhatsApp number input
                  TextFormField(
                    initialValue: _profile.whatsapp,
                    decoration: InputDecoration(labelText: 'WhatsApp Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your WhatsApp number';
                      if (!RegExp(r'^62\d{9,12}$').hasMatch(value))
                        return 'Invalid WhatsApp number format';
                      return null;
                    },
                    onSaved: (value) =>
                        _profile = _profile.copyWith(whatsapp: value),
                  ),
                  // Address input
                  TextFormField(
                    initialValue: _profile.address,
                    decoration: InputDecoration(labelText: 'Home Address'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your home address';
                      return null;
                    },
                    onSaved: (value) =>
                        _profile = _profile.copyWith(address: value),
                  ),
                  // Terms and conditions checkbox
                  CheckboxListTile(
                    title: Text(
                        'I agree to the Terms & Conditions and Privacy Policy'),
                    value: _termsAccepted,
                    onChanged: (value) =>
                        setState(() => _termsAccepted = value!),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Update Profile'),
                    onPressed: _termsAccepted ? _submitForm : null,
                  ),
                ],
              ),
            ),
          );
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
                'Add Profile Photo',
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
          title: const Text('Select Photo Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
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
                title: const Text('Camera'),
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
