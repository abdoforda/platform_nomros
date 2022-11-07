class Home {
  String? whatsapp;
  String? v;
  User? user;
  List<Slidshow>? slidshow;
  List<Comingsoon>? comingsoon;
  List<Notificatios>? notificatios;

  Home(
      {this.whatsapp,
        this.v,
        this.user,
        this.slidshow,
        this.comingsoon,
        this.notificatios});

  Home.fromJson(Map<String, dynamic> json) {
    whatsapp = json['whatsapp'];
    v = json['v'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['slidshow'] != null) {
      slidshow = <Slidshow>[];
      json['slidshow'].forEach((v) {
        slidshow!.add(new Slidshow.fromJson(v));
      });
    }
    if (json['comingsoon'] != null) {
      comingsoon = <Comingsoon>[];
      json['comingsoon'].forEach((v) {
        comingsoon!.add(new Comingsoon.fromJson(v));
      });
    }
    if (json['notificatios'] != null) {
      notificatios = <Notificatios>[];
      json['notificatios'].forEach((v) {
        notificatios!.add(new Notificatios.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['whatsapp'] = this.whatsapp;
    data['v'] = this.v;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.slidshow != null) {
      data['slidshow'] = this.slidshow!.map((v) => v.toJson()).toList();
    }
    if (this.comingsoon != null) {
      data['comingsoon'] = this.comingsoon!.map((v) => v.toJson()).toList();
    }
    if (this.notificatios != null) {
      data['notificatios'] = this.notificatios!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  int? roleId;
  String? name;
  Null? email;
  String? avatar;
  Null? emailVerifiedAt;
  int? yearId;
  int? langId;
  String? phone;
  String? deviceId;
  Year? year;
  Langother? langother;

  User(
      {this.id,
        this.roleId,
        this.name,
        this.email,
        this.avatar,
        this.emailVerifiedAt,
        this.yearId,
        this.langId,
        this.phone,
        this.deviceId,
        this.year,
        this.langother});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    emailVerifiedAt = json['email_verified_at'];
    yearId = json['year_id'];
    langId = json['lang_id'];
    phone = json['phone'];
    deviceId = json['device_id'];
    year = json['year'] != null ? new Year.fromJson(json['year']) : null;
    langother = json['langother'] != null
        ? new Langother.fromJson(json['langother'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['year_id'] = this.yearId;
    data['lang_id'] = this.langId;
    data['phone'] = this.phone;
    data['device_id'] = this.deviceId;
    if (this.year != null) {
      data['year'] = this.year!.toJson();
    }
    if (this.langother != null) {
      data['langother'] = this.langother!.toJson();
    }
    return data;
  }
}

class Year {
  int? id;
  String? name;
  List<Materials>? materials;

  Year({this.id, this.name, this.materials});

  Year.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['materials'] != null) {
      materials = <Materials>[];
      json['materials'].forEach((v) {
        materials!.add(new Materials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.materials != null) {
      data['materials'] = this.materials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Materials {
  int? id;
  String? name;
  String? image;
  Pivot? pivot;
  List<Teachers>? teachers;

  Materials({this.id, this.name, this.image, this.pivot, this.teachers});

  Materials.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    if (json['teachers'] != null) {
      teachers = <Teachers>[];
      json['teachers'].forEach((v) {
        teachers!.add(new Teachers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    if (this.teachers != null) {
      data['teachers'] = this.teachers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pivot {
  int? yearId;
  int? materialId;

  Pivot({this.yearId, this.materialId});

  Pivot.fromJson(Map<String, dynamic> json) {
    yearId = json['year_id'];
    materialId = json['material_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year_id'] = this.yearId;
    data['material_id'] = this.materialId;
    return data;
  }
}

class Teachers {
  int? id;
  String? name;
  String? image;
  int? materialId;
  int? countVideos;
  int? countReviews;
  List<Units>? units;

  Teachers(
      {this.id,
        this.name,
        this.image,
        this.materialId,
        this.countVideos,
        this.countReviews,
        this.units});

  Teachers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    materialId = json['material_id'];
    countVideos = json['count_videos'];
    countReviews = json['count_reviews'];
    if (json['units'] != null) {
      units = <Units>[];
      json['units'].forEach((v) {
        units!.add(new Units.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['material_id'] = this.materialId;
    data['count_videos'] = this.countVideos;
    data['count_reviews'] = this.countReviews;
    if (this.units != null) {
      data['units'] = this.units!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Units {
  int? id;
  int? teacherId;
  String? title;
  List<Lectures>? lectures;

  Units({this.id, this.teacherId, this.title, this.lectures});

  Units.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teacherId = json['teacher_id'];
    title = json['title'];
    if (json['lectures'] != null) {
      lectures = <Lectures>[];
      json['lectures'].forEach((v) {
        lectures!.add(new Lectures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teacher_id'] = this.teacherId;
    data['title'] = this.title;
    if (this.lectures != null) {
      data['lectures'] = this.lectures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lectures {
  int? id;
  int? unitId;
  String? title;
  String? price;
  String? image;
  int? likes;
  bool? isPaid;
  String? key;
  String? cat;
  String? ago;

  Lectures(
      {this.id,
        this.unitId,
        this.title,
        this.price,
        this.image,
        this.likes,
        this.isPaid,
        this.key,
        this.cat,
        this.ago});

  Lectures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitId = json['unit_id'];
    title = json['title'];
    price = json['price'];
    image = json['image'];
    likes = json['likes'];
    isPaid = json['is_paid'];
    key = json['key'];
    cat = json['cat'];
    ago = json['ago'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unit_id'] = this.unitId;
    data['title'] = this.title;
    data['price'] = this.price;
    data['image'] = this.image;
    data['likes'] = this.likes;
    data['is_paid'] = this.isPaid;
    data['key'] = this.key;
    data['cat'] = this.cat;
    data['ago'] = this.ago;
    return data;
  }
}

class Langother {
  int? id;
  String? name;

  Langother({this.id, this.name});

  Langother.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Slidshow {
  int? id;
  String? image;
  String? type;
  String? direction;
  Lectures? lecture;

  Slidshow({this.id, this.image, this.type, this.direction, this.lecture});

  Slidshow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    type = json['type'];
    direction = json['direction'];
    lecture =
    json['lecture'] != null ? new Lectures.fromJson(json['lecture']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['type'] = this.type;
    data['direction'] = this.direction;
    if (this.lecture != null) {
      data['lecture'] = this.lecture!.toJson();
    }
    return data;
  }
}

class Comingsoon {
  String? name;
  List<Lectures>? lectures;

  Comingsoon({this.name, this.lectures});

  Comingsoon.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['lectures'] != null) {
      lectures = <Lectures>[];
      json['lectures'].forEach((v) {
        lectures!.add(new Lectures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.lectures != null) {
      data['lectures'] = this.lectures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notificatios {
  int? id;
  int? yearId;
  String? title;
  String? createdAt;
  String? yearName;

  Notificatios(
      {this.id, this.yearId, this.title, this.createdAt, this.yearName});

  Notificatios.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yearId = json['year_id'];
    title = json['title'];
    createdAt = json['created_at'];
    yearName = json['year_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['year_id'] = this.yearId;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['year_name'] = this.yearName;
    return data;
  }
}
