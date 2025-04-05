


// views/tasks/task_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:collaborative_todo/services/task_service.dart';
import 'package:collaborative_todo/viewmodels/auth_viewmodel.dart';
import 'package:collaborative_todo/views/widgets/responsive_container.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatefulWidget {
 final String taskId;

 const TaskDetailScreen({
 Key? key,
 required this.taskId,
 }) : super(key: key);

 @override
 _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
 final TaskService _taskService = TaskService();
 Task? _task;
 bool _isLoading = true;
 String? _error;

 @override
 void initState() {
 super.initState();
 _loadTask();
 }

 Future<void> _loadTask() async {
 setState(() {
 _isLoading = true;
 _error = null;
 });

 try {
 // Listen to task updates in real-time
 _taskService.getTaskById(widget.taskId).listen(
 (task) {
 if (mounted) {
 setState(() {
 _task = task;
 _isLoading = false;
 });
 }
 },
 onError: (e) {
 if (mounted) {
 setState(() {
 _error = e.toString();
 _isLoading = false;
 });
 }
 },
 );
 } catch (e) {
 if (mounted) {
 setState(() {
 _error = e.toString();
 _isLoading = false;
 });
 }
 }
 }

 @override
 Widget build(BuildContext context) {
 final authViewModel = Provider.of<AuthViewModel>(context);
 final bool isOwner = _task != null && _task!.ownerId == authViewModel.user?.uid;

 return Scaffold(
 appBar: AppBar(
 title: Text(_task?.title ?? 'Task Details'),
 actions: [
 if (_task != null && isOwner)
 IconButton(
 icon: Icon(Icons.share),
 onPressed: () {
 Navigator.pushNamed(
 context,
 '/share-task',
 arguments: _task,
 );
 },
 ),
 if (_task != null && isOwner)
 IconButton(
 icon: Icon(Icons.edit),
 onPressed: () {
 Navigator.pushNamed(
 context,
 '/edit-task',
 arguments: _task,
 );
 },
 ),
 if (_task != null && isOwner)
 IconButton(
 icon: Icon(Icons.delete),
 onPressed: () {
 _showDeleteDialog(context);
 },
 ),
 ],
 ),
 body: _isLoading
 ? Center(child: CircularProgressIndicator())
 : _error != null
 ? Center(child: Text('Error: $_error'))
 : _task == null
 ? Center(child: Text('Task not found'))
 : ResponsiveContainer(
 padding: EdgeInsets.all(16),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 _buildTaskHeader(),
 SizedBox(height: 24),
 _buildTaskDetails(),
 if (!isOwner) ...[
 SizedBox(height: 24),
 _buildOwnerInfo(),
 ],
 Spacer(),
 _buildActionButton(isOwner),
 ],
 ),
 ),
 );
 }

 Widget _buildTaskHeader() {
 return Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Row(
 children: [
 Expanded(
 child: Text(
 _task!.title,
 style: TextStyle(
 fontSize: 24,
 fontWeight: FontWeight.bold,
 ),
 ),
 ),
 Checkbox(
 value: _task!.isCompleted,
 onChanged: (bool? value) {
 _toggleTaskCompletion();
 },
 ),
 ],
 ),
 SizedBox(height: 8),
 Row(
 children: [
 Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
 SizedBox(width: 8),
 Text(
 'Due: ${DateFormat('MMM dd, yyyy').format(_task!.dueDate)}',
 style: TextStyle(
 color: _task!.dueDate.isBefore(DateTime.now()) && !_task!.isCompleted
 ? Colors.red
 : Colors.grey[600],
 fontWeight: _task!.dueDate.isBefore(DateTime.now()) && !_task!.isCompleted
 ? FontWeight.bold
 : FontWeight.normal,
 ),
 ),
 ],
 ),
 if (_task!.sharedWith.isNotEmpty) ...[
 SizedBox(height: 4),
 Row(
 children: [
 Icon(Icons.people, size: 18, color: Colors.blue),
 SizedBox(width: 8),
 Text(
 'Shared with ${_task!.sharedWith.length} people',
 style: TextStyle(color: Colors.blue),
 ),
 ],
 ),
 ],
 ],
 );
 }

 Widget _buildTaskDetails() {
 return Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 'Description',
 style: TextStyle(
 fontSize: 18,
 fontWeight: FontWeight.bold,
 ),
 ),
 SizedBox(height: 8),
 Container(
 padding: EdgeInsets.all(16),
 width: double.infinity,
 decoration: BoxDecoration(
 color: Colors.grey[200],
 borderRadius: BorderRadius.circular(8),
 ),
 child: Text(
 _task!.description.isNotEmpty ? _task!.description : 'No description provided',
 style: TextStyle(
 fontSize: 16,
 color: _task!.description.isNotEmpty ? Colors.black87 : Colors.grey,
 ),
 ),
 ),
 SizedBox(height: 16),
 Text(
 'Status',
 style: TextStyle(
 fontSize: 18,
 fontWeight: FontWeight.bold,
 ),
 ),
 SizedBox(height: 8),
 Container(
 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
 decoration: BoxDecoration(
 color: _task!.isCompleted ? Colors.green[100] : Colors.amber[100],
 borderRadius: BorderRadius.circular(16),
 ),
 child: Text(
 _task!.isCompleted ? 'Completed' : 'In Progress',
 style: TextStyle(
 color: _task!.isCompleted ? Colors.green[800] : Colors.amber[800],
 fontWeight: FontWeight.bold,
 ),
 ),
 ),
 ],
 );
 }

 Widget _buildOwnerInfo() {
 return Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 'Shared by',
 style: TextStyle(
 fontSize: 18,
 fontWeight: FontWeight.bold,
 ),
 ),
 SizedBox(height: 8),
 FutureBuilder(
 future: Provider.of<AuthViewModel>(context, listen: false)
 .getUserInfo(_task!.ownerId),
 builder: (context, snapshot) {
 if (snapshot.connectionState == ConnectionState.waiting) {
 return ListTile(
 leading: CircleAvatar(
 child: Icon(Icons.person),
 ),
 title: Text('Loading...'),
 );
 }
 
 if (snapshot.hasError || !snapshot.hasData) {
 return ListTile(
 leading: CircleAvatar(
 child: Icon(Icons.person),
 ),
 title: Text('Unknown User'),
 );
 }
 
 final owner = snapshot.data!;
 return ListTile(
 leading: CircleAvatar(
 child: Text(owner.displayName[0].toUpperCase()),
 ),
 title: Text(owner.displayName),
 subtitle: Text(owner.email),
 );
 },
 ),
 ],
 );
 }

 Widget _buildActionButton(bool isOwner) {
 return Container(
 width: double.infinity,
 child: ElevatedButton(
 onPressed: () {
 _toggleTaskCompletion();
 },
 child: Text(_task!.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete'),
 style: ElevatedButton.styleFrom(
 padding: EdgeInsets.symmetric(vertical: 16),
 backgroundColor: _task!.isCompleted ? Colors.amber : Colors.green,
 ),
 ),
 );
 }

 Future<void> _toggleTaskCompletion() async {
 if (_task == null) return;
 
 try {
 final updatedTask = _task!.copyWith(
 isCompleted: !_task!.isCompleted,
 updatedAt: DateTime.now(),
 );
 
 await _taskService.updateTask(updatedTask);
 
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text(
 _task!.isCompleted
 ? 'Task marked as incomplete'
 : 'Task marked as complete',
 ),
 backgroundColor: _task!.isCompleted ? Colors.amber : Colors.green,
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
 }

 void _showDeleteDialog(BuildContext context) {
 showDialog(
 context: context,
 builder: (context) => AlertDialog(
 title: Text('Delete Task'),
 content: Text('Are you sure you want to delete this task? This action cannot be undone.'),
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
 await _taskService.deleteTask(_task!.id);
 Navigator.pop(context); // Go back to the task list
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('Task deleted successfully'),
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
 child: Text(
 'DELETE',
 style: TextStyle(color: Colors.red),
 ),
 ),
 ],
 ),
 );
 }
}