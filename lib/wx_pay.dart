class WxPayOrderResp {
  int code;
  String prepay_id;

  WxPayOrderResp(this.code, this.prepay_id);

  factory WxPayOrderResp.fromJson(Map<String, dynamic> json) =>
      WxPayOrderResp(json["code"], json["data"]["prepay_id"]);
}

class OrganGetQualityControlDocSmsReq {
  String phone;

  OrganGetQualityControlDocSmsReq(this.phone);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    return data;
  }
}