
class Station {
  final String code;
  final String status;
  final String rfid;

  Station({
    required this.code,
    required this.status,
    required this.rfid,
  });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        code: json['code'] as String,
        status: json['status'] as String,
        rfid: json['rfid'] as String,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'status': status,
        'rfid': rfid,
      };
}