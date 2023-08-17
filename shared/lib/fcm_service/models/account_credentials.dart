import 'package:googleapis_auth/auth_io.dart' show ServiceAccountCredentials;

extension FirebaseAccountCredentialsExt on FirebaseAccountCredentials {
  ServiceAccountCredentials get googleAccountCredentials =>
      ServiceAccountCredentials.fromJson({
        "client_id": clientId,
        "private_key": privateKey,
        "client_email": clientEmail,
        "type": type
      });
}

class FirebaseAccountCredentials {
  final String? type;
  final String? projectID;
  final String? privateKeyId;
  final String? privateKey;
  final String? clientEmail;
  final String? clientId;

  factory FirebaseAccountCredentials.fromMap(Map<String, dynamic> map) =>
      FirebaseAccountCredentials(
        type: map['type'],
        projectID: map['project_id'],
        privateKeyId: map['private_key_id'],
        privateKey: map['private_key'],
        clientEmail: map['client_email'],
        clientId: map['client_id'],
      );

  Map<String, dynamic> get toMap => {
        'type': type,
        'project_id': projectID,
        'private_key_id': privateKeyId,
        'private_key': privateKey,
        'client_email': clientEmail,
        'client_id': clientId,
      };

  const FirebaseAccountCredentials({
    this.type,
    this.projectID,
    this.privateKeyId,
    this.privateKey,
    this.clientEmail,
    this.clientId,
  });
}
