class LoginResponseModel {
  const LoginResponseModel({required this.access, this.refresh});

  final String access;
  final String? refresh;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      access: json['access']?.toString() ?? '',
      refresh: json['refresh']?.toString(),
    );
  }
}
