

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_todo/viewmodels/auth_viewmodel.dart';
import 'package:collaborative_todo/views/widgets/responsive_container.dart';

class LoginScreen extends StatefulWidget {
 @override
 _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
 final _formKey = GlobalKey<FormState>();
 bool _obscurePassword = true;

 @override
 void dispose() {
 _emailController.dispose();
 _passwordController.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 final authViewModel = Provider.of<AuthViewModel>(context);

 return Scaffold(
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
 // Logo or App Title
 Icon(
 Icons.check_circle_outline,
 size: 80,
 color: Theme.of(context).primaryColor,
 ),
 SizedBox(height: 16),
 Text(
 'Collaborative TODO',
 textAlign: TextAlign.center,
 style: TextStyle(
 fontSize: 24,
 fontWeight: FontWeight.bold,
 ),
 ),
 SizedBox(height: 48),
 
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
 return 'Please enter your password';
 }
 if (value.length < 6) {
 return 'Password must be at least 6 characters';
 }
 return null;
 },
 ),
 SizedBox(height: 8),
 
 // Error message
 if (authViewModel.error != null) ...[
 SizedBox(height: 8),
 Text(
 authViewModel.error!,
 style: TextStyle(color: Colors.red),
 textAlign: TextAlign.center,
 ),
 SizedBox(height: 8),
 ],
 
 // Sign In Button
 SizedBox(height: 24),
 ElevatedButton(
 onPressed: authViewModel.isLoading
 ? null
 : () async {
 if (_formKey.currentState!.validate()) {
 try {
 await authViewModel.signIn(
 _emailController.text.trim(),
 _passwordController.text,
 );
 // Navigate to task list on successful login
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
 : Text('SIGN IN'),
 style: ElevatedButton.styleFrom(
 padding: EdgeInsets.symmetric(vertical: 16),
 ),
 ),
 
 // Register link
 SizedBox(height: 24),
 Row(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 Text("Don't have an account?"),
 TextButton(
 onPressed: () {
 Navigator.pushNamed(context, '/register');
 },
 child: Text('REGISTER'),
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