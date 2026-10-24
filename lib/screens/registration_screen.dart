import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Global Key & Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? _selectedDate;
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State Variables
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _agreeTerms = false;
  bool _showTermsError = false;
  int _passwordStrength = 0;

  int _calculateStrength(String value) {
    if (value.isEmpty) return 0;
    if (value.length < 8) return 1;

    final hasUpper = value.contains(RegExp(r'[A-Z]'));
    final hasLower = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'[0-9]'));
    final hasSymbol = value.contains(RegExp(r'[^A-Za-z0-9]'));

    if (hasUpper && hasLower && hasDigit && hasSymbol) return 3;
    if ((hasUpper || hasLower) && hasDigit) return 2;
    return 1;
  }

  String get _strengthLabel =>
      const ['', 'Lemah', 'Sedang', 'Kuat'][_passwordStrength];

  Color get _strengthColor =>
      [Colors.grey, Colors.red, Colors.orange, Colors.green][_passwordStrength];

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- VALIDATION METHODS ---

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _selectedGender;
   final List<String> _genders = ['Laki-laki', 'Perempuan'];

  String? _validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Nomor telepon tidak boleh kosong';
  }
  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
    return 'Nomor telepon hanya boleh berisi angka';
  }
  if (value.trim().length < 10 || value.trim().length > 13) {
    return 'Nomor telepon harus 10–13 digit';
  }
  return null;
}

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // --- FORM HANDLERS ---

  void _submitForm() {
    final isFormValid = _formKey.currentState!.validate();
    if (!_agreeTerms) {
      setState(() {
        _showTermsError = true;
      });
    }

    if (isFormValid && _agreeTerms) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi proses registrasi
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        // Tampilkan dialog sukses
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registrasi Berhasil'),
            content: Text(
              'Selamat, ${_nameController.text}!\n'
              'Email: ${_emailController.text}',
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
      });
    }
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedDate = picked;
      _birthDateController.text =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _birthDateController.clear();
    _selectedDate = null;
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();

    setState(() {
      _selectedGender = null;
      _agreeTerms = false;
      _showTermsError = false;
      _passwordStrength = 0;
    });
  }

  // --- UI BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                const SizedBox(height: 16),
                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Isi form di bawah ini untuk mendaftar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Field Nama
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person,
                  validator: _validateName,
                ),

                // Field Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                
                //field tanggal lahir
                Padding(
                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                   child: TextFormField(
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: _pickBirthDate,
                    decoration: InputDecoration(
                       labelText: 'Tanggal Lahir',
                       hintText: 'Pilih tanggal lahir',
                       prefixIcon: const Icon(Icons.cake),
                       suffixIcon: const Icon(Icons.calendar_today),
                       border: const OutlineInputBorder(),
                       filled: true,
                       fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                    return 'Tanggal lahir tidak boleh kosong';
                    }
                    return null;
                      },
                    ),
                 ),
                
                Padding(
                   padding: const EdgeInsets.symmetric(vertical: 8.0),
                   child: DropdownButtonFormField<String>(
                   initialValue: _selectedGender,
                   decoration: InputDecoration(
                     labelText: 'Jenis Kelamin',
                     prefixIcon: const Icon(Icons.wc),
                     border: const OutlineInputBorder(),
                     filled: true,
                     fillColor: Colors.grey[50],
                ),
                hint: const Text('Pilih jenis kelamin'),
                items: _genders
                 .map((g) => DropdownMenuItem<String>(value: g, child: Text(g)))
                 .toList(),
                onChanged: (value) {
                setState(() {
                _selectedGender = value;
                });
               },
               validator: (value) {
               if (value == null) {
               return 'Jenis kelamin wajib dipilih';
                }
               return null;
              },
            ),
          ),

                CustomTextField(
                 controller: _phoneController,
                 label: 'Nomor Telepon',
                 hint: 'Masukkan nomor telepon Anda',
                 prefixIcon: Icons.phone,
                 keyboardType: TextInputType.phone,
                 validator: _validatePhone,
                ),

                // Field Password
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'Password',
                  hintText: 'Minimal 8 karakter, huruf kapital, angka',
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  onChanged: (value) {
                    final strength = _calculateStrength(value);
                    if (strength != _passwordStrength) {
                      setState(() {
                        _passwordStrength = strength;
                      });
                    }
                  },
                  validator: _validatePassword,
                ),
                if (_passwordStrength > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: _passwordStrength / 3,
                        color: _strengthColor,
                        backgroundColor: Colors.grey[300],
                        minHeight: 6,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kekuatan password: $_strengthLabel',
                        style: TextStyle(
                          color: _strengthColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                // Field Konfirmasi Password
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Password',
                  hintText: 'Ulangi password Anda',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  validator: _validateConfirmPassword,
                ),

                const SizedBox(height: 24),

                // Tombol Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Daftar',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 12),

                // Tombol Reset
                OutlinedButton(
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      value: _agreeTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeTerms = value ?? false;
                          if (_agreeTerms) _showTermsError = false;
                        });
                      },
                      title: const Text(
                        'Saya setuju dengan Syarat & Ketentuan',
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_showTermsError)
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Anda harus menyetujui Syarat & Ketentuan',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGET METHOD ---
  // Membantu mereduksi duplikasi kode untuk Input Password & Konfirmasi Password
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    IconData prefixIcon = Icons.lock,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    void Function(String)? onChanged,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: onToggleVisibility,
          ),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}