import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fadir/providers/language_provider.dart';

import '../../../providers/feed_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/upload_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController textoController = TextEditingController();
  final List<File> _selectedImages = [];
  bool _isLoading = false;
  static const int _maxImages = 4;

  @override
  void dispose() {
    textoController.dispose();
    super.dispose();
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> pickedFiles = await _picker.pickMultiImage(
          imageQuality: 80,
        );

        if (pickedFiles.isNotEmpty) {
          _addImages(pickedFiles.map((file) => File(file.path)).toList());
        }
      } else {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          _addImages([File(pickedFile.path)]);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('imageSelectError'))),
      );
    }
  }

  void _addImages(List<File> newFiles) {
    if (newFiles.isEmpty) return;

    final List<File> combined = List<File>.from(_selectedImages)..addAll(newFiles);

    if (combined.length > _maxImages) {
      combined.removeRange(_maxImages, combined.length);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Máximo de 4 imagens por publicação.')),
      );
    }

    setState(() {
      _selectedImages
        ..clear()
        ..addAll(combined);
    });
  }

  Future<void> _submitPost() async {
    final userProvider = context.read<UserProvider>();
    final feedProvider =
        context.read<FeedProvider>(); // Faltava essa declaração
    final texto = textoController.text.trim();

    if (texto.isEmpty && _selectedImages.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final List<String> arquivosUrl = [];

      if (_selectedImages.isNotEmpty) {
        for (final file in _selectedImages) {
          final uploaded = await UploadService.uploadFile(file);
          arquivosUrl.add(uploaded);
        }
      }

      await feedProvider.addPost(
        texto,
        imageUrls: arquivosUrl,
        emailUsuario: userProvider.user?.email,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${context.t('publishError')}: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final colors = Theme.of(context).colorScheme; // Define o objeto colors
    const tealColor = Color(0xFF0E564D);

    final bool canPost =
      textoController.text.trim().isNotEmpty || _selectedImages.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.t('createPost'),
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ElevatedButton(
              onPressed: canPost && !_isLoading ? _submitPost : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        context.t('publish'),
                        style: const TextStyle(color: Colors.white),
                      ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            userProvider.user?.fotoPerfil != null
                                ? NetworkImage(userProvider.user!.fotoPerfil!)
                                : null,
                        child:
                            userProvider.user?.fotoPerfil == null
                                ? const Icon(Icons.person)
                                : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        userProvider.user?.nome ?? context.t('defaultUserName'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: textoController,
                    maxLines: null,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: context.t('postHint'),
                      border: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  if (_selectedImages.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _selectedImages.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final file = _selectedImages[index];
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  file,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedImages.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.55),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(
                top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.6)),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _pickImages(ImageSource.gallery),
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    color: tealColor,
                  ),
                ),
                IconButton(
                  onPressed: () => _pickImages(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined, color: tealColor),
                ),
                const Spacer(),
                Text(
                  'Máximo de 4 imagens',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
