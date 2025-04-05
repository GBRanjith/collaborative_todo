
// views/tasks/create_task_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:collaborative_todo/viewmodels/auth_viewmodel.dart';
import 'package:collaborative_todo/viewmodels/task_list_viewmodel.dart';
import 'package:collaborative_todo/views/widgets/responsive_container.dart';
import 'package:intl/intl.dart';

class CreateTaskScreen extends StatefulWidget {
 final Task? task; // If provided, we're editing an existing task

 const CreateTaskScreen({
 Key? key,
 this.task,
 }) : super(key: key);

 @override
 _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
 final _formKey = GlobalKey<FormState>();
 late TextEditingController _titleController;
 late TextEditingController _descriptionController;
 late DateTime _dueDate;
 bool _isCompleted = false;

 @override
 void initState() {
 super.initState();
 // Initialize controllers with existing task data if editing
 _titleController = TextEditingController(text: widget.task?.title ?? '');
 _descriptionController = TextEditingController(text: widget.task?.description ?? '');
 _dueDate = widget.task?.dueDate ?? DateTime.now().add(Duration(days: 1));
 _isCompleted = widget.task?.isCompleted ?? false;
 }

 @override
 void dispose() {
 _titleController.dispose();
 _descriptionController.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 final taskListViewModel = Provider.of<TaskListViewModel>(context);
 final authViewModel = Provider.of<AuthViewModel>(context);
 final bool isEditing = widget.task != null;

 return Scaffold(
 appBar: AppBar(
 title: Text(isEditing ? 'Edit Task' : 'Create Task'),
 ),
 body: ResponsiveContainer(
 padding: EdgeInsets.all(16),
 child: Form(
 key: _formKey,
 child: SingleChildScrollView(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 // Title field
 TextFormField(
 controller: _titleController,
 decoration: InputDecoration(
 labelText: 'Title',
 border: OutlineInputBorder(),
 prefixIcon: Icon(Icons.title),
 ),
 // views/tasks/create_task_screen.dart (continued)
 validator: (value) {
 if (value == null || value.isEmpty) {
 return 'Please enter a title';
 }
 return null;
 },
 ),
 SizedBox(height: 16),
 
 // Description field
 TextFormField(
 controller: _descriptionController,
 decoration: InputDecoration(
 labelText: 'Description',
 border: OutlineInputBorder(),
 prefixIcon: Icon(Icons.description),
 alignLabelWithHint: true,
 ),
 maxLines: 5,
 ),
 SizedBox(height: 16),
 
 // Due date picker
 InkWell(
 onTap: () => _selectDueDate(context),
 child: InputDecorator(
 decoration: InputDecoration(
 labelText: 'Due Date',
 border: OutlineInputBorder(),
 prefixIcon: Icon(Icons.calendar_today),
 ),
 child: Row(
 mainAxisAlignment: MainAxisAlignment.spaceBetween,
 children: [
 Text(DateFormat('MMM dd, yyyy').format(_dueDate)),
 Icon(Icons.arrow_drop_down),
 ],
 ),
 ),
 ),
 SizedBox(height: 16),
 
 // Completed checkbox (for editing only)
 if (isEditing) ...[
 CheckboxListTile(
 title: Text('Mark as Completed'),
 value: _isCompleted,
 onChanged: (value) {
 setState(() {
 _isCompleted = value ?? false;
 });
 },
 controlAffinity: ListTileControlAffinity.leading,
 ),
 SizedBox(height: 16),
 ],
 
 // Error message
 if (taskListViewModel.error != null) ...[
 Text(
 taskListViewModel.error!,
 style: TextStyle(color: Colors.red),
 ),
 SizedBox(height: 16),
 ],
 
 // Save button
 SizedBox(
 width: double.infinity,
 child: ElevatedButton(
 onPressed: taskListViewModel.isLoading
 ? null
 : () => _saveTask(
 context, taskListViewModel, authViewModel, isEditing),
 child: taskListViewModel.isLoading
 ? CircularProgressIndicator(color: Colors.white)
 : Text(isEditing ? 'UPDATE TASK' : 'CREATE TASK'),
 style: ElevatedButton.styleFrom(
 padding: EdgeInsets.symmetric(vertical: 16),
 ),
 ),
 ),
 ],
 ),
 ),
 ),
 ),
 );
 }

 Future<void> _selectDueDate(BuildContext context) async {
 final DateTime? picked = await showDatePicker(
 context: context,
 initialDate: _dueDate,
 firstDate: DateTime.now(),
 lastDate: DateTime.now().add(Duration(days: 365)),
 );
 
 if (picked != null && picked != _dueDate) {
 setState(() {
 _dueDate = picked;
 });
 }
 }

 Future<void> _saveTask(
 BuildContext context,
 TaskListViewModel taskListViewModel,
 AuthViewModel authViewModel,
 bool isEditing) async {
 if (_formKey.currentState!.validate()) {
 try {
 if (isEditing) {
 // Update existing task
 Task updatedTask = widget.task!.copyWith(
 title: _titleController.text.trim(),
 description: _descriptionController.text.trim(),
 dueDate: _dueDate,
 isCompleted: _isCompleted,
 updatedAt: DateTime.now(),
 );
 
 await taskListViewModel.updateTask(updatedTask);
 
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('Task updated successfully'),
 backgroundColor: Colors.green,
 ),
 );
 } else {
 // Create new task
 Task newTask = Task(
 id: '', // Will be set by Firestore
 title: _titleController.text.trim(),
 description: _descriptionController.text.trim(),
 dueDate: _dueDate,
 ownerId: authViewModel.user!.uid,
 createdAt: DateTime.now(),
 updatedAt: DateTime.now(),
 );
 
 await taskListViewModel.createTask(newTask);
 
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 content: Text('Task created successfully'),
 backgroundColor: Colors.green,
 ),
 );
 }
 
 Navigator.pop(context);
 } catch (e) {
 // Error is already handled in the ViewModel
 }
 }
 }
}