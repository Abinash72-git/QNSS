class VerifyOtpModel {
  final bool success;
  final String message;
  final Employee? employee;

  VerifyOtpModel({
    required this.success,
    required this.message,
    this.employee,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      employee: json["data"] != null && json["data"]["employee"] != null
          ? Employee.fromJson(json["data"]["employee"])
          : null,
    );
  }
}

class Employee {
  final String id;
  final String name;
  final String mobileNumber;
  final String role;
  final bool isActive;
  final String? profileImage;
  final JobCode? jobCode;
  final String gender;
  final String joiningDate;
  final List<SpecialTalent> specialTalents;
  final List<dynamic> sidebarPermissions;
  final String createdAt;
  final String updatedAt;

  Employee({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.role,
    required this.isActive,
    this.profileImage,
    this.jobCode,
    required this.gender,
    required this.joiningDate,
    required this.specialTalents,
    required this.sidebarPermissions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json["_id"] ?? json["id"] ?? "",
      name: json["name"] ?? "",
      mobileNumber: json["mobileNumber"] ?? "",
      role: json["role"] ?? "",
      isActive: json["isActive"] ?? false,
      profileImage: json["profileImage"],
      jobCode:
          json["jobCode"] != null ? JobCode.fromJson(json["jobCode"]) : null,
      gender: json["gender"] ?? "",
      joiningDate: json["joiningDate"] ?? "",
      specialTalents: (json["specialTalents"] as List?)
              ?.map((e) => SpecialTalent.fromJson(e))
              .toList() ??
          [],
      sidebarPermissions: json["sidebarPermissions"] ?? [],
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}

class JobCode {
  final String id;
  final String name;

  JobCode({required this.id, required this.name});

  factory JobCode.fromJson(Map<String, dynamic> json) {
    return JobCode(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }
}

class SpecialTalent {
  final String id;
  final String name;

  SpecialTalent({required this.id, required this.name});

  factory SpecialTalent.fromJson(Map<String, dynamic> json) {
    return SpecialTalent(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }
}
