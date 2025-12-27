import 'package:flutter/material.dart';
import '../models/team_member.dart';
import '../services/database_helper.dart';
import 'add_team_member_screen.dart';

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
            return const Center(child: Text('No team members added yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final member = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(member.name[0]),
                    ),
                    title: Text(
                      member.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${member.role}\n${member.email}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _dbHelper.deleteMember(member.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${member.name} deleted.')),
                        );
                        _refreshTeamMembers(); // Refresh the list after deletion
                      },
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
          // Navigate to AddTeamMemberScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTeamMemberScreen()),
          ).then((_) => _refreshTeamMembers()); // Refresh when returning from add screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
