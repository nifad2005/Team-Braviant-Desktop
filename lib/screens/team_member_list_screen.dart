import 'package:flutter/material.dart';
import '../models/team_member.dart';
import '../services/database_helper.dart';
import 'add_team_member_screen.dart';
import 'edit_team_member_screen.dart'; // NEW IMPORT
import '../../main.dart'; // NEW IMPORT for Intents

class TeamMemberListScreen extends StatefulWidget {
  const TeamMemberListScreen({super.key});

  @override
  State<TeamMemberListScreen> createState() => _TeamMemberListScreenState();
}

class _TeamMemberListScreenState extends State<TeamMemberListScreen> {
  late Future<List<TeamMember>> _teamMembersFuture;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _refreshTeamMembers();
  }

  void _refreshTeamMembers() {
    setState(() {
      _teamMembersFuture = _dbHelper.getMembers();
    });
  }

  Future<void> _confirmDelete(BuildContext context, TeamMember member) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${member.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _dbHelper.deleteMember(member.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${member.name} deleted successfully.')),
          );
          _refreshTeamMembers(); // Refresh the list after deletion
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete ${member.name}: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Members'),
      ),
      body: FutureBuilder<List<TeamMember>>(
        future: _teamMembersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_alt_outlined, size: 80, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                  const SizedBox(height: 20),
                  Text(
                    'No team members found.',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap the "+" button to add your first team member!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final member = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2.0,
                  color: Theme.of(context).cardColor, // Use theme card color
                  child: ListTile(
                    onTap: () { // NEW: Make ListTile tappable for editing
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTeamMemberScreen(member: member),
                        ),
                      ).then((_) => _refreshTeamMembers()); // Refresh when returning
                    },
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary, // Use accent color for avatar
                      foregroundColor: Theme.of(context).colorScheme.onSecondary, // Text color on accent
                      child: Text(member.name[0]),
                    ),
                    title: Text(
                      member.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                    subtitle: Text(
                      '${member.role}\n${member.email}',
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, member), // Call confirmation dialog
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Actions.invoke(context, const AddMemberIntent()); // Dispatch AddMemberIntent
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
