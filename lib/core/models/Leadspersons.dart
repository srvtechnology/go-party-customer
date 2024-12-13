class Leadspersons {
  bool? success;
  String? message;
  List<Leads>? leads;

  Leadspersons({this.success, this.message, this.leads});

  Leadspersons.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['leads'] != null) {
      leads = <Leads>[];
      json['leads'].forEach((v) {
        leads!.add(new Leads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.leads != null) {
      data['leads'] = this.leads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leads {
  int? id;
  String? leadName;
  String? leadEmail;
  String? leadPhone;
  String? categoryId;
  String? services;
  String? leadCity;
  String? leadAddress;
  String? leadPin;
  String? agentId;
  String? leadStatus;
  String? createdAt;
  String? updatedAt;
  String? reason;
  int? minQty;
  int? days;
  String? startDate;
  String? endDate;
  String? price;
  String? adminRemarks;
  String? message;

  Leads(
      {this.id,
        this.leadName,
        this.leadEmail,
        this.leadPhone,
        this.categoryId,
        this.services,
        this.leadCity,
        this.leadAddress,
        this.leadPin,
        this.agentId,
        this.leadStatus,
        this.createdAt,
        this.updatedAt,
        this.reason,
        this.minQty,
        this.days,
        this.startDate,
        this.endDate,
        this.price,
        this.adminRemarks,
        this.message});

  Leads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadName = json['lead_name'];
    leadEmail = json['lead_email'];
    leadPhone = json['lead_phone'];
    categoryId = json['category_id'];
    services = json['services'];
    leadCity = json['lead_city'];
    leadAddress = json['lead_address'];
    leadPin = json['lead_pin'];
    agentId = json['agent_id'];
    leadStatus = json['lead_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    reason = json['reason'];
    minQty = json['min_qty'];
    days = json['days'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    price = json['price'];
    adminRemarks = json['admin_remarks'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_name'] = this.leadName;
    data['lead_email'] = this.leadEmail;
    data['lead_phone'] = this.leadPhone;
    data['category_id'] = this.categoryId;
    data['services'] = this.services;
    data['lead_city'] = this.leadCity;
    data['lead_address'] = this.leadAddress;
    data['lead_pin'] = this.leadPin;
    data['agent_id'] = this.agentId;
    data['lead_status'] = this.leadStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['reason'] = this.reason;
    data['min_qty'] = this.minQty;
    data['days'] = this.days;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['price'] = this.price;
    data['admin_remarks'] = this.adminRemarks;
    data['message'] = this.message;
    return data;
  }
}