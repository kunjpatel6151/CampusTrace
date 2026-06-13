class ReportModel {
  final String reportId;
  final String userId;
  final String userName;
  final String userEmail;
  final String type; // 'lost' or 'found'
  final String title;
  final String description;
  final String category;
  final String location;
  final DateTime reportDate;
  final String imageUrl;
  final String status; // 'active', 'archived', 'recovered'
  final bool isRecovered;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportModel({
    required this.reportId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.type,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.reportDate,
    required this.imageUrl,
    required this.status,
    required this.isRecovered,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'type': type,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'reportDate': reportDate.toIso8601String(),
      'imageUrl': imageUrl,
      'status': status,
      'isRecovered': isRecovered,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ReportModel(
      reportId: documentId,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      userEmail: map['userEmail'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      location: map['location'] as String,
      reportDate: DateTime.parse(map['reportDate'] as String),
      imageUrl: map['imageUrl'] as String,
      status: map['status'] as String,
      isRecovered: map['isRecovered'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
