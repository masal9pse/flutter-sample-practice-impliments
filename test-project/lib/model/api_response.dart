class ApiPostResponse {
  ApiPostResponse(
      {required this.id,
      required this.activesAt,
      required this.calledAt,
      required this.totalDiff});
  String id;
  String activesAt;
  String calledAt;
  String totalDiff;
  factory ApiPostResponse.fromJson(Map<String, dynamic> json) {
    return ApiPostResponse(
      id: json['id'].toString(),
      activesAt: json['actives_at'].toString(),
      calledAt: json['called_at'].toString(),
      totalDiff: json['total_diff'].toString(),
    );
  }
}
