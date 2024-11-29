import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymm/api/actions.dart';
import 'package:gymm/api/exceptions.dart';
import 'package:gymm/components/loading.dart';
import 'package:gymm/models/client.dart';
import 'package:gymm/utils/preferences.dart';
import 'package:gymm/utils/snack_bar.dart';
import 'package:async/async.dart';

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({
    super.key,
  });

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Client? client;
  bool loading = true;
  bool submitting = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController phone2Controller = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String? selectedGender;
  Map<String, String?> fieldErrors = {};

  CancelableOperation? _currentOperation;

  @override
  void initState() {
    super.initState();
    _populateInitialData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    phone2Controller.dispose();
    nationalIdController.dispose();
    birthdateController.dispose();
    emailController.dispose();
    addressController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
    _currentOperation?.cancel();
  }

  void _populateInitialData() async {
    Client savedClient = await getClientSavedData();
    setState(() {
      client = savedClient;
    });
    nameController.text = savedClient.name ?? '';
    phoneController.text = savedClient.phone;
    phone2Controller.text = savedClient.phone2 ?? '';
    emailController.text = savedClient.email ?? '';
    nationalIdController.text = savedClient.nationalId ?? '';
    birthdateController.text = savedClient.birthDateString() ?? '';
    addressController.text = savedClient.address ?? '';
    weightController.text = savedClient.weight?.toString() ?? '';
    heightController.text = savedClient.height?.toString() ?? '';
    selectedGender = savedClient.gender;
    setState(() {
      loading = false;
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool isRequired = false,
    String? error,
  }) {
    return TextFormField(
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return "$label can't be empty";
        }
        return null;
      },
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      cursorColor: Colors.yellow,
      cursorHeight: 30,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        height: 2,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        label: Text(label),
        hintText: hint,
        errorText: error,
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                value: "male",
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                title:
                    const Text("Male", style: TextStyle(color: Colors.white)),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                value: "female",
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                title:
                    const Text("Female", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        if (fieldErrors["gender"] != null)
          Text(
            fieldErrors["gender"]!,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    String? error,
    bool isRequired = false,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: client?.birthDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          controller.text = selectedDate.toIso8601String().split('T').first;
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(
          controller: controller,
          label: label,
          hint: "YYYY-MM-DD",
          isRequired: isRequired,
          error: error,
        ),
      ),
    );
  }

  void _saveForm(BuildContext context) {
    // Cancel any ongoing operation before starting a new one
    _currentOperation?.cancel();

    // Remove focus
    FocusScope.of(context).requestFocus(FocusNode());

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      submitting = true;
    });

    // Perform email validation
    final email = emailController.text;
    if (email.isNotEmpty && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        fieldErrors["email"] = "Invalid email address";
      });
      return;
    }

    final data = {
      "name": nameController.text,
      "phone": phoneController.text,
      "phone2": phone2Controller.text,
      "national_id": nationalIdController.text,
      "gander": selectedGender,
      "birth_date": birthdateController.text,
      "email": email,
      "address": addressController.text,
      "weight": weightController.text.isNotEmpty ? weightController.text : null,
      "height":
          (heightController.text.isNotEmpty) ? heightController.text : null,
    };

    setState(() {
      fieldErrors = {};
    });

    // Wrap the async operation in a CancelableOperation
    _currentOperation = CancelableOperation.fromFuture(
      updateClientData(client!.customPk.toString(), data),
      onCancel: () {
        print("Operation cancelled");
      },
    );

    _currentOperation!.value.then((_) {
      // Check if the widget is still in the tree before updating the UI
      if (!mounted) return;

      showSnackBar(context, "Personal Information Updated", "info");
      Navigator.of(context).pop();
    }).catchError((error) {
      if (!mounted) return;

      setState(() {
        if (error is ClientErrorException) {
          setState(() {
            (error).responseBody.forEach((k, v) {
              fieldErrors[k] = v.toString().contains("exist")
                  ? "Phone number exists"
                  : "Invalid Value";
            });
          });
        } else {
          showSnackBar(context, "Error Saving data", "error");
        }
      });
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          submitting = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Info"),
      ),
      body: loading
          ? const Center(
              child: Loading(),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 40.0, left: 18, right: 18, top: 18),
                      child: Form(
                        key: _formKey,
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTextField(
                                  controller: nameController,
                                  label: "Name",
                                  isRequired: true,
                                  error: fieldErrors["name"],
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: phoneController,
                                  label: "Phone",
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  isRequired: true,
                                  error: fieldErrors["phone"],
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: phone2Controller,
                                  label: "Phone 2",
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  error: fieldErrors["phone2"],
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: nationalIdController,
                                  label: "National ID",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  error: fieldErrors["national_id"],
                                ),
                                const SizedBox(height: 26),
                                _buildGenderSelector(),
                                const SizedBox(height: 16),
                                _buildDateField(
                                  controller: birthdateController,
                                  label: "Birthdate",
                                  isRequired: true,
                                  error: fieldErrors["birthdate"],
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: emailController,
                                  label: "Email",
                                  keyboardType: TextInputType.emailAddress,
                                  error: fieldErrors["email"],
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: addressController,
                                  label: "Address",
                                  keyboardType: TextInputType.streetAddress,
                                  error: fieldErrors["address"],
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: weightController,
                                  label: "Weight",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  error: fieldErrors["weight"],
                                ),
                                const SizedBox(height: 16),
                                _buildTextField(
                                  controller: heightController,
                                  label: "Height",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  error: fieldErrors["height"],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Custom floating action button
                Positioned(
                  bottom: 50, // Adjust the bottom offset
                  right: 40, // Adjust the left offset
                  child: FloatingActionButton(
                    onPressed: submitting
                        ? null
                        : () {
                            _saveForm(context);
                          },
                    child: submitting
                        ? const Center(child: CircularProgressIndicator())
                        : const Icon(Icons.save),
                  ),
                ),
              ],
            ),
      // floatingActionButton:
    );
  }
}
