import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_helper_app/Provider/TaskAddedProvider.dart';
import 'package:work_helper_app/main.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _taskController = TextEditingController();
  String? _selectedType = 'Daily';

  bool get _isButtonDisabled => _taskController.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    _taskController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(currentIndex: 0),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 24.0,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withOpacity(0.5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Task Details",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),

                // Task Name Input
                TextField(
                  controller: _taskController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: "Task Name",
                    hintText: "e.g., Finish UI Design",
                    prefixIcon: const Icon(Icons.task_alt),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Frequency Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  items: ['Daily', 'Weekly'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Frequency",
                    prefixIcon: const Icon(Icons.repeat),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Add Task Button
                ElevatedButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () {
                          Provider.of<TaskAddedProvider>(
                            context,
                            listen: false,
                          ).addTaskInList(
                            _taskController.text.trim(),
                            _selectedType ?? 'Daily',
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(currentIndex: 0),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    disabledBackgroundColor: theme.colorScheme.onSurface
                        .withOpacity(0.12),
                    disabledForegroundColor: theme.colorScheme.onSurface
                        .withOpacity(0.38),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: _isButtonDisabled ? 0 : 2,
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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
}
