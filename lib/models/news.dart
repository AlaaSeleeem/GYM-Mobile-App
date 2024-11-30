class News {
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final String? picture;

  News({
    this.title,
    this.content,
    this.createdAt,
    this.picture,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] as String?,
      content: json['content'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      picture: json['picture'] as String?,
    );
  }

  // Convert a News instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'picture': picture,
    };
  }
}
