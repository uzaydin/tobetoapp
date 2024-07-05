class Video {
  String id;
  String? videoTitle;
  String? link;
  Duration? duration;
  Duration? spentTime;
  bool? isCompleted;
  Video({
    required this.id,
    this.videoTitle,
    this.link,
    this.duration,
    this.spentTime,
    this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'videoTitle': videoTitle,
      'link': link,
      'duration': duration?.inMilliseconds,
      'spentTime': spentTime?.inSeconds,
      'isCompleted': isCompleted,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      videoTitle: map['videoTitle'],
      link: map['link'],
      duration: map['duration'] != null
          ? Duration(milliseconds: map['duration'])
          : null,
      isCompleted: map['isCompleted'],
      spentTime:
          map['spentTime'] != null ? Duration(seconds: map['spentTime']) : null,
    );
  }

  Video copyWith({
    String? id,
    String? videoTitle,
    String? link,
    Duration? duration,
    Duration? spentTime,
    bool? isCompleted,
  }) {
    return Video(
        id: id ?? this.id,
        videoTitle: videoTitle ?? this.videoTitle,
        link: link ?? this.link,
        duration: duration ?? this.duration,
        isCompleted: isCompleted ?? this.isCompleted,
        spentTime: spentTime ?? this.spentTime);
  }
}