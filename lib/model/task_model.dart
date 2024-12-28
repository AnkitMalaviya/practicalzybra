enum priority {LOW,MEDIUM,HIGH}

class TaskModel {
  final int? id;
  final String? title;
  final String? description;
  final bool isComplete;
  final String? priority;
  final DateTime? completionAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskModel({
    this.id,
     this.title,
     this.description,
     this.isComplete = false,
    this.priority,
    this.completionAt, this.createdAt, this.updatedAt,

  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isComplete: map['isComplete'] == 1,
      priority: map['priority'],
      completionAt: map['completionAt'] != null ? DateTime.parse(map['completionAt']) : null,
      createdAt: DateTime.parse(map['createdAt']) ,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isComplete': isComplete ? 1 : 0,
      'priority': priority ,
      'completionAt':completionAt!=null? completionAt?.toIso8601String():null,
      'createdAt':createdAt!=null? createdAt?.toIso8601String():null,
      'updatedAt': updatedAt!=null?updatedAt?.toIso8601String():null,

    };
  }
  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isComplete,
    String? priority,
    DateTime? completionAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isComplete: isComplete ?? this.isComplete,
      priority: priority ?? this.priority,
      completionAt: completionAt ?? this.completionAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
