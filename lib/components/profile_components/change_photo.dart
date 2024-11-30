import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/colors.dart';

class ChangePhoto extends StatefulWidget {
  const ChangePhoto({super.key, this.client});

  final Client? client;

  @override
  State<ChangePhoto> createState() => ChangePhotoState();
}

class ChangePhotoState extends State<ChangePhoto> {
  Client? client;

  File? _image;

  @override
  void initState() {
    super.initState();
    client = widget.client;
  }

  void updateWidget(Client? newClient) {
    setState(() {
      client = newClient;
    });
  }

  Future<void> _pickPhoto(BuildContext context) async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        setState(() {
          _image = null;
        });
        return;
      }

      final file = File(pickedFile.path);
      final fileSize = await file.length();

      // (1 MB = 1,048,576 bytes)
      if (fileSize > 1048576) {
        showSnackBar(context,
            "The selected photo exceeds the size limit of 1 MB", "error");
        return;
      }
      setState(() {
        _image = file;
      });
    } catch (e) {
      showSnackBar(
          context, "An error occurred while picking the photo", "error");
      return;
    }
  }

  Future<void> _uploadImage() async {}

  Widget _buildUploadInstruction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload a photo that clearly shows your face (must not exceed 1 MB)."
          "\nPlease note, the current photo will remain unchanged until approved"
          " by gym moderators.",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 12),
        _image == null ? _buildSelectButton() : _buildImagePreview(),
      ],
    );
  }

// Build the requested image section
  Widget _buildRequestedImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your requested photo is waiting approval by gym moderators",
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: [
              _buildNetworkImage(),
              const SizedBox(height: 12),
              _buildCancelButton("Cancel Request", Colors.red, () {
                setState(() {
                  _image = null;
                });
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        await _pickPhoto(context);
      },
      style: _buttonStyle(primaryColor),
      icon: const Icon(FontAwesomeIcons.circleUser, color: blackColor),
      label: const Text(
        "Select",
        style: TextStyle(
            color: blackColor, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

// Build the image preview
  Widget _buildImagePreview() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: FileImage(_image!),
            radius: 120,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCancelButton("Cancel", Colors.red, () {
                setState(() {
                  _image = null;
                });
              }),
              const SizedBox(width: 14),
              _buildCancelButton("Upload", primaryColor, () async {
                await _uploadImage();
              }),
            ],
          ),
        ],
      ),
    );
  }

// Build the network image with error and loading handling
  Widget _buildNetworkImage() {
    return CircleAvatar(
      radius: 120,
      backgroundColor: Colors.grey[300],
      child: ClipOval(
        child: Image.network(
          client!.requestedPhotoUrl!,
          fit: BoxFit.cover,
          width: 240,
          height: 240,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text(
                "Failed to load image",
                style: TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child; // Image loaded successfully
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

// Build a cancel/upload button with customizable text and action
  Widget _buildCancelButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _buttonStyle(color),
      child: Text(
        text,
        style: const TextStyle(
            color: blackColor, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

// Reusable button style
  ButtonStyle _buttonStyle(Color color) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(color),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        decoration: BoxDecoration(
          color: blackColor[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
            shape: Border.all(color: Colors.transparent),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(FontAwesomeIcons.circleUser, color: primaryColor),
                SizedBox(width: 10),
                Text(
                  "Change Photo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            children: [
              client != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: client!.requestedPhotoUrl == null
                          ? _buildUploadInstruction()
                          : _buildRequestedImageSection())
                  : const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          "Couldn't load data",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    )
            ]));
  }
}
