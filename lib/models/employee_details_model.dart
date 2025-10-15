class EmployeeDetailsResponse {
  final bool success;
  final String message;
  final EmployeeData data;

  EmployeeDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EmployeeDetailsResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: EmployeeData.fromJson(json['data']),
    );
  }
}

class EmployeeData {
  final Employee employee;
  final List<Customer> customers;
  final Statistics statistics;

  EmployeeData({
    required this.employee,
    required this.customers,
    required this.statistics,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      employee: Employee.fromJson(json['employee']),
      customers: (json['customers'] as List)
          .map((e) => Customer.fromJson(e))
          .toList(),
      statistics: Statistics.fromJson(json['statistics']),
    );
  }
}

class Employee {
  final String id;
  final String name;
  final String mobileNumber;
  final String role;

  Employee({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.role,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String address;
  final String contractStartDate;
  final String contractEndDate;
  final String contractStatus;
  final int daysRemaining;
  final int contractDurationDays;
  final Property selectedProperty;
  final List<String> selectedItems;
  final Employee selectedEmployee;
  final Frequency frequency;
  final ServiceType serviceType;
  final Shift shiftName;
  final String profileImage;
  final List<String> detailImages;
  final bool isActive;

  Customer({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.address,
    required this.contractStartDate,
    required this.contractEndDate,
    required this.contractStatus,
    required this.daysRemaining,
    required this.contractDurationDays,
    required this.selectedProperty,
    required this.selectedItems,
    required this.selectedEmployee,
    required this.frequency,
    required this.serviceType,
    required this.shiftName,
    required this.profileImage,
    required this.detailImages,
    required this.isActive,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      contractStartDate: json['contractStartDate'] ?? '',
      contractEndDate: json['contractEndDate'] ?? '',
      contractStatus: json['contractStatus'] ?? '',
      daysRemaining: json['daysRemaining'] ?? 0,
      contractDurationDays: json['contractDurationDays'] ?? 0,
      selectedProperty: Property.fromJson(json['selectedProperty']),
      selectedItems:
          (json['selectedItems'] as List).map((e) => e.toString()).toList(),
      selectedEmployee: Employee.fromJson(json['selectedEmployee']),
      frequency: Frequency.fromJson(json['frequency']),
      serviceType: ServiceType.fromJson(json['serviceType']),
      shiftName: Shift.fromJson(json['shiftName']),
      profileImage: json['profileImage'] ?? '',
      detailImages:
          (json['detailImages'] as List).map((e) => e.toString()).toList(),
      isActive: json['isActive'] ?? false,
    );
  }
}

class Property {
  final String id;
  final String factoryName;
  final String period;
  final String docNo;
  final String area;

  Property({
    required this.id,
    required this.factoryName,
    required this.period,
    required this.docNo,
    required this.area,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id'] ?? '',
      factoryName: json['factory_name'] ?? '',
      period: json['period'] ?? '',
      docNo: json['doc_no'] ?? '',
      area: json['area'] ?? '',
    );
  }
}

class Frequency {
  final String id;
  final String name;
  final String code;

  Frequency({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Frequency.fromJson(Map<String, dynamic> json) {
    return Frequency(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class ServiceType {
  final String id;
  final String name;
  final String code;

  ServiceType({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class Shift {
  final String id;
  final String name;
  final String startTime;
  final String endTime;
  final String duration;

  Shift({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
}

class Statistics {
  final int totalCustomers;
  final int activeContracts;
  final int upcomingContracts;
  final int expiredContracts;

  Statistics({
    required this.totalCustomers,
    required this.activeContracts,
    required this.upcomingContracts,
    required this.expiredContracts,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      totalCustomers: json['totalCustomers'] ?? 0,
      activeContracts: json['activeContracts'] ?? 0,
      upcomingContracts: json['upcomingContracts'] ?? 0,
      expiredContracts: json['expiredContracts'] ?? 0,
    );
  }
}
