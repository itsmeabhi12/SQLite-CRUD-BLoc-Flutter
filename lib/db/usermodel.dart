class UserModel {
  final int? id;
  final String? name;
  UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String, Object?> user) {
    return UserModel(id: user['id'] as int?, name: user['name'] as String);
  }

  Map<String, Object> toJson({required UserModel userModel}) {
    if (userModel.id == null) {
      return {"name": userModel.name!};
    }
    return {"id": userModel.id!, "name": userModel.name!};
  }

  UserModel copyWith({int? id, String? name}) =>
      UserModel(id: id ?? this.id, name: name ?? this.name);
}
