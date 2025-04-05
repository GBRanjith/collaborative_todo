
// views/sharing/shared_with_me_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_todo/viewmodels/auth_viewmodel.dart';
import 'package:collaborative_todo/viewmodels/task_list_viewmodel.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:collaborative_todo/views/widgets/task_item.dart';
import 'package:collaborative_todo/views/widgets/responsive_container.dart';

class SharedWithMeScreen extends StatefulWidget {
 @override
 _SharedWithMeScreenState createState() => _SharedWithMeScreenState();
}

class _SharedWithMeScreenState extends State<SharedWithMeScreen> {
 @override
 void initState() {
 super.initState();
 // Initialize shared tasks for the current user
 WidgetsBinding.instance.addPostFrameCallback((_) {
 final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
 final taskListViewModel = Provider.of<TaskListViewModel>(context, listen: false);
 
 if (authViewModel.user != null) {
 taskListViewModel.initTasks(authViewModel.user!.uid);
 }
 });
 }

 @override
 Widget build(BuildContext context) {
 final taskListViewModel = Provider.of<TaskListViewModel>(context);
 
 // Filter for tasks shared with the current user (not owned)
 final sharedTasks = taskListViewModel.tasks.where((task) {
 final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
 return task.ownerId != authViewModel.user?.uid && 
 task.sharedWith.contains(authViewModel.user?.uid);
 }).toList();

 return Scaffold(
 appBar: AppBar(
 title: Text('Shared With Me'),
 ),
 body: ResponsiveContainer(
 child: taskListViewModel.isLoading
 ? Center(child: CircularProgressIndicator())
 : taskListViewModel.error != null
 ? Center(child: Text('Error: ${taskListViewModel.error}'))
 : sharedTasks.isEmpty
 ? Center(
 child: Column(
 mainAxisAlignment: MainAxisAlignment.center,
 children: [
 Icon(
 Icons.share,
 size: 64,
 color: Colors.grey,
 ),
 SizedBox(height: 16),
 Text(
 'No tasks have been shared with you yet',
 style: TextStyle(
 fontSize: 16,
 color: Colors.grey[700],
 ),
 textAlign: TextAlign.center,
 ),
 ],
 ),
 )
 : ListView.builder(
 itemCount: sharedTasks.length,
 itemBuilder: (context, index) {
 Task task = sharedTasks[index];
 return TaskItem(
 task: task,
 onToggle: () {
 taskListViewModel.toggleTaskCompletion(task);
 },
 onTap: () {
 Navigator.pushNamed(
 context,
 '/task-detail',
 arguments: task.id,
 );
 },
 );
 },
 ),
 ),
 );
 }
}
