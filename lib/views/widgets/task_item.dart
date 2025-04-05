
// views/widgets/task_item.dart
import 'package:flutter/material.dart';
import 'package:collaborative_todo/models/task.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
 final Task task;
 final VoidCallback onToggle;
 final VoidCallback onTap;

 const TaskItem({
 Key? key,
 required this.task,
 required this.onToggle,
 required this.onTap,
 }) : super(key: key);

 @override
 Widget build(BuildContext context) {
 final bool isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;
 
 return Card(
 margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
 elevation: 2,
 child: InkWell(
 onTap: onTap,
 child: Padding(
 padding: EdgeInsets.all(16),
 child: Row(
 children: [
 Checkbox(
 value: task.isCompleted,
 onChanged: (_) => onToggle(),
 ),
 SizedBox(width: 16),
 Expanded(
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text(
 task.title,
 style: TextStyle(
 fontSize: 18,
 fontWeight: FontWeight.bold,
 decoration: task.isCompleted
 ? TextDecoration.lineThrough
 : null,
 ),
 ),
 SizedBox(height: 4),
 Text(
 task.description,
 maxLines: 2,
 overflow: TextOverflow.ellipsis,
 style: TextStyle(
 color: Colors.grey[700],
 decoration: task.isCompleted
 ? TextDecoration.lineThrough
 : null,
 ),
 ),
 SizedBox(height: 8),
 Row(
 children: [
 Icon(
 Icons.calendar_today,
 size: 16,
 color: isOverdue ? Colors.red : Colors.grey[600],
 ),
 SizedBox(width: 4),
 Text(
 DateFormat('MMM dd, yyyy').format(task.dueDate),
 style: TextStyle(
 color: isOverdue ? Colors.red : Colors.grey[600],
 fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
 ),
 ),
 if (task.sharedWith.isNotEmpty) ...[
 SizedBox(width: 8),
 Icon(
 Icons.people,
 size: 16,
 color: Colors.blue,
 ),
 SizedBox(width: 4),
 Text(
 '${task.sharedWith.length} shared',
 style: TextStyle(color: Colors.blue),
 ),
 ],
 ],
 ),
 ],
 ),
 ),
 ],
 ),
 ),
 ),
 );
 }
}
