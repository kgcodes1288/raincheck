class RainReport {
  const RainReport({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.photoUrl,
    required this.reportedAt,
  });

  final String id;
  final double latitude;
  final double longitude;
  final String photoUrl;
  final DateTime reportedAt;

  factory RainReport.fromMap(Map<String, dynamic> data) {
    return RainReport(
      id: data['id'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      photoUrl: data['photo_url'] as String,
      reportedAt: DateTime.parse(data['reported_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'photo_url': photoUrl,
      'reported_at': reportedAt.toIso8601String(),
    };
  }
}
