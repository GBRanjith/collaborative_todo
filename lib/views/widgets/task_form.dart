
// views/widgets/task_form.dart
import 'package:flutter/material.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:intl/intl.dart';

class TaskForm extends StatefulWidget {
 final Task? task;
 final Function(String title, String description, DateTime dueDate, bool isCompleted) onSave;
 final bool isEditing;

 const TaskForm({
 Key? key,
 this.task,
 required this.onSave,
 this.isEditing = false,
 }) : super(key: key);

 @override
 _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
 final _formKey = GlobalKey<FormState>();
 late TextEditingController _titleController;
 late TextEditingController _descriptionController;
 late DateTime _dueDate;
 bool _isCompleted = false;

 @override
 void initState() {
 super.initState();
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
 return Form(
 key: _formKey,
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 TextFormField(
 controller: _titleController,
 decoration: InputDecoration(
 labelText: 'Title',
 border: OutlineInputBorder(),
 prefixIcon: Icon(Icons.title),
 ),
 validator: (value) {
 if (value == null || value.isEmpty) {
 return 'Please enter a title';
 }
 return null;
 },
 ),
 SizedBox(height: 16),
 
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
 
 InkWell(
 onTap: _selectDueDate,
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
 
 if (widget.isEditing) ...[
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
 
 SizedBox(
 width: double.infinity,
 child: ElevatedButton(
 onPressed: _submitForm,
 child: Text(widget.isEditing ? 'UPDATE TASK' : 'CREATE TASK'),
 style: ElevatedButton.styleFrom(
 padding: EdgeInsets.symmetric(vertical: 16),
 ),
 ),
 ),
 ],
 ),
 );
 }

 Future<void> _selectDueDate() async {
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

 void _submitForm() {
 if (_formKey.currentState!.validate()) {
 widget.onSave(
 _titleController.text.trim(),
 _descriptionController.text.trim(),
 _dueDate,
 _isCompleted,
 );
 }
 }
}

