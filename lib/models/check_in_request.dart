class CheckInRequest {
  final String qrToken;
  final double latitude;
  final double longitude;

  CheckInRequest({
    required this.qrToken,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'qrToken': qrToken,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
