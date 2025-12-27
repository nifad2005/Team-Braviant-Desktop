class TeamMember {
  final int? id;
  final String name;
  final String email;
  final String role;

  TeamMember({
    this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Convert a TeamMember object into a Map object. The keys must match the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  // Implement toString to make it easier to see information about
  // each team member when using the print statement.
  @override
  String toString() {
    return 'TeamMember{id: $id, name: $name, email: $email, role: $role}';
  }

  // Factory constructor to create a TeamMember from a Map
  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
    );
  }
}
