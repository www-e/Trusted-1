// API Exceptions - Unified exception handling for all API errors
// Maps HTTP status codes and error codes to meaningful exceptions

/// Base API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic details;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  @override
  String toString() =>
      'ApiException: $message (code: $errorCode, status: $statusCode)';
}

/// Network-related exceptions
class NetworkException extends ApiException {
  NetworkException({
    String message = 'تأكد من اتصال الإنترنت',
    dynamic details,
  }) : super(message: message, details: details);
}

/// Unauthorized - 401
class UnauthorizedException extends ApiException {
  UnauthorizedException({
    String message = 'اسم المستخدم أو كلمة المرور غير صحيحة',
    dynamic details,
  }) : super(
          message: message,
          statusCode: 401,
          errorCode: 'UNAUTHORIZED',
          details: details,
        );
}

/// Conflict - 409 (username/email exists)
class ConflictException extends ApiException {
  ConflictException({
    String message = 'اسم المستخدم أو البريد الإلكتروني موجود بالفعل',
    dynamic details,
  }) : super(
          message: message,
          statusCode: 409,
          errorCode: 'CONFLICT',
          details: details,
        );
}

/// Not Found - 404
class NotFoundException extends ApiException {
  NotFoundException({
    String message = 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني',
    dynamic details,
  }) : super(
          message: message,
          statusCode: 404,
          errorCode: 'NOT_FOUND',
          details: details,
        );
}

/// Bad Request - 400
class BadRequestException extends ApiException {
  BadRequestException({
    String message = 'الرجاء التحقق من المدخلات',
    dynamic details,
  }) : super(
          message: message,
          statusCode: 400,
          errorCode: 'BAD_REQUEST',
          details: details,
        );
}

/// Internal Server Error - 500
class InternalServerException extends ApiException {
  InternalServerException({
    String message = 'خطأ في الخادم، حاول لاحقًا',
    dynamic details,
  }) : super(
          message: message,
          statusCode: 500,
          errorCode: 'INTERNAL_SERVER_ERROR',
          details: details,
        );
}

/// Timeout Exception
class TimeoutException extends ApiException {
  TimeoutException({
    String message = 'انتهت مهلة الطلب، يرجى المحاولة مرة أخرى',
    dynamic details,
  }) : super(message: message, details: details);
}

/// Token Expired Exception
class TokenExpiredException extends ApiException {
  TokenExpiredException({
    String message = 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
    dynamic details,
  }) : super(
          message: message,
          statusCode: 401,
          errorCode: 'TOKEN_EXPIRED',
          details: details,
        );
}

/// Parse Exception
class ParseException extends ApiException {
  ParseException({
    String message = 'خطأ في معالجة البيانات',
    dynamic details,
  }) : super(message: message, details: details);
}
