import 'package:flutter/material.dart';
import '../models/team_member.dart';
import '../services/database_helper.dart';
import '../../main.dart'; // For Intents

class EditTeamMemberScreen extends StatefulWidget {
  final TeamMember member;

  const EditTeamMemberScreen({super.key, required this.member});

  @override
  State<EditTeamMemberScreen> createState() => _EditTeamMemberScreenState();
}

class _EditTeamMemberScreenState extends State<EditTeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _emailController = TextEditingController(text: widget.member.email);
    _roleController = TextEditingController(text: widget.member.role);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _updateTeamMember() async {
    if (_formKey.currentState!.validate()) {
      final updatedMember = TeamMember(
        id: widget.member.id, // Keep the original ID
        name: _nameController.text,
        email: _emailController.text,
        role: _roleController.text,
      );

      try {
        await _dbHelper.updateMember(updatedMember);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team member updated successfully!')),
          );
          Navigator.of(context).pop(); // Go back after update
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update team member: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        SaveMemberIntent: CallbackAction<SaveMemberIntent>(onInvoke: (intent) => _updateTeamMember()),
        CancelIntent: CallbackAction<CancelIntent>(onInvoke: (intent) {
          Navigator.of(context).pop(); // Simply pop the screen
          return null;
        }),
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Team Member'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Edit Team Member Details',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32.0),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _roleController,
                        decoration: InputDecoration(
                          labelText: 'Role',
                          border: const OutlineInputBorder(),
                          labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                          ),
                        ),
                        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a role';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Actions.invoke(context, const CancelIntent()),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Actions.invoke(context, const SaveMemberIntent()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              child: const Text('Update Member'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
