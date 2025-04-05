

// views/sharing/share_task_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_todo/viewmodels/sharing_viewmodel.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:collaborative_todo/views/widgets/responsive_container.dart';

class ShareTaskScreen extends StatefulWidget {
 final Task task;

 const ShareTaskScreen({
 Key? key,
 required this.task,
 }) : super(key: key);

 @override
 _ShareTaskScreenState createState() => _ShareTaskScreenState();
}

class _ShareTaskScreenState extends State<ShareTaskScreen> {
 final TextEditingController _emailController = TextEditingController();
 final _formKey = GlobalKey<FormState>();

 @override
 void initState() {
 super.initState();
 WidgetsBinding.instance.addPostFrameCallback((_) {
 Provider.of<SharingViewModel>(context, listen: false)
 .loadSharedUsers(widget.task);
 });
 }

 @override
 Widget build(BuildContext context) {
 final sharingViewModel = Provider.of<SharingViewModel>(context);

 return Scaffold(
 appBar: AppBar(
 title: Text('Share Task'),
 ),
 body: ResponsiveContainer(
 padding: EdgeInsets.all(16),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 'Task: ${widget.task.title}',
 style: TextStyle(
 fontSize: 20,
 fontWeight: FontWeight.bold,
 ),
 ),
 SizedBox(height: 24),
 Form(
 key: _formKey,
 child: Column(
 children: [
 TextFormField(
 controller: _emailController,
 decoration: InputDecoration(
 labelText: 'Email Address',
 hintText: 'Enter email to share with',
 border: OutlineInputBorder(),
 prefixIcon: Icon(Icons.email),
 ),
 keyboardType: TextInputType.emailAddress,
 validator: (value) {
 if (value == null || value.isEmpty) {
 return 'Please enter an email address';
 }
 if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
 .hasMatch(value)) {
 return 'Please enter a valid email address';
 }
 return null;
 },
 ),
 SizedBox(height: 16),
 ElevatedButton(
 onPressed: sharingViewModel.isLoading
 ? null
 : () async {
 if (_formKey.currentState!.validate()) {
 try {
 await sharingViewModel.shareTaskWithUser(
 widget.task.id,
 _emailController.text.trim(),
 );
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('Task shared successfully'),
 backgroundColor: Colors.green,
 ),
 );
 _emailController.clear();
 // Reload the shared users list
 await sharingViewModel.loadSharedUsers(widget.task);
 } catch (e) {
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('Error: ${e.toString()}'),
 backgroundColor: Colors.red,
 ),
 );
 }
 }
 },
 child: Text('Share Task'),
 style: ElevatedButton.styleFrom(
 minimumSize: Size(double.infinity, 50),
 ),
 ),
 ],
 ),
 ),
 SizedBox(height: 24),
 Text(
 'External Sharing',
 style: TextStyle(
 fontSize: 18,
 fontWeight: FontWeight.bold,
 ),
 ),
 SizedBox(height: 16),
 OutlinedButton.icon(
 onPressed: () {
 sharingViewModel.shareTaskExternally(widget.task);
 },
 icon: Icon(Icons.share),
 label: Text('Share via...'),
 style: OutlinedButton.styleFrom(
 minimumSize: Size(double.infinity, 50),
 ),
 ),
 SizedBox(height: 24),
 Text(
 'Currently shared with',
 style: TextStyle(
 fontSize: 18,
 fontWeight: FontWeight.bold,
 ),
 ),
 SizedBox(height: 8),
 Expanded(
 child: sharingViewModel.isLoading
 ? Center(child: CircularProgressIndicator())
 : sharingViewModel.sharedUsers.isEmpty
 ? Center(child: Text('Not shared with anyone yet'))
 : ListView.builder(
 itemCount: sharingViewModel.sharedUsers.length,
 itemBuilder: (context, index) {
 final user = sharingViewModel.sharedUsers[index];
 return ListTile(
 leading: CircleAvatar(
 child: Text(user.displayName[0].toUpperCase()),
 ),
 title: Text(user.displayName),
 subtitle: Text(user.email),
 trailing: IconButton(
 icon: Icon(Icons.remove_circle, color: Colors.red),
 onPressed: () {
 _showRemoveDialog(context, user.id, user.displayName);
 },
 ),
 );
 },
 ),
 ),
 ],
 ),
 ),
 );
 }

 void _showRemoveDialog(BuildContext context, String userId, String userName) {
 showDialog(
 context: context,
 builder: (context) => AlertDialog(
 title: Text('Remove Sharing'),
 content: Text('Are you sure you want to remove sharing with $userName?'),
 actions: [
 TextButton(
 onPressed: () {
 Navigator.pop(context);
 },
 child: Text('CANCEL'),
 ),
 TextButton(
 onPressed: () async {
 Navigator.pop(context);
 try {
 await Provider.of<SharingViewModel>(context, listen: false)
 .unshareTaskWithUser(widget.task.id, userId);
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('User removed successfully'),
 backgroundColor: Colors.green,
 ),
 );
 } catch (e) {
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('Error: ${e.toString()}'),
 backgroundColor: Colors.red,
 ),
 );
 }
 },
 child: Text('REMOVE'),
 ),
 ],
 ),
 );
 }
}