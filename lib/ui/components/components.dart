import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temulik/bloc/map_bloc.dart';
import 'package:temulik/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:latlong2/latlong.dart';
import 'package:temulik/models/faculty.dart';
import 'package:temulik/ui/pin_map_page.dart';
import 'package:url_launcher/url_launcher.dart';

class DoneButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DoneButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 20.0,
        ),
        backgroundColor: AppColors.green,
        overlayColor: AppColors.green,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            color: Colors.white,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          TextBold(
            text: 'Selesai Pencarian Barang',
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 20.0,
        ),
        backgroundColor: AppColors.red,
        overlayColor: AppColors.red,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.close,
            color: Colors.white,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          TextBold(
            text: 'Batal Pencarian Barang',
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class AjukanButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AjukanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 20.0,
        ),
        backgroundColor: AppColors.blue,
        overlayColor: AppColors.blue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.white,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          TextBold(
            text: 'Ajukan Pencarian',
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final VoidCallback onPressed;
  const EditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 20.0,
        ),
        backgroundColor: AppColors.dark,
        overlayColor: AppColors.dark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings,
            color: Colors.white,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          TextBold(
            text: 'Ubah Informasi Barang',
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class WhatsappButton extends StatelessWidget {
  final String phoneNumber;

  const WhatsappButton({
    super.key,
    required this.phoneNumber,
  });

  Future<void> _launchWhatsApp(BuildContext context) async {
    try {
      String formattedPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      if (!formattedPhone.startsWith('+')) {
        formattedPhone =
            '+62${formattedPhone.startsWith('0') ? formattedPhone.substring(1) : formattedPhone}';
      }
      final url = 'https://wa.me/${formattedPhone}';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Tidak dapat membuka WhatsApp. Pastikan WhatsApp terinstall'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 20.0,
        ),
        backgroundColor: Colors.transparent,
        overlayColor: AppColors.green,
        elevation: 0,
        side: BorderSide(
          color: AppColors.green,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () => _launchWhatsApp(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/whatsapp.svg',
            colorFilter: ColorFilter.mode(
              AppColors.green,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8.0),
          TextBold(
            text: 'Hubungi via WhatsApp',
            color: AppColors.green,
          ),
        ],
      ),
    );
  }
}

class TextBold extends StatelessWidget {
  final String text;
  final Color color;
  const TextBold({
    super.key,
    required this.text,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class TextTinyMedium extends StatelessWidget {
  final String text;
  const TextTinyMedium({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
        color: AppColors.dark,
      ),
    );
  }
}

class TextSmallMedium extends StatelessWidget {
  final String text;
  final Color color;
  const TextSmallMedium({
    super.key,
    required this.text,
    this.color = AppColors.darkest,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}

class TextSmallBold extends StatelessWidget {
  final String text;
  final Color color;
  const TextSmallBold({
    super.key,
    required this.text,
    this.color = AppColors.darkest,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class CustomImageSlider extends StatefulWidget {
  final List<dynamic> imageUrls;
  final double height;
  final Duration autoPlayDuration;
  final Duration animationDuration;
  final bool autoPlay;

  const CustomImageSlider({
    Key? key,
    required this.imageUrls,
    this.height = 200.0,
    this.autoPlayDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 500),
    this.autoPlay = true,
  }) : super(key: key);

  @override
  State<CustomImageSlider> createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (_currentPage < widget.imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: widget.animationDuration,
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LaporAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSubmit;

  const LaporAppBar({super.key, required this.title, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 70.0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: SvgPicture.asset(
          'assets/cancel.svg',
          width: 17.0,
        ),
      ),
      title: TextBold(
        text: title,
        color: AppColors.darkest,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(64.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            ),
            child: TextSmallMedium(
              text: 'Kirim',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class InputForm extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const InputForm({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSmallMedium(text: label),
        TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.darkGrey,
              fontSize: 16.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.green),
            ),
          ),
        ),
      ],
    );
  }
}

class TextAreaForm extends StatefulWidget {
  final String label;
  final String hintText;
  final int maxLength;
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const TextAreaForm({
    super.key,
    required this.label,
    required this.hintText,
    this.maxLength = 100,
    required this.controller,
    this.onChanged,
  });

  @override
  State<TextAreaForm> createState() => _TextAreaFormState();
}

class _TextAreaFormState extends State<TextAreaForm> {
  int _textLength = 0;

  @override
  void initState() {
    super.initState();
    _textLength = widget.controller.text.length;
    widget.controller.addListener(_updateTextLength);
  }

  void _updateTextLength() {
    setState(() {
      _textLength = widget.controller.text.length;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextLength);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSmallMedium(text: widget.label),
        Stack(
          children: [
            TextFormField(
              controller: widget.controller,
              maxLength: widget.maxLength,
              maxLines: 3,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16.0,
                ),
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.green),
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Text(
                '$_textLength/${widget.maxLength}',
                style: const TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SelectForm extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? value;

  const SelectForm({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSmallMedium(text: label),
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: Text(
              hintText,
              style: const TextStyle(
                color: AppColors.darkGrey,
                fontSize: 16.0,
              ),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.green),
              ),
            ),
            items: items
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: AppColors.darkest,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class DatePickerForm extends StatelessWidget {
  final String label;
  final String hintText;
  final DateTime? selectedDate;
  final void Function(DateTime?)? onChanged;

  const DatePickerForm({
    super.key,
    required this.label,
    required this.hintText,
    this.selectedDate,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSmallMedium(text: label),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.green,
                      onPrimary: Colors.white,
                      onSurface: AppColors.dark,
                      outline: AppColors.green,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && onChanged != null) {
              onChanged!(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                      : hintText,
                  style: TextStyle(
                    color: selectedDate != null
                        ? AppColors.darkest
                        : AppColors.darkGrey,
                    fontSize: 16.0,
                  ),
                ),
                const Icon(Icons.calendar_today, color: AppColors.darkGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimePickerForm extends StatelessWidget {
  final String label;
  final String hintText;
  final TimeOfDay? selectedTime;
  final void Function(TimeOfDay?)? onChanged;

  const TimePickerForm({
    super.key,
    required this.label,
    required this.hintText,
    this.selectedTime,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSmallMedium(text: label),
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.green,
                      onPrimary: Colors.white,
                      onSurface: AppColors.dark,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && onChanged != null) {
              onChanged!(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime != null
                      ? selectedTime!.format(context)
                      : hintText,
                  style: TextStyle(
                    color: selectedTime != null
                        ? AppColors.darkest
                        : AppColors.darkGrey,
                    fontSize: 16.0,
                  ),
                ),
                const Icon(Icons.access_time, color: AppColors.darkGrey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ImagePickerForm extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> imagePaths;
  final Function(List<String>) onImagesSelected;
  final VoidCallback? onTap;

  const ImagePickerForm({
    super.key,
    required this.label,
    required this.hintText,
    required this.imagePaths,
    required this.onImagesSelected,
    this.onTap,
  });

  @override
  State<ImagePickerForm> createState() => _ImagePickerFormState();
}

class _ImagePickerFormState extends State<ImagePickerForm> {
  bool isFirebaseUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  Future<void> _pickImage(BuildContext context) async {
    if (widget.imagePaths.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maksimal 5 gambar yang dapat dipilih')),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await showDialog<XFile?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pilih Sumber Gambar'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Dari Galeri'),
                  onTap: () async {
                    Navigator.pop(
                      context,
                      await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 800,
                        maxHeight: 800,
                        imageQuality: 70,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Dari Kamera'),
                  onTap: () async {
                    Navigator.pop(
                      context,
                      await picker.pickImage(
                        source: ImageSource.camera,
                        maxWidth: 800,
                        maxHeight: 800,
                        imageQuality: 70,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );

      if (pickedFile != null) {
        final List<String> updatedPaths = List.from(widget.imagePaths)
          ..add(pickedFile.path);
        widget.onImagesSelected(updatedPaths);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    final List<String> updatedPaths = List.from(widget.imagePaths)
      ..removeAt(index);
    widget.onImagesSelected(updatedPaths);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSmallMedium(text: widget.label),
        const SizedBox(height: 8.0),
        if (widget.imagePaths.isEmpty)
          InkWell(
            onTap: () => _pickImage(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.hintText,
                      style: const TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.add_photo_alternate,
                      color: AppColors.darkGrey),
                ],
              ),
            ),
          ),
        if (widget.imagePaths.isNotEmpty) ...[
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imagePaths.length +
                  (widget.imagePaths.length < 5 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == widget.imagePaths.length) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: InkWell(
                      onTap: () => _pickImage(context),
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate,
                          color: AppColors.darkGrey,
                          size: 32,
                        ),
                      ),
                    ),
                  );
                }

                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isFirebaseUrl(widget.imagePaths[index])
                            ? Image.network(
                                widget.imagePaths[index],
                                width: 100,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 100,
                                    height: 120,
                                    color: AppColors.grey.withOpacity(0.3),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.green,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 100,
                                    height: 120,
                                    color: AppColors.grey.withOpacity(0.3),
                                    child: const Icon(Icons.error),
                                  );
                                },
                              )
                            : Image.file(
                                File(widget.imagePaths[index]),
                                width: 100,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.imagePaths.length}/5 gambar',
            style: const TextStyle(
              color: AppColors.darkGrey,
              fontSize: 12.0,
            ),
          ),
        ],
      ],
    );
  }
}

class PinPointInput extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? initialFaculty;

  const PinPointInput({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.initialFaculty,
  });

  @override
  State<PinPointInput> createState() => _PinPointInputState();
}

class _PinPointInputState extends State<PinPointInput> {
  LatLng? _selectedLocation;
  String? _selectedFaculty;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _selectedFaculty = widget.initialFaculty;
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (!_isInitialized && widget.controller.text.isNotEmpty) {
      try {
        final parts = widget.controller.text.split(',');
        if (parts.length == 2) {
          final lat = double.parse(parts[0].trim());
          final lng = double.parse(parts[1].trim());
          setState(() {
            _selectedLocation = LatLng(lat, lng);
            _isInitialized = true;
          });
        }
      } catch (e) {
        print('Error parsing location: $e');
      }
    }
  }

  void _pickLocation() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => PinMapPage(
          initialLocation: _selectedLocation,
          selectedFaculty: _selectedFaculty,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLocation = result['location'] as LatLng;
        widget.controller.text =
            '${_selectedLocation!.latitude},${_selectedLocation!.longitude}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSmallMedium(text: widget.label),
        const SizedBox(height: 8.0),
        InkWell(
          onTap: _pickLocation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedLocation != null
                        ? 'Lokasi berhasil dipilih'
                        : widget.hintText,
                    style: TextStyle(
                      color: _selectedLocation != null
                          ? AppColors.darkest
                          : AppColors.darkGrey,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.location_on, color: AppColors.darkGrey),
              ],
            ),
          ),
        ),
        if (_selectedLocation != null) ...[
          const SizedBox(height: 8),
          Text(
            'Koordinat: (${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)})',
            style: const TextStyle(
              color: AppColors.darkGrey,
              fontSize: 12.0,
            ),
          ),
        ],
      ],
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final VoidCallback onOkPressed;

  const SuccessDialog({Key? key, required this.onOkPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              'Sukses!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkest,
              ),
            ),
            const SizedBox(height: 8),
            // Message
            Text(
              'Laporan berhasil dikirim',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.dark.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            // OK Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: onOkPressed,
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapButtons extends StatelessWidget {
  final MapController mapController;
  final MapState state;
  final BuildContext context;

  const MapButtons({
    super.key,
    required this.mapController,
    required this.state,
    required this.context,
  });

  void _showAccuracyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Petunjuk Meningkatkan Akurasi'),
        content: const Text(
          '1. Pastikan GPS/Location Services aktif\n'
          '2. Izinkan akses lokasi di browser\n'
          '3. Gunakan browser Chrome terbaru\n'
          '4. Jika menggunakan WiFi, coba gunakan koneksi data seluler\n'
          '5. Tunggu beberapa saat sampai akurasi meningkat',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        children: [
          if (state.showCompass)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  mapController.rotate(0);
                  context.read<MapBloc>().add(ToggleCompassEvent(false));
                  context.read<MapBloc>().add(UpdateBearingEvent(0));
                },
                child: Transform.rotate(
                  angle: state.bearing * (3.141592653589793 / 180),
                  child: Icon(
                    Icons.explore,
                    color: AppColors.dark,
                  ),
                ),
              ),
            ),
          FloatingActionButton(
            backgroundColor: AppColors.blue,
            onPressed: () {
              context.read<MapBloc>().add(UpdateLocationEvent());
              if (!state.isHighAccuracy) {
                _showAccuracyDialog(context);
              }
              if (state.currentLocation != null) {
                mapController.move(state.currentLocation!, 15);
              }
            },
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
          ),
        ],
      ),
    );
  }
}

class FacultyFilter extends StatelessWidget {
  final List<String> selectedCategories;
  final Function(String, bool) onFacultySelected;
  final MapController mapController;
  final BuildContext context;
  final bool singleSelect;

  const FacultyFilter({
    super.key,
    required this.selectedCategories,
    required this.onFacultySelected,
    required this.mapController,
    required this.context,
    this.singleSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: Faculty.unsoedFaculties.length,
            itemBuilder: (context, index) {
              final faculty = Faculty.unsoedFaculties[index];
              final isSelected = selectedCategories.contains(faculty.name);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(
                    faculty.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (bool value) {
                    final facultyLocation =
                        LatLng(faculty.latitude, faculty.longitude);
                    mapController.move(facultyLocation, 17);
                    onFacultySelected(faculty.name, value);

                    if (!singleSelect) {
                      context.read<MapBloc>().add(
                            FilterFacultiesEvent(selectedCategories),
                          );
                    }
                  },
                  selectedColor: AppColors.green,
                  backgroundColor: Colors.white,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.8),
                  pressElevation: 8,
                  side: BorderSide.none,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class UserSearchDropdown extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Function(String) onSearch;
  final Function(Map<String, dynamic>) onUserSelected;
  final List<Map<String, dynamic>> users;
  final bool isLoading;

  const UserSearchDropdown({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.onSearch,
    required this.onUserSelected,
    required this.users,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSmallMedium(text: label),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                onChanged: (value) => onSearch(value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 16.0,
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.darkGrey),
                  suffixIcon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.green,
                            ),
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.green),
                  ),
                ),
              ),
              if (users.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return InkWell(
                        onTap: () {
                          onUserSelected(user);
                          controller.text = user['fullName'] ?? '';
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: index < users.length - 1
                                ? const Border(
                                    bottom: BorderSide(
                                      color: AppColors.grey,
                                    ),
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              if (user['photoUrl'] != null)
                                Container(
                                  width: 32,
                                  height: 32,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(user['photoUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 32,
                                  height: 32,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.grey,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.darkGrey,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user['fullName'] ?? 'Unnamed User',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.darkest,
                                      ),
                                    ),
                                    if (user['email'] != null)
                                      Text(
                                        user['email'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

