class GeneralResponseDto {
  final int status;
  final dynamic data;

  GeneralResponseDto({required this.status, required this.data});

  factory GeneralResponseDto.fromJson(Map<String, dynamic> json) =>
      GeneralResponseDto(status: json['status'], data: json['data']);
}

class ErrorResponseDto {
  final int status;
  final String errorCode;
  final String message;

  ErrorResponseDto({
    required this.status,
    required this.errorCode,
    required this.message,
  });

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      ErrorResponseDto(
        status: json['status'],
        errorCode: json['data']['errorCode'],
        message: json['data']['message'],
      );
}
