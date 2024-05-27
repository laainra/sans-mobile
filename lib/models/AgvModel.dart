class AGV {
  final String code;
  final String description;
  final String ip;
  final String type;

  AGV({
    required this.code,
    required this.description,
    required this.ip,
    required this.type,
  });

  factory AGV.fromJson(Map<String, dynamic> json) => AGV(
        code: json['code'] as String,
        description: json['description'] as String,
        ip: json['ip'] as String,
        type: json['type'] as String,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'description': description,
        'ip': ip,
        'type': type,
      };
}