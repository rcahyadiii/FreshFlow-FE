class Report {
  final String id;
  final String? userId;
  final String? locationId;
  final String? title;
  final String? description;
  final String? status;
  final String? priority;
  final String? category;
  final List<String>? imageUrls;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Report({
    required this.id,
    this.userId,
    this.locationId,
    this.title,
    this.description,
    this.status,
    this.priority,
    this.category,
    this.imageUrls,
    this.createdAt,
    this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      locationId: json['location_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      priority: json['priority'] as String?,
      category: json['category'] as String?,
      imageUrls: json['image_urls'] != null 
          ? List<String>.from(json['image_urls']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'location_id': locationId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'category': category,
      'image_urls': imageUrls,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
