class User {
  int? id;
  int? roleId;
  String? name;
  Null? email;
  String? avatar;
  Null? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? yearId;
  int? langId;
  String? phone;

  User(
      {this.id,
        this.roleId,
        this.name,
        this.email,
        this.avatar,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.yearId,
        this.langId,
        this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    yearId = json['year_id'];
    langId = json['lang_id'];
    phone = json['phone'];
  }

}
