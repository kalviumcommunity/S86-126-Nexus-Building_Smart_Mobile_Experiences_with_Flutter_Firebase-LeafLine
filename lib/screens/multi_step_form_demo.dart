import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/form_validators.dart';

/// Multi-Step Form Demo
/// 
/// Demonstrates:
/// - Multi-step form flow with Stepper widget
/// - Step-by-step validation
/// - Progress tracking
/// - Navigation between steps
/// - Data collection across multiple screens
/// - Final submission with complete data
class MultiStepFormDemo extends StatefulWidget {
  const MultiStepFormDemo({super.key});

  @override
  State<MultiStepFormDemo> createState() => _MultiStepFormDemoState();
}

class _MultiStepFormDemoState extends State<MultiStepFormDemo> {
  int _currentStep = 0;
  bool _isComplete = false;

  // Form keys for each step
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _accountInfoFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();

  // Step 1: Personal Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedGender;

  // Step 2: Account Information
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Step 3: Address Information
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  String? _selectedCountry;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _countries = [
    'India',
    'USA',
    'UK',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'Japan',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: const Text('Personal'),
        subtitle: const Text('Basic information'),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        content: _buildPersonalInfoStep(),
      ),
      Step(
        title: const Text('Account'),
        subtitle: const Text('Login credentials'),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        content: _buildAccountInfoStep(),
      ),
      Step(
        title: const Text('Address'),
        subtitle: const Text('Location details'),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        content: _buildAddressStep(),
      ),
    ];
  }

  Widget _buildPersonalInfoStep() {
    return Form(
      key: _personalInfoFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name *',
              hintText: 'Enter first name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) => FormValidators.validateRequired(
              value,
              fieldName: 'First name',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name *',
              hintText: 'Enter last name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) => FormValidators.validateRequired(
              value,
              fieldName: 'Last name',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(
              labelText: 'Gender *',
              prefixIcon: Icon(Icons.wc),
              border: OutlineInputBorder(),
            ),
            hint: const Text('Select gender'),
            items: _genders.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedGender = value),
            validator: (value) {
              if (value == null) {
                return 'Please select a gender';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dobController,
            decoration: InputDecoration(
              labelText: 'Date of Birth *',
              hintText: 'YYYY-MM-DD',
              prefixIcon: const Icon(Icons.calendar_today),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _dobController.text =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
            ),
            readOnly: true,
            validator: FormValidators.validatePastDate,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number *',
              hintText: '1234567890',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: FormValidators.validatePhoneNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoStep() {
    return Form(
      key: _accountInfoFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address *',
              hintText: 'your.email@example.com',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username *',
              hintText: 'Choose a unique username',
              prefixIcon: Icon(Icons.account_circle),
              border: OutlineInputBorder(),
            ),
            validator: (value) => FormValidators.combine([
              (v) => FormValidators.validateRequired(v, fieldName: 'Username'),
              (v) => FormValidators.validateLengthRange(
                    v,
                    4,
                    20,
                    fieldName: 'Username',
                  ),
              (v) => FormValidators.validateAlphanumeric(v, fieldName: 'Username'),
            ])(value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password *',
              hintText: 'Enter a strong password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              border: const OutlineInputBorder(),
              helperText: 'Min 8 chars, uppercase, lowercase & number',
              helperMaxLines: 2,
            ),
            obscureText: _obscurePassword,
            validator: (value) => FormValidators.validatePassword(
              value,
              minLength: 8,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password *',
              hintText: 'Re-enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() =>
                      _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),
              border: const OutlineInputBorder(),
            ),
            obscureText: _obscureConfirmPassword,
            validator: (value) => FormValidators.validatePasswordConfirmation(
              value,
              _passwordController.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return Form(
      key: _addressFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _addressLine1Controller,
            decoration: const InputDecoration(
              labelText: 'Address Line 1 *',
              hintText: 'Street address, P.O. box',
              prefixIcon: Icon(Icons.home),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) => FormValidators.validateRequired(
              value,
              fieldName: 'Address Line 1',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressLine2Controller,
            decoration: const InputDecoration(
              labelText: 'Address Line 2 (Optional)',
              hintText: 'Apartment, suite, unit, building',
              prefixIcon: Icon(Icons.home_outlined),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City *',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    fieldName: 'City',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State *',
                    prefixIcon: Icon(Icons.map),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) => FormValidators.validateRequired(
                    value,
                    fieldName: 'State',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _zipController,
                  decoration: const InputDecoration(
                    labelText: 'ZIP Code *',
                    prefixIcon: Icon(Icons.pin),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (value) => FormValidators.combine([
                    (v) =>
                        FormValidators.validateRequired(v, fieldName: 'ZIP Code'),
                    (v) => FormValidators.validateMinLength(
                          v,
                          5,
                          fieldName: 'ZIP Code',
                        ),
                  ])(value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: const InputDecoration(
                    labelText: 'Country *',
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Select'),
                  items: _countries.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCountry = value),
                  validator: (value) {
                    if (value == null) {
                      return 'Select country';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onStepContinue() {
    bool isValid = false;

    // Validate current step
    switch (_currentStep) {
      case 0:
        isValid = _personalInfoFormKey.currentState?.validate() ?? false;
        break;
      case 1:
        isValid = _accountInfoFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = _addressFormKey.currentState?.validate() ?? false;
        break;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors before continuing'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      // Final submission
      _submitForm();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _onStepTapped(int step) {
    setState(() => _currentStep = step);
  }

  void _submitForm() {
    setState(() => _isComplete = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Registration Complete!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your account has been created successfully!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Summary:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Divider(),
              _buildSummarySection('Personal Information', [
                'Name: ${_firstNameController.text} ${_lastNameController.text}',
                'Gender: ${_selectedGender ?? 'N/A'}',
                'DOB: ${_dobController.text}',
                'Phone: ${_phoneController.text}',
              ]),
              _buildSummarySection('Account Information', [
                'Email: ${_emailController.text}',
                'Username: ${_usernameController.text}',
              ]),
              _buildSummarySection('Address', [
                _addressLine1Controller.text,
                if (_addressLine2Controller.text.isNotEmpty)
                  _addressLine2Controller.text,
                '${_cityController.text}, ${_stateController.text} ${_zipController.text}',
                _selectedCountry ?? '',
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Text(item, style: const TextStyle(fontSize: 13)),
              )),
        ],
      ),
    );
  }

  void _resetForm() {
    _personalInfoFormKey.currentState?.reset();
    _accountInfoFormKey.currentState?.reset();
    _addressFormKey.currentState?.reset();

    _firstNameController.clear();
    _lastNameController.clear();
    _dobController.clear();
    _phoneController.clear();
    _emailController.clear();
    _usernameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _addressLine1Controller.clear();
    _addressLine2Controller.clear();
    _cityController.clear();
    _stateController.clear();
    _zipController.clear();

    setState(() {
      _currentStep = 0;
      _isComplete = false;
      _selectedGender = null;
      _selectedCountry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Step Form'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Progress Indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: Colors.grey.shade200,
            minHeight: 6,
          ),
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: _onStepContinue,
              onStepCancel: _onStepCancel,
              onStepTapped: _onStepTapped,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: _currentStep > 0 ? 1 : 2,
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(_currentStep == 2 ? 'Submit' : 'Continue'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              steps: _getSteps(),
            ),
          ),
        ],
      ),
    );
  }
}
