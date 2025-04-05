
// views/tasks/task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_todo/viewmodels/auth_viewmodel.dart';
import 'package:collaborative_todo/viewmodels/task_list_viewmodel.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:collaborative_todo/views/widgets/task_item.dart';
import 'package:collaborative_todo/views/widgets/responsive_container.dart';

class TaskListScreen extends StatefulWidget {
 @override
 _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
 final TextEditingController _searchController = TextEditingController();

 @override
 void initState() {
 super.initState();
 // Initialize tasks for the current user
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
 final authViewModel = Provider.of<AuthViewModel>(context);

 return Scaffold(
 appBar: AppBar(
 title: Text('My Tasks'),
 actions: [
 IconButton(
 icon: Icon(Icons.filter_list),
 onPressed: () {
 _showFilterDialog(context);
 },
 ),
 IconButton(
 icon: Icon(Icons.logout),
 onPressed: () {
 authViewModel.signOut();
 },
 ),
 ],
 ),
 body: ResponsiveContainer(
 child: Column(
 children: [
 Padding(
 padding: const EdgeInsets.all(16.0),
 child: TextField(
 controller: _searchController,
 decoration: InputDecoration(
 labelText: 'Search tasks',
 prefixIcon: Icon(Icons.search),
 border: OutlineInputBorder(
 borderRadius: BorderRadius.circular(10),
 ),
 suffixIcon: _searchController.text.isNotEmpty
 ? IconButton(
 icon: Icon(Icons.clear),
 onPressed: () {
 _searchController.clear();
 taskListViewModel.setSearchQuery('');
 },
 )
 : null,
 ),
 onChanged: (value) {
 taskListViewModel.setSearchQuery(value);
 },
 ),
 ),
 Expanded(
 child: taskListViewModel.isLoading
 ? Center(child: CircularProgressIndicator())
 : taskListViewModel.error != null
 ? Center(child: Text('Error: ${taskListViewModel.error}'))
 : taskListViewModel.filteredTasks.isEmpty
 ? Center(child: Text('No tasks found'))
 : ListView.builder(
 itemCount: taskListViewModel.filteredTasks.length,
 itemBuilder: (context, index) {
 Task task = taskListViewModel.filteredTasks[index];
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
 ],
 ),
 ),
 floatingActionButton: FloatingActionButton(
 onPressed: () {
 Navigator.pushNamed(context, '/create-task');
 },
 child: Icon(Icons.add),
 ),
 );
 }

 void _showFilterDialog(BuildContext context) {
 final taskListViewModel = Provider.of<TaskListViewModel>(context, listen: false);

 showDialog(
 context: context,
 builder: (context) => AlertDialog(
 title: Text('Filter Tasks'),
 content: Column(
 mainAxisSize: MainAxisSize.min,
 children: [
 CheckboxListTile(
 title: Text('Show Completed Tasks'),
 value: taskListViewModel.showCompleted,
 onChanged: (value) {
 if (value != null) {
 taskListViewModel.setShowCompleted(value);
 }
 },
 ),
 ],
 ),
 actions: [
 TextButton(
 onPressed: () {
 taskListViewModel.clearFilters();
 Navigator.pop(context);
 },
 child: Text('Clear Filters'),
 ),
 TextButton(
 onPressed: () {
 Navigator.pop(context);
 },
 child: Text('Apply'),
 ),
 ],
 ),
 );
 }
}