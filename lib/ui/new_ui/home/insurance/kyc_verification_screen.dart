import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/insurance_view_model.dart';

class KYCVerificationScreen extends StatefulWidget {
  const KYCVerificationScreen({super.key, this.viewModel});

  final InsuranceViewModel? viewModel;

  @override
  State<KYCVerificationScreen> createState() => _KYCVerificationScreenState();
}

class _KYCVerificationScreenState extends State<KYCVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _pobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _ninController = TextEditingController();
  String _selectedGender = 'Male';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel?.prefillUserData(
      nameController: _nameController,
      nationalityController: _nationalityController,
      stateController: _stateController,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _pobController.dispose();
    _nationalityController.dispose();
    _ninController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => widget.viewModel ?? InsuranceViewModel(),
        disposeViewModel: false,
        builder: (context, model, child) {
        return Scaffold(
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'KYC Verification',
          ),
          backgroundColor: XColors.background(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NormalText(
                    text: 'Personal Information',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const YMargin(20),
                  MainInputField(
                    controller: _nameController,
                    label: 'Full Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const YMargin(16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: MainInputField(
                        controller: _dobController,
                        label: 'Date of Birth',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                        suffixIcon: Icon(Icons.calendar_today, color: XColors.primaryColor()),
                      ),
                    ),
                  ),
                  const YMargin(16),
                  MainInputField(
                    controller: _pobController,
                    label: 'Place of Birth',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your place of birth';
                      }
                      return null;
                    },
                  ),
                  const YMargin(16),
                  GestureDetector(
                    onTap: () {
                      listHelperPicker(
                          context: context,
                          title: "Select Gender",
                          listString: ["Male", "Female"],
                          selected: (value) {

                          }
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: XColors.highlightColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_circle_outlined, color: XColors.primaryColor()),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Select Gender',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const YMargin(16),
                  MainInputField(
                    controller: _nationalityController,
                    label: 'Nationality',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your nationality';
                      }
                      return null;
                    },
                  ),
                  const YMargin(16),
                  MainInputField(
                    controller: _stateController,
                    label: 'State',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your state';
                      }
                      return null;
                    },
                  ),
                  const YMargin(32),
                  const NormalText(
                    text: 'Document Information',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const YMargin(20),
                  MainInputField(
                    controller: _ninController,
                    label: 'National ID Number (NIN)',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your NIN';
                      }
                      return null;
                    },
                  ),
                  const YMargin(16),
                  Row(
                    children: [
                      Expanded(
                        child: ContainerWidget(
                          onTap: () async {

                            model.pickDocument(front: true, onComplete: () {});

                          },
                          hasBorder: true,
                          borderColor: XColors.primaryColor2().withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                          padding: const EdgeInsets.all(16),
                          borderThickness: 1.5,
                          child: Column(
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: XColors.primaryColor2(),
                              ),
                              const YMargin(8),
                              NormalText(
                                text: 'Front of ID',
                                textColor: XColors.primaryColor2(),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const XMargin(16),
                      Expanded(
                        child: ContainerWidget(
                          onTap: () async {
                            model.pickDocument(front: false, onComplete: () {});
                          },
                          hasBorder: true,
                          borderColor: XColors.primaryColor2().withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                          padding: const EdgeInsets.all(16),
                          borderThickness: 1.5,
                          child: Column(
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: XColors.primaryColor2(),
                              ),
                              const YMargin(8),
                              NormalText(
                                text: 'Back of ID',
                                textColor: XColors.primaryColor2(),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const YMargin(32),
                  XButton(
                    onPressed: () {

                      if (_formKey.currentState!.validate() && model.filePickerResultMain != null) {

                        model.updateKycData(
                          fullName: _nameController.text,
                          dateOfBirth: _dobController.text,
                          placeOfBirth: _pobController.text,
                          gender: _selectedGender,
                          nationality: _nationalityController.text,
                          nationalIdNumber: _ninController.text,
                          state: _stateController.text,
                          onCallBack: () {

                            FloatingSnackBar.show(
                                context,
                                "Successfully submitted your KYC",
                                isError: false
                            );
                            Navigator.pop(context, true);

                          },
                          onError: (e) {
                            FloatingSnackBar.show(
                                context,
                                e.toString(),
                                isError: true
                            );
                          },
                        );

                      } else {
                        FloatingSnackBar.show(
                            context,
                            "Please fill in all the required fields",
                            isError: true
                        );
                      }

                    },
                    text: 'Submit',
                    height: 56,
                    textColor: Colors.white,
                    buttonColor: XColors.primaryColor(),
                    progressColor: Colors.white,
                    isLoading: model.isBusy,
                    radius: 26,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}