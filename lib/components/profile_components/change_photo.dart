import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../theme/colors.dart';

class ChangePhoto extends StatefulWidget {
  const ChangePhoto({super.key, this.client});

  final Client? client;

  @override
  State<ChangePhoto> createState() => ChangePhotoState();
}

class ChangePhotoState extends State<ChangePhoto> {
  bool submitting = false;
  Client? client;

  File? _image;

  CancelableOperation? _currentOperation;

  @override
  void initState() {
    super.initState();
    client = widget.client;
  }

  @override
  void dispose() {
    super.dispose();
    _currentOperation?.cancel();
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
      if (fileSize > 524288) {
        showSnackBar(
            context, AppLocalizations.of(context)!.photoSizeError, "error");
        return;
      }
      setState(() {
        _image = file;
      });
    } catch (e) {
      showSnackBar(
          context, AppLocalizations.of(context)!.pickPhotoError, "error");
      return;
    }
  }

  Future<void> _uploadImage() async {
    setState(() {
      submitting = true;
    });

    _currentOperation?.cancel();
    if (_image is! File) {
      showSnackBar(
          context, AppLocalizations.of(context)!.uploadPhotoError, "error");
      return;
    }

    _currentOperation = CancelableOperation.fromFuture(
        uploadRequestedPhoto(client!.customPk.toString(), _image as File));

    await _currentOperation!.value.then((value) async {
      if (!mounted) return;
      setState(() {
        _image = null;
      });
      showSnackBar(
          context, AppLocalizations.of(context)!.photoRequested, "info");
      client!.requestedPhotoUrl =
          utf8.decode(latin1.encode(value["requested_photo"]));
      await saveClientData(client!.toJson(), downloadImage: false);
      updateWidget(client);
    }).catchError((e) {
      if (mounted) {
        showSnackBar(
            context, AppLocalizations.of(context)!.uploadPhotoError, "error");
      }
    }).whenComplete(() {
      if (!mounted) return;
      setState(() {
        submitting = false;
      });
    });
  }

  Future<void> _cancelRequestedPhoto() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm),
          content: Text(AppLocalizations.of(context)!.deletePhoto),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // User cancels
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // User confirms
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.red[500],
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (!confirmed!) return;
    setState(() {
      submitting = true;
    });

    _currentOperation?.cancel();
    _currentOperation = CancelableOperation.fromFuture(
        deleteRequestedPhoto({"id": client!.id}));

    await _currentOperation!.value.then((_) async {
      if (!mounted) return;
      showSnackBar(context,
          AppLocalizations.of(context)!.requestedPhotoCanceled, "info");
      client!.resetRequestedPhoto();
      await saveClientData(client!.toJson(), downloadImage: false);
      updateWidget(client);
    }).catchError((e) {
      if (mounted) {
        showSnackBar(
            context, AppLocalizations.of(context)!.loadPhotoError, "error");
      }
    }).whenComplete(() {
      if (!mounted) return;
      setState(() {
        submitting = false;
      });
    });
  }

  Widget _buildUploadInstruction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.uploadPhotoHint,
          style: const TextStyle(fontSize: 16),
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
        Text(
          AppLocalizations.of(context)!.waitingApprove,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: [
              _buildNetworkImage(),
              const SizedBox(height: 12),
              _buildActionButton(AppLocalizations.of(context)!.cancelRequest,
                  Colors.red, _cancelRequestedPhoto),
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
      label: Text(
        AppLocalizations.of(context)!.select,
        style: const TextStyle(
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
              _buildActionButton(
                  AppLocalizations.of(context)!.cancel, Colors.red, () {
                setState(() {
                  _image = null;
                });
              }),
              const SizedBox(width: 14),
              _buildActionButton(
                  AppLocalizations.of(context)!.upload, primaryColor, () async {
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
            return Center(
              child: Text(
                AppLocalizations.of(context)!.loadPhotoError,
                style: const TextStyle(color: Colors.red, fontSize: 18),
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
  Widget _buildActionButton(String text, Color color, Function onPressed) {
    return StatefulBuilder(builder: (context, setState) {
      return ElevatedButton(
        onPressed: onPressed as VoidCallback,
        style: _buttonStyle(color),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (submitting)
              const Row(
                children: [
                  SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: blackColor)),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            Text(
              text,
              style: const TextStyle(
                  color: blackColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      );
    });
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(FontAwesomeIcons.circleUser, color: primaryColor),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.of(context)!.changePhoto,
                  style: const TextStyle(
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
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.loadError,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    )
            ]));
  }
}
