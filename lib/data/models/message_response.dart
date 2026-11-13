class SuccessMessageResponse {
  String? message;
  String? description;

  SuccessMessageResponse({
    this.message,
    this.description,
  });

  factory SuccessMessageResponse.fromJson(Map<String, dynamic> json) =>
      SuccessMessageResponse(
        message: json["message"],
        description: json["description"],
      );

  
}
