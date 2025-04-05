
// views/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_todo/viewmodels/auth_viewmodel.dart';
import 'package:collaborative_todo/views/widgets/responsive_container.dart';

class RegisterScreen extends StatefulWidget {
 @override
 _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 final TextEditingController _nameController = TextEditingController();
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
 final TextEditingController _confirmPasswordController = TextEditingController();
 final _formKey = GlobalKey<FormState>();
 bool _obscurePassword = true;
 bool _obscureConfirmPassword = true;

 @override
 void dispose() {
 _nameController.dispose();
 _emailController.dispose();
 _passwordController.dispose();
 _confirmPasswordController.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 final authViewModel = Provider.of<AuthViewModel>(context);

 return Scaffold(
 appBar: AppBar(
 title: Text('Register'),
 ),
 body: ResponsiveContainer(
 padding: EdgeInsets.all(16),
 child: Center(
 child: SingleChildScrollView(
 child: Form(
 key: _formKey,
 child: Column(
 mainAxisAlignment: MainAxisAlignment.center,
 crossAxisAlignment: CrossAxisAlignment.stretch,
 children: [
 // Name Field
 TextFormField(
 controller: _nameController,
 decoration: InputDecoration(
 labelText: 'Name',
 border: OutlineInputBorder(),
 prefixIcon: Icon(Icons.person),
 ),
 validator: (value) {
 if (value == null || value.isEmpty) {
 return 'Please enter your name';
 }
 return null;
 },
 ),
 SizedBox(height: 16),
 
 // Email Field
 TextFormField(
 controller: _emailController,
 decoration: InputDecoration(
 labelText: 'Email',
 border: OutlineInputBorder(),
 prefixIcon: Icon(Icons.email),
 ),
 keyboardType: TextInputType.emailAddress,
 validator: (value) {
 if (value == null || value.isEmpty) {
 return 'Please enter your email';
 }
 if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
 .hasMatch(value)) {
 return 'Please enter a valid email';
 }
 return null;
 },
 ),
 SizedBox(height: 16),
 
 // Password Field
 TextFormField(
 controller: _passwordController,
 obscureText: _obscurePassword,
 decoration: InputDecoration(
 labelText: 'Password',
 border: OutlineInputBorder(),
 prefixIcon: Icon(Icons.lock),
 suffixIcon: IconButton(
 icon: Icon(
 _obscurePassword
 ? Icons.visibility
 : Icons.visibility_off,
 ),
 onPressed: () {
 setState(() {
 _obscurePassword = !_obscurePassword;
 });
 },
 ),
 ),
 validator: (value) {
 if (value == null || value.isEmpty) {
 return 'Please enter a password';
 }
 if (value.length < 6) {
 return 'Password must be at least 6 characters';
 }
 return null;
 },
 ),
 SizedBox(height: 16),
 
 // Confirm Password Field
 TextFormField(
 controller: _confirmPasswordController,
 obscureText: _obscureConfirmPassword,
 decoration: InputDecoration(
 labelText: 'Confirm Password',
 border: OutlineInputBorder(),
 prefixIcon: Icon(Icons.lock_outline),
 suffixIcon: IconButton(
 icon: Icon(
 _obscureConfirmPassword
 ? Icons.visibility
 : Icons.visibility_off,
 ),
 onPressed: () {
 setState(() {
 _obscureConfirmPassword = !_obscureConfirmPassword;
 });
 },
 ),
 ),
 validator: (value) {
 if (value == null || value.isEmpty) {
 return 'Please confirm your password';
 }
 if (value != _passwordController.text) {
 return 'Passwords do not match';
 }
 return null;
 },
 ),
 
 // Error message
 if (authViewModel.error != null) ...[
 SizedBox(height: 16),
 Text(
 authViewModel.error!,
 style: TextStyle(color: Colors.red),
 textAlign: TextAlign.center,
 ),
 ],
 
 // Register Button
 SizedBox(height: 24),
 ElevatedButton(
 onPressed: authViewModel.isLoading
 ? null
 : () async {
 if (_formKey.currentState!.validate()) {
 try {
 await authViewModel.register(
 _emailController.text.trim(),
 _passwordController.text,
 _nameController.text.trim(),
 );
 // Navigate to task list on successful registration
 Navigator.pushReplacementNamed(
 context,
 '/tasks',
 );
 } catch (e) {
 // Error is already handled in the ViewModel
 }
 }
 },
 child: authViewModel.isLoading
 ? CircularProgressIndicator(color: Colors.white)
 : Text('REGISTER'),
 style: ElevatedButton.styleFrom(
 padding: EdgeInsets.symmetric(vertical: 16),
 ),
 ),
 
 // Login link
 SizedBox(height: 16),
 Row(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 Text('Already have an account?'),
 TextButton(
 onPressed: () {
 Navigator.pop(context);
 },
 child: Text('SIGN IN'),
 ),
 ],
 ),
 ],
 ),
 ),
 ),
 ),
 ),
 );
 }
}