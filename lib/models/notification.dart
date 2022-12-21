class NotificationMessage {
  String title, content;
  String iconURL;
  int progress, goal;
  bool isRead;
  bool isDirect;
  DateTime date;

  NotificationMessage({
    this.title,
    this.content,
    this.iconURL,
    this.progress,
    this.goal = 100,
    this.isRead = true,
    this.isDirect = true,
    this.date,
  });

  NotificationMessage copyWith({
    String title,
    String content,
    String iconURL,
    int progress,
    int goal = 100,
    bool read = true,
    bool isReward = false,
    bool isDirect = true,
    DateTime date,
  }) =>
      NotificationMessage(
        title: title ?? this.title,
        content: content ?? this.content,
        iconURL: iconURL ?? this.iconURL,
        progress: progress ?? this.progress,
        goal: goal ?? this.goal,
        isRead: read ?? this.isRead,
        date: date ?? this.date,
      );

  factory NotificationMessage.fromJson(dynamic json) => NotificationMessage(
        title:
            json["title"] == null || json["title"] == "" ? null : json["title"],
        content: json["content"] == null || json["content"] == ""
            ? null
            : json["content"],
        iconURL:
            json["icon"] == null || json["icon"] == "" ? null : json["icon"],
        progress: json["progress"] == null || json["progress"] == ""
            ? null
            : json["progress"],
        goal: json["goal"] == null || json["goal"] == "" ? null : json["goal"],
        isRead:
            json["read"] == null || json["read"] == "" ? null : json["read"],
        isDirect: json["isDirect"] == null || json["isDirect"] == ""
            ? null
            : json["isDirect"],
        date: json["date"] == null || json["date"] == ""
            ? null
            : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "content": content == null ? null : content,
        "iconURL": iconURL == null ? null : iconURL,
        "progress": progress == null ? null : progress,
        "goal": goal == null ? null : goal,
        "read": isRead == null ? null : isRead,
        "isReward": isDirect == null ? null : isDirect,
        "date": date == null ? null : date.toString(),
      };
}
