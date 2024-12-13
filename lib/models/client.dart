class Client {
  final int customPk;
  final String? id;
  final String? name;
  final String? nationalId;
  final String gender;
  final DateTime? birthDate;
  final int? age;
  final String phone;
  final String? phone2;
  final String? email;
  final String? address;
  final String? photoUrl;
  String? requestedPhotoUrl;
  final bool isBlocked;
  final double? weight;
  final double? height;

  Client({
    required this.customPk,
    this.id,
    this.name,
    this.nationalId,
    this.gender = "male",
    this.birthDate,
    this.age,
    required this.phone,
    this.phone2,
    this.email,
    this.address,
    this.photoUrl,
    this.requestedPhotoUrl,
    this.isBlocked = false,
    this.weight,
    this.height,
  });

  // fromJson factory method
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        customPk: json["custom_pk"],
        id: json['id'] as String?,
        name: json['name'] as String?,
        nationalId: json['national_id'] as String?,
        gender: json['gander'] as String? ?? 'male',
        birthDate: json['birth_date'] != null
            ? DateTime.parse(json['birth_date'])
            : null,
        age: json['age'] as int?,
        phone: json['phone'] as String,
        phone2: json['phone2'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
        photoUrl: json['photo'] as String?,
        isBlocked: json['is_blocked'] as bool? ?? false,
        weight: (json['weight'] as num?)?.toDouble(),
        height: (json['height'] as num?)?.toDouble(),
        requestedPhotoUrl: json["requested_photo"] as String?);
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'custom_pk': customPk,
      'id': id,
      'name': name,
      'national_id': nationalId,
      'gander': gender,
      'birth_date': birthDate?.toIso8601String(),
      'age': age,
      'phone': phone,
      'phone2': phone2,
      'email': email,
      'address': address,
      'photo': photoUrl,
      'requested_photo': requestedPhotoUrl,
      'is_blocked': isBlocked,
      'weight': weight,
      'height': height,
    };
  }

  String? birthDateString() => birthDate != null
      ? "${birthDate!.year}-${birthDate!.month}-${birthDate!.day}"
      : null;

  void resetRequestedPhoto() {
    requestedPhotoUrl = null;
  }
}
