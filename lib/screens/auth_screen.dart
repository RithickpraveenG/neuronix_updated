import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../widgets/neuronix_button.dart';
import '../widgets/neuronix_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'patient@example.com');
  final _passwordController = TextEditingController(text: 'demo123');
  bool _isLogin = true;
  bool _isLoading = false;
  String _selectedRole = 'patient';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
      if (_isLogin) {
        _emailController.text = role == 'doctor' ? 'doctor@example.com' : 'patient@example.com';
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();

    try {
      if (_isLogin) {
        await auth.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await auth.register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole,
        );
      }

      if (!mounted) return;
      final targetRole = auth.role.isNotEmpty ? auth.role : _selectedRole;
      context.go(targetRole == 'doctor' ? '/doctor' : '/patient');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication note: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: const Color(0xFF1E293B),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E88E5),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1E88E5).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.local_hospital, color: Colors.white, size: 32),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'NEURONIX',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isLogin
                                ? 'Sign in to your intelligent healthcare portal'
                                : 'Create your secure healthcare account',
                            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Role Selection Cards
                    Text(
                      'I am logging in as a:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectRole('patient'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'patient'
                                    ? const Color(0xFF1E88E5).withOpacity(0.08)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _selectedRole == 'patient'
                                      ? const Color(0xFF1E88E5)
                                      : const Color(0xFFE2E8F0),
                                  width: _selectedRole == 'patient' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: _selectedRole == 'patient'
                                        ? const Color(0xFF1E88E5)
                                        : const Color(0xFF64748B),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Patient',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _selectedRole == 'patient'
                                          ? const Color(0xFF1E88E5)
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectRole('doctor'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'doctor'
                                    ? const Color(0xFF00B4D8).withOpacity(0.08)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _selectedRole == 'doctor'
                                      ? const Color(0xFF00B4D8)
                                      : const Color(0xFFE2E8F0),
                                  width: _selectedRole == 'doctor' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.medical_information_outlined,
                                    color: _selectedRole == 'doctor'
                                        ? const Color(0xFF00B4D8)
                                        : const Color(0xFF64748B),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Doctor / Clinician',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _selectedRole == 'doctor'
                                          ? const Color(0xFF00B4D8)
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Inputs
                    NeuronixCard(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (val) =>
                                val != null && val.contains('@') ? null : 'Enter a valid email address',
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (val) =>
                                val != null && val.length >= 4 ? null : 'Password must be at least 4 characters',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action Button
                    NeuronixButton(
                      label: _isLogin ? 'Sign In as ${_selectedRole.toUpperCase()}' : 'Create Account',
                      isLoading: _isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 12),

                    // Toggle & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          child: Text(
                            _isLogin ? 'Need an account? Register' : 'Existing user? Sign In',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (_isLogin)
                          TextButton(
                            onPressed: () async {
                              final email = _emailController.text.trim();
                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter your email address first.')),
                                );
                                return;
                              }
                              await context.read<AuthService>().forgotPassword(email: email);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password reset instructions requested.')),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Color(0xFF64748B)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
