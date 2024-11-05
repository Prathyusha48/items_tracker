class Task {
    String name;
    String description;

  Task({required this.name, required this.description});

    Map<String, dynamic> toMap() {
      return {
        'name': name,
        'description': description,
      };
    }

    factory Task.fromMap(Map<String, dynamic> map) {
      return Task(
        name: map['name'],
        description: map['description'],
      );
    }
}
