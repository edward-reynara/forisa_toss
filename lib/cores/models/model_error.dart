class ErrorModel {
  final String status;
  final List<String> message;

  ErrorModel({
    required this.status,
    required this.message,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
        status: json['status'], message: List<String>.from(json['message']));
  }
}
