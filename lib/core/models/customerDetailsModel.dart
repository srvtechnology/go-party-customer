class CustomerDetailsModel {
    CustomerDetailsModel({
        required this.success,
        required this.data,
    });

    final bool? success;
    final Data? data;

    factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
        return CustomerDetailsModel(
            success: json["success"] as bool?,
            data: json["data"] == null ? null : Data.fromJson(json["data"] as Map<String, dynamic>),
        );
    }

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        required this.id,
        required this.platformId,
        required this.platformType,
        required this.regComplete,
        required this.roleId,
        required this.name,
        required this.email,
        required this.mobile,
        required this.tempEmail,
        required this.tempMobile,
        required this.status,
        required this.avatar,
        required this.isAgent,
        required this.uniqueCode,
        required this.agentPercentageHistoryId,
        required this.agentPercentage,
        required this.emailVerifiedAt,
        required this.emailVcode,
        required this.otp,
        required this.regOtp,
        required this.regByAgentId,
        required this.settings,
        required this.country,
        required this.state,
        required this.city,
        required this.zip,
        required this.inactiveReason,
        required this.createdAt,
        required this.updatedAt,
        required this.vendorStatus,
    });

    final int? id;
    final dynamic platformId;
    final String? platformType;
    final String? regComplete;
    final int? roleId;
    final String? name;
    final String? email;
    final String? mobile;
    final dynamic tempEmail;
    final String? tempMobile;
    final String? status;
    final String? avatar;
    final String? isAgent;
    final dynamic uniqueCode;
    final dynamic agentPercentageHistoryId;
    final dynamic agentPercentage;
    final dynamic emailVerifiedAt;
    final dynamic emailVcode;
    final int? otp;
    final String? regOtp;
    final dynamic regByAgentId;
    final List<dynamic> settings;
    final dynamic country;
    final dynamic state;
    final dynamic city;
    final dynamic zip;
    final dynamic inactiveReason;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic vendorStatus;

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            id: json["id"] as int?,
            platformId: json["platform_id"],
            platformType: json["platform_type"] as String?,
            regComplete: json["reg_complete"] as String?,
            roleId: json["role_id"] as int?,
            name: json["name"] as String?,
            email: json["email"] as String?,
            mobile: json["mobile"] as String?,
            tempEmail: json["temp_email"],
            tempMobile: json["temp_mobile"] as String?,
            status: json["status"] as String?,
            avatar: json["avatar"] as String?,
            isAgent: json["is_agent"] as String?,
            uniqueCode: json["unique_code"],
            agentPercentageHistoryId: json["agent_percentage_history_id"],
            agentPercentage: json["agent_percentage"],
            emailVerifiedAt: json["email_verified_at"],
            emailVcode: json["email_vcode"],
            otp: json["otp"] as int?,
            regOtp: json["reg_otp"] as String?,
            regByAgentId: json["reg_by_agent_id"],
            settings: json["settings"] == null ? [] : List<dynamic>.from(json["settings"] as List),
            country: json["country"],
            state: json["state"],
            city: json["city"],
            zip: json["zip"],
            inactiveReason: json["inactive_reason"],
            createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"] as String),
            updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"] as String),
            vendorStatus: json["Vendor_status"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "platform_id": platformId,
        "platform_type": platformType,
        "reg_complete": regComplete,
        "role_id": roleId,
        "name": name,
        "email": email,
        "mobile": mobile,
        "temp_email": tempEmail,
        "temp_mobile": tempMobile,
        "status": status,
        "avatar": avatar,
        "is_agent": isAgent,
        "unique_code": uniqueCode,
        "agent_percentage_history_id": agentPercentageHistoryId,
        "agent_percentage": agentPercentage,
        "email_verified_at": emailVerifiedAt,
        "email_vcode": emailVcode,
        "otp": otp,
        "reg_otp": regOtp,
        "reg_by_agent_id": regByAgentId,
        "settings": settings,
        "country": country,
        "state": state,
        "city": city,
        "zip": zip,
        "inactive_reason": inactiveReason,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "Vendor_status": vendorStatus,
    };
}
