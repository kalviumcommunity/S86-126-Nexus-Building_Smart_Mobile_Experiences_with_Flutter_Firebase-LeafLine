import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/form_validators.dart';

/// Comprehensive Forms Validation Demo Screen
/// 
/// Demonstrates:
/// - Multiple form field types with validation
/// - Email, password, phone, URL validation
/// - Cross-field validation (password confirmation)
/// - Real-time validation
/// - Custom validators
/// - Input formatters
/// - Form submission handling
class FormsValidationDemo extends StatefulWidget {
  const FormsValidationDemo({super.key});

  @override
  State<FormsValidationDemo> createState() => _FormsValidationDemoState();
}

class _FormsValidationDemoState extends State<FormsValidationDemo> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _websiteController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();

  // Form state
  bool _autoValidate = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  String? _selectedCountry;
  String? _selectedGender;

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

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void dispose() {
    _scrollController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _websiteController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() => _autoValidate = true);

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to terms and conditions'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Success!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Form submitted successfully with the following data:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDataRow('Name', _fullNameController.text),
            _buildDataRow('Email', _emailController.text),
            _buildDataRow('Phone', _phoneController.text),
            _buildDataRow('Country', _selectedCountry ?? 'Not selected'),
            _buildDataRow('Gender', _selectedGender ?? 'Not selected'),
            _buildDataRow('Age', _ageController.text),
            if (_websiteController.text.isNotEmpty)
              _buildDataRow('Website', _websiteController.text),
            if (_bioController.text.isNotEmpty)
              _buildDataRow('Bio', _bioController.text),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _websiteController.clear();
    _ageController.clear();
    _bioController.clear();
    setState(() {
      _autoValidate = false;
      _selectedCountry = null;
      _selectedGender = null;
      _agreeToTerms = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms Validation Demo'),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.edit_note, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Registration Form',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Demonstrating various validation techniques',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) => FormValidators.combine([
                  (v) => FormValidators.validateRequired(v, fieldName: 'Full name'),
                  (v) => FormValidators.validateMinLength(v, 3, fieldName: 'Full name'),
                  (v) => FormValidators.validateAlphabetic(v, fieldName: 'Full name'),
                ])(value),
              ),
              const SizedBox(height: 16),

              // Email
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

              // Phone Number
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number *',
                  hintText: '1234567890',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  helperText: 'Enter 10-digit phone number',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: FormValidators.validatePhoneNumber,
              ),
              const SizedBox(height: 16),

              // Country Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                decoration: const InputDecoration(
                  labelText: 'Country *',
                  prefixIcon: Icon(Icons.flag),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select your country'),
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCountry = value),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender Radio Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gender *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _genders.map((gender) {
                      return ChoiceChip(
                        label: Text(gender),
                        selected: _selectedGender == gender,
                        onSelected: (selected) {
                          setState(() {
                            _selectedGender = selected ? gender : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  if (_autoValidate && _selectedGender == null)
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 8),
                      child: Text(
                        'Please select a gender',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Age
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age *',
                  hintText: 'Enter your age',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                  helperText: 'Must be between 13 and 120',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (value) => FormValidators.validateNumberRange(
                  value,
                  13,
                  120,
                  fieldName: 'Age',
                ),
              ),
              const SizedBox(height: 16),

              // Password
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
                  helperText: 'Min 8 chars, with uppercase, lowercase & number',
                  helperMaxLines: 2,
                ),
                obscureText: _obscurePassword,
                validator: (value) => FormValidators.validatePassword(value, minLength: 8),
              ),
              const SizedBox(height: 16),

              // Confirm Password
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
              const SizedBox(height: 16),

              // Website (Optional)
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website (Optional)',
                  hintText: 'https://example.com',
                  prefixIcon: Icon(Icons.language),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return FormValidators.validateUrl(value);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bio (Optional)
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio (Optional)',
                  hintText: 'Tell us about yourself',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                maxLength: 200,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return FormValidators.validateMinLength(
                      value,
                      10,
                      fieldName: 'Bio',
                    );
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Terms and Conditions
              CheckboxListTile(
                value: _agreeToTerms,
                onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                title: const Text('I agree to the Terms and Conditions'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                subtitle: !_agreeToTerms && _autoValidate
                    ? const Text(
                        'You must agree to continue',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit Form',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Reset Button
              OutlinedButton(
                onPressed: _resetForm,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Reset Form',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Info Card
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'All validations happen in real-time. Try submitting with empty fields to see error messages.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Validation Features'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFeatureItem('✓ Required field validation'),
              _buildFeatureItem('✓ Email format validation'),
              _buildFeatureItem('✓ Phone number format (10 digits)'),
              _buildFeatureItem('✓ Password strength requirements'),
              _buildFeatureItem('✓ Password confirmation matching'),
              _buildFeatureItem('✓ URL format validation'),
              _buildFeatureItem('✓ Number range validation (age)'),
              _buildFeatureItem('✓ Min/max length validation'),
              _buildFeatureItem('✓ Alphabetic character validation'),
              _buildFeatureItem('✓ Input formatters (digits only)'),
              _buildFeatureItem('✓ Dropdown validation'),
              _buildFeatureItem('✓ Radio button validation'),
              _buildFeatureItem('✓ Checkbox validation'),
              _buildFeatureItem('✓ Real-time error feedback'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text),
    );
  }
}
