class ApiConfig {
  final String baseUrl;
  final String xApiKey;
  final String jwtToken;

  ApiConfig({
    required this.baseUrl,
    required this.xApiKey,
    required this.jwtToken,
  });

  factory ApiConfig.fromJson(Map<String, dynamic> json) {
    return ApiConfig(
      baseUrl: json['base_url'] as String,
      xApiKey: json['x_api_key'] as String,
      jwtToken: json['jwt_token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_url': baseUrl,
      'x_api_key': xApiKey,
      'jwt_token': jwtToken,
    };
  }
}

class AcuantConfig {
  final String passiveUsername;
  final String passivePassword;
  final String idUsername;
  final String idPassword;
  final String passiveSubscriptionId;
  final String frmEndpoint;
  final String acasEndpoint;
  final String livenessEndpoint;

  AcuantConfig({
    required this.passiveUsername,
    required this.passivePassword,
    required this.idUsername,
    required this.idPassword,
    required this.passiveSubscriptionId,
    required this.frmEndpoint,
    required this.acasEndpoint,
    required this.livenessEndpoint,
  });

  factory AcuantConfig.fromJson(Map<String, dynamic> json) {
    return AcuantConfig(
      passiveUsername: json['passive_username'] as String,
      passivePassword: json['passive_password'] as String,
      idUsername: json['id_username'] as String,
      idPassword: json['id_password'] as String,
      passiveSubscriptionId: json['passive_subscription_id'] as String,
      frmEndpoint: json['frm_endpoint'] as String,
      acasEndpoint: json['acas_endpoint'] as String,
      livenessEndpoint: json['liveness_endpoint'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passive_username': passiveUsername,
      'passive_password': passivePassword,
      'id_username': idUsername,
      'id_password': idPassword,
      'passive_subscription_id': passiveSubscriptionId,
      'frm_endpoint': frmEndpoint,
      'acas_endpoint': acasEndpoint,
      'liveness_endpoint': livenessEndpoint,
    };
  }
}

class AppConfig {
  final ApiConfig apiConfig;
  final AcuantConfig acuantConfig;

  AppConfig({
    required this.apiConfig,
    required this.acuantConfig,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      apiConfig: ApiConfig.fromJson(json['api_config'] as Map<String, dynamic>),
      acuantConfig: AcuantConfig.fromJson(json['acuant_config'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'api_config': apiConfig.toJson(),
      'acuant_config': acuantConfig.toJson(),
    };
  }
} 