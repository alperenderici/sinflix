import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../core/navigation/navigation_service.dart';

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({super.key});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profil Detayı',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Title
            const Text(
              'Fotoğraflarınızı Yükleyin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle
            const Text(
              'Resources out incentivize\nrelaxation floor loss cc.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 60),
            
            // Photo Upload Area
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade600,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : const Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 48,
                          ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedImage != null && !_isUploading
                    ? _uploadPhoto
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Devam Et',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Fotoğraf seçilirken bir hata oluştu');
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // TODO: Implement actual photo upload API call
      // For now, simulate upload delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Show success message
      NavigationService.showSuccessSnackBar('Fotoğraf başarıyla yüklendi!');
      
      // Go back to profile page
      Navigator.of(context).pop();
      
    } catch (e) {
      _showErrorSnackBar('Fotoğraf yüklenirken bir hata oluştu');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
