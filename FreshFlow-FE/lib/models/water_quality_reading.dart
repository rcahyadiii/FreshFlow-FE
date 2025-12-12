class WaterQualityReading {
  final String id;
  final String? deviceId;
  final String? locationId;
  final double? ph;
  final double? turbidity;
  final double? tds;
  final double? temperature;
  final double? dissolvedOxygen;
  final String? qualityStatus;
  final DateTime? timestamp;
  final DateTime? createdAt;

  WaterQualityReading({
    required this.id,
    this.deviceId,
    this.locationId,
    this.ph,
    this.turbidity,
    this.tds,
    this.temperature,
    this.dissolvedOxygen,
    this.qualityStatus,
    this.timestamp,
    this.createdAt,
  });

  factory WaterQualityReading.fromJson(Map<String, dynamic> json) {
    return WaterQualityReading(
      id: json['id'] as String,
      deviceId: json['device_id'] as String?,
      locationId: json['location_id'] as String?,
      ph: json['ph']?.toDouble(),
      turbidity: json['turbidity']?.toDouble(),
      tds: json['tds']?.toDouble(),
      temperature: json['temperature']?.toDouble(),
      dissolvedOxygen: json['dissolved_oxygen']?.toDouble(),
      qualityStatus: json['quality_status'] as String?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'location_id': locationId,
      'ph': ph,
      'turbidity': turbidity,
      'tds': tds,
      'temperature': temperature,
      'dissolved_oxygen': dissolvedOxygen,
      'quality_status': qualityStatus,
      'timestamp': timestamp?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
