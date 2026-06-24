import '../state/app_state.dart';
import 'package:flutter/material.dart';
import '../state/app_state.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  bool _submitted = false;
  bool _submitting = false;
  String? _selectedGender;
  String? _lastValidationError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = View.of(context).viewInsets.bottom;
    appState.log('KEYBOARD', 'View insets changed: bottom=$bottomInset (${bottomInset > 0 ? "keyboard VISIBLE" : "keyboard HIDDEN"})', color: Colors.cyan);
  }

  void _submit() {
    if (_submitting) return;
    setState(() => _submitting = true);

    if (!_formKey.currentState!.validate()) {
      appState.log('FORM', 'Validation FAILED: $_lastValidationError', color: Colors.red);
      setState(() { _submitted = true; _submitting = false; });
      return;
    }

    setState(() => _submitted = true);
    appState.log('FORM', 'SUBMITTED — Name: ${_nameCtrl.text}, Email: ${_emailCtrl.text}, Gender: ${_selectedGender ?? "N/A"}, Phone: ${_phoneCtrl.text.isEmpty ? "N/A" : _phoneCtrl.text}', color: Colors.green);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Form submitted successfully!'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: 'OK', onPressed: () {}),
        duration: const Duration(seconds: 3),
      ),
    );

    setState(() => _submitting = false);
  }

  void _reset() {
    appState.log('FORM', 'Form reset requested', color: Colors.orange);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Form?'),
        content: const Text('All entered data will be cleared.'),
        actions: [
          TextButton(
            onPressed: () { appState.log('FORM', 'Reset cancelled', color: Colors.grey); Navigator.pop(ctx); },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _formKey.currentState!.reset();
                _nameCtrl.clear();
                _emailCtrl.clear();
                _phoneCtrl.clear();
                _bioCtrl.clear();
                _selectedGender = null;
                _submitted = false;
                _lastValidationError = null;
              });
              appState.log('FORM', 'Form reset complete', color: Colors.orange);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) { _lastValidationError = 'Name required'; return 'Name is required'; }
    if (v.trim().length < 2) { _lastValidationError = 'Name too short'; return 'Name must be at least 2 characters'; }
    if (v.trim().length > 80) { _lastValidationError = 'Name too long'; return 'Name must be under 80 characters'; }
    if (!RegExp(r"^[a-zA-Z\s\-\'\.]+$").hasMatch(v.trim())) { _lastValidationError = 'Name invalid chars'; return 'Only letters, spaces, hyphens, apostrophes, and periods'; }
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) { _lastValidationError = 'Email required'; return 'Email is required'; }
    final email = v.trim();
    if (email.length > 254) { _lastValidationError = 'Email too long'; return 'Email too long'; }
    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$").hasMatch(email)) {
      _lastValidationError = 'Email invalid format';
      return 'Enter a valid email (e.g., name@domain.com)';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final cleaned = v.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.isEmpty) return null;
    if (!RegExp(r'^\+?\d{7,15}$').hasMatch(cleaned)) { _lastValidationError = 'Phone invalid'; return 'Enter a valid phone (7-15 digits, optional +)'; }
    return null;
  }

  String? _validateBio(String? v) {
    if (v == null || v.isEmpty) return null;
    if (v.length > 200) { _lastValidationError = 'Bio too long'; return 'Bio must be under 200 characters'; }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.refresh), tooltip: 'Reset form', onPressed: _reset)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_submitted)
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Form submitted! Check logs for details.', style: TextStyle(fontWeight: FontWeight.w600))),
                    ]),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  hintText: 'John Doe',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
                textInputAction: TextInputAction.next,
                onChanged: (_) => appState.log('FORM', 'Name field changed', color: Colors.blue.shade300),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  hintText: 'john@example.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                textInputAction: TextInputAction.next,
                onChanged: (_) => appState.log('FORM', 'Email field changed', color: Colors.blue.shade300),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(
                  labelText: 'Phone (optional)',
                  hintText: '+1 555-0123',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
                textInputAction: TextInputAction.next,
                onChanged: (_) => appState.log('FORM', 'Phone field changed', color: Colors.blue.shade300),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Non-binary', 'Prefer not to say']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) {
                  setState(() => _selectedGender = v);
                  appState.log('FORM', 'Gender selected: $v', color: Colors.blue.shade300);
                },
                validator: (v) {
                  if (v == null) { _lastValidationError = 'Gender required'; return 'Please select a gender'; }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioCtrl,
                decoration: const InputDecoration(
                  labelText: 'Bio (max 200 chars)',
                  hintText: 'Tell us about yourself...',
                  prefixIcon: Icon(Icons.edit),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                maxLength: 200,
                validator: _validateBio,
                onChanged: (_) => appState.log('FORM', 'Bio field changed', color: Colors.blue.shade300),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'I agree to the Terms and Conditions. Currently ${appState.agreedToTerms ? "checked" : "unchecked"}.',
                child: CheckboxListTile(
                  value: appState.agreedToTerms,
                  onChanged: (v) => appState.setAgreedToTerms(v ?? false),
                  title: const Text('I agree to the Terms & Conditions *'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (!appState.agreedToTerms && _submitted)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('You must agree to the terms',
                    style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send),
                label: Text(_submitting ? 'Submitting...' : 'Submit'),
                style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: _submitting ? null : _reset, child: const Text('Reset Form')),
            ],
          ),
        ),
      ),
    );
  }
}
