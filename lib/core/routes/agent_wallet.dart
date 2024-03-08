import 'dart:convert';
import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:customerapp/config.dart';
import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/providers/AuthProvider.dart';
import 'package:customerapp/core/utils/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentWallet extends StatefulWidget {
  static const routeName = "/agent-wallet";
  const AgentWallet({
    super.key,
  });

  @override
  State<AgentWallet> createState() => _AgentWalletState();
}

class _AgentWalletState extends State<AgentWallet> {
  late AuthProvider auth;
  bool isLoading = true;
  AgentWalletData? agentWalletData;
  TextEditingController withdrawAmountController = TextEditingController();

  @override
  void initState() {
    auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.isAgent) {
      getWalletData(auth);
    }
    super.initState();
  }

  Future getWalletData(AuthProvider auth) async {
    try {
      Response response = await customDioClient.client.get(
          "${APIConfig.baseUrl}/api/agent/show-balance",
          options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
      log(jsonEncode(response.data), name: "Wallet Response");
      AgentWalletData agentWalletData = AgentWalletData.fromJson(response.data);
      setState(() {
        this.agentWalletData = agentWalletData;
      });
    } catch (e) {
      log(jsonEncode(e.toString()), name: "Wallet Error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future withdrawAmount(int amount) async {
    try {
      Response response = await customDioClient.client.post(
          "${APIConfig.baseUrl}/api/agent/withdraw-balance-request",
          data: {
            "amount": amount,
          },
          options: Options(headers: {"Authorization": "Bearer ${auth.token}"}));
      log(jsonEncode(response.data), name: "Withdraw Response");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.data["message"]),
        ),
      );
      getWalletData(auth);
    } catch (e) {
      log(jsonEncode(e.toString()), name: "Withdraw Error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // widrawal button

      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            // wallet Hedder with balance
            Container(
              width: double.infinity,
              height: 110,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Wallet",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      // withdraw button
                      const Spacer(),
                      TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              useSafeArea: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      void Function(void Function()) setState) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            20,
                                      ),
                                      child: Container(
                                        height: 220,
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Withdraw Amount",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  withdrawAmountController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                // max amount will be agentWalletData?.remainingBalance value
                                              ],
                                              decoration: const InputDecoration(
                                                labelText: "Amount",
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              width: double.infinity,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // make withdraw request will max amount will be agentWalletData?.remainingBalance value
                                                  if (agentWalletData
                                                          ?.remainingBalance ==
                                                      null) {
                                                    return;
                                                  }
                                                  if (int.tryParse(
                                                          withdrawAmountController
                                                              .text) !=
                                                      null) {
                                                    if (int.tryParse(
                                                            withdrawAmountController
                                                                .text)! >
                                                        agentWalletData!
                                                            .remainingBalance!) {
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "You can't withdraw more than your balance"),
                                                        ),
                                                      );
                                                      return;
                                                    }
                                                  }
                                                  Navigator.pop(context);
                                                  withdrawAmount(int.tryParse(
                                                          withdrawAmountController
                                                              .text) ??
                                                      0);
                                                  withdrawAmountController
                                                      .clear();
                                                },
                                                child: const Text("Withdraw"),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Withdraw",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Balance",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        NumberFormat.currency(locale: 'en_IN', symbol: "₹")
                            .format(agentWalletData?.remainingBalance ?? 0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            // wallet History list
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: double.infinity,
              child: const Text("Transaction History",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              child: CustomMaterialIndicator(
                indicatorBuilder:
                    (BuildContext context, IndicatorController controller) {
                  return Container(
                      padding: EdgeInsets.all(2.w),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ));
                },
                backgroundColor: primaryColor,
                onRefresh: () {
                  getWalletData(auth);
                  return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : agentWalletData == null
                        ? const Center(
                            child: Text("No Data Found"),
                          )
                        : agentWalletData?.agentWalletHistory?.isEmpty ?? true
                            ? const Center(
                                child: Text("No Data Found"),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: agentWalletData
                                        ?.agentWalletHistory?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: const Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // status
                                            Text(
                                              "Status: ${agentWalletData?.agentWalletHistory?[index].status ?? ""}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: agentWalletData
                                                            ?.agentWalletHistory?[
                                                                index]
                                                            .status ==
                                                        "pending"
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              DateFormat('dd MMM yyyy').format(
                                                  agentWalletData
                                                          ?.agentWalletHistory?[
                                                              index]
                                                          .datetime ??
                                                      DateTime.now()),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                                  locale: 'en_IN', symbol: "₹")
                                              .format(int.tryParse((agentWalletData
                                                              ?.agentWalletHistory?[
                                                                  index]
                                                              .amount ??
                                                          0)
                                                      .toString()) ??
                                                  0),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

AgentWalletData agentWalletDataFromJson(String str) =>
    AgentWalletData.fromJson(json.decode(str));

String agentWalletDataToJson(AgentWalletData data) =>
    json.encode(data.toJson());

class AgentWalletData {
  bool? success;
  String? message;
  double? remainingBalance;
  List<AgentWalletHistory>? agentWalletHistory;

  AgentWalletData({
    this.success,
    this.message,
    this.remainingBalance,
    this.agentWalletHistory,
  });

  factory AgentWalletData.fromJson(Map<String, dynamic> json) =>
      AgentWalletData(
        success: json["success"],
        message: json["message"],
        remainingBalance: json["remaining_balance"]?.toDouble(),
        agentWalletHistory: json["agent_wallet_history"] == null
            ? []
            : List<AgentWalletHistory>.from(json["agent_wallet_history"]!
                .map((x) => AgentWalletHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "remaining_balance": remainingBalance,
        "agent_wallet_history": agentWalletHistory == null
            ? []
            : List<dynamic>.from(agentWalletHistory!.map((x) => x.toJson())),
      };
}

class AgentWalletHistory {
  int? id;
  int? userId;
  dynamic agentBankId;
  int? agentPercentageHistoryId;
  String? amount;
  String? status;
  dynamic txId;
  DateTime? datetime;
  dynamic statusDatetime;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  AgentPercentageHistory? agentPercentageHistory;
  dynamic bank;

  AgentWalletHistory({
    this.id,
    this.userId,
    this.agentBankId,
    this.agentPercentageHistoryId,
    this.amount,
    this.status,
    this.txId,
    this.datetime,
    this.statusDatetime,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.agentPercentageHistory,
    this.bank,
  });

  factory AgentWalletHistory.fromJson(Map<String, dynamic> json) =>
      AgentWalletHistory(
        id: json["id"],
        userId: json["user_id"],
        agentBankId: json["agent_bank_id"],
        agentPercentageHistoryId: json["agent_percentage_history_id"],
        amount: json["amount"],
        status: json["status"],
        txId: json["tx_id"],
        datetime:
            json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
        statusDatetime: json["status_datetime"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        agentPercentageHistory: json["agent_percentage_history"] == null
            ? null
            : AgentPercentageHistory.fromJson(json["agent_percentage_history"]),
        bank: json["bank"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "agent_bank_id": agentBankId,
        "agent_percentage_history_id": agentPercentageHistoryId,
        "amount": amount,
        "status": status,
        "tx_id": txId,
        "datetime": datetime?.toIso8601String(),
        "status_datetime": statusDatetime,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "agent_percentage_history": agentPercentageHistory?.toJson(),
        "bank": bank,
      };
}

class AgentPercentageHistory {
  int? id;
  int? userId;
  String? amount;
  DateTime? dateTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  AgentPercentageHistory({
    this.id,
    this.userId,
    this.amount,
    this.dateTime,
    this.createdAt,
    this.updatedAt,
  });

  factory AgentPercentageHistory.fromJson(Map<String, dynamic> json) =>
      AgentPercentageHistory(
        id: json["id"],
        userId: json["user_id"],
        amount: json["amount"],
        dateTime:
            json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "amount": amount,
        "dateTime": dateTime?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class User {
  int? id;
  dynamic platformId;
  String? platformType;
  String? regComplete;
  int? roleId;
  String? name;
  String? email;
  String? mobile;
  dynamic tempEmail;
  dynamic tempMobile;
  String? status;
  String? avatar;
  String? isAgent;
  String? uniqueCode;
  int? agentPercentageHistoryId;
  String? agentPercentage;
  dynamic emailVerifiedAt;
  dynamic emailVcode;
  dynamic otp;
  dynamic regOtp;
  dynamic regByAgentId;
  List<dynamic>? settings;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic zip;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic vendorStatus;

  User({
    this.id,
    this.platformId,
    this.platformType,
    this.regComplete,
    this.roleId,
    this.name,
    this.email,
    this.mobile,
    this.tempEmail,
    this.tempMobile,
    this.status,
    this.avatar,
    this.isAgent,
    this.uniqueCode,
    this.agentPercentageHistoryId,
    this.agentPercentage,
    this.emailVerifiedAt,
    this.emailVcode,
    this.otp,
    this.regOtp,
    this.regByAgentId,
    this.settings,
    this.country,
    this.state,
    this.city,
    this.zip,
    this.createdAt,
    this.updatedAt,
    this.vendorStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        platformId: json["platform_id"],
        platformType: json["platform_type"],
        regComplete: json["reg_complete"],
        roleId: json["role_id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        tempEmail: json["temp_email"],
        tempMobile: json["temp_mobile"],
        status: json["status"],
        avatar: json["avatar"],
        isAgent: json["is_agent"],
        uniqueCode: json["unique_code"],
        agentPercentageHistoryId: json["agent_percentage_history_id"],
        agentPercentage: json["agent_percentage"],
        emailVerifiedAt: json["email_verified_at"],
        emailVcode: json["email_vcode"],
        otp: json["otp"],
        regOtp: json["reg_otp"],
        regByAgentId: json["reg_by_agent_id"],
        settings: json["settings"] == null
            ? []
            : List<dynamic>.from(json["settings"]!.map((x) => x)),
        country: json["country"],
        state: json["state"],
        city: json["city"],
        zip: json["zip"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        vendorStatus: json["Vendor_status"],
      );

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
        "settings":
            settings == null ? [] : List<dynamic>.from(settings!.map((x) => x)),
        "country": country,
        "state": state,
        "city": city,
        "zip": zip,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "Vendor_status": vendorStatus,
      };
}
