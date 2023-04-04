class MisReservas {
  String id;
  String title;
  String start_date;
  String end_date;
  String created_at;
  String grand_total;
  String thumbnail_image;
  String location;

  // dpi license and passport photos
  String dpiFront;
  String dpiBack;
  String licenseFront;
  String licenseBack;

  // User vars
  String name;
  String address;
  String nit;
  String phone;
  String nacimiento;
  String dpi_pass;
  String licencia;
  String licencia_vence;
  String tipo_licencia;

  //User auths vars
  String id_user_auth_one;
  String name_auth_1;
  String nacimiento_auth_1;
  String direccion_auth_1;
  String telefono_auth_1;
  String dpi_auth_1;
  String licencia_auth_1;
  String licencia_vence_auth_1;
  String tipo_licencia_auth_1;
  String nit_auth_1;

  //User auth 2
  String id_user_auth_dos;
  String name_auth_2;
  String nacimiento_auth_2;
  String direccion_auth_2;
  String telefono_auth_2;
  String dpi_auth_2;
  String licencia_auth_2;
  String licencia_vence_auth_2;
  String tipo_licencia_auth_2;
  String nit_auth_2;

  MisReservas({
    this.id,
    this.title,
    this.start_date,
    this.end_date,
    this.created_at,
    this.grand_total,
    this.thumbnail_image,
    this.location,

    // dpi license and passport photos
    this.dpiFront,
    this.dpiBack,
    this.licenseFront,
    this.licenseBack,

    // User
    this.name,
    this.address,
    this.nit,
    this.phone,
    this.nacimiento,
    this.dpi_pass,
    this.licencia,
    this.licencia_vence,
    this.tipo_licencia,
    //User auth 1
    this.id_user_auth_one,
    this.name_auth_1,
    this.nacimiento_auth_1,
    this.direccion_auth_1,
    this.telefono_auth_1,
    this.dpi_auth_1,
    this.licencia_auth_1,
    this.licencia_vence_auth_1,
    this.tipo_licencia_auth_1,
    this.nit_auth_1,

    // User auth 2
    this.id_user_auth_dos,
    this.name_auth_2,
    this.nacimiento_auth_2,
    this.direccion_auth_2,
    this.telefono_auth_2,
    this.dpi_auth_2,
    this.licencia_auth_2,
    this.licencia_vence_auth_2,
    this.tipo_licencia_auth_2,
    this.nit_auth_2,
  });

  factory MisReservas.fromJson(Map<String, dynamic> json) {
    return MisReservas(
      id: json['id'] as String,
      title: json["title"],
      start_date: json["start_date"],
      end_date: json["end_date"],
      created_at: json["created_at"],
      grand_total: json["grand_total"],
      thumbnail_image: json["thumbnail_image"],
      location: json["location"],
      name: json["name"],
      address: json["address"],
      nit: json["Nit"],
      phone: json["contact_number"],
      nacimiento: json["fecha_nacimiento"],
      dpi_pass: json["Dpi_Pasaporte"],
      licencia: json["Licencia"],
      licencia_vence: json["Vence"],
      tipo_licencia: json["Tipo_Licencia"],
      id_user_auth_one: json["id_user_auth_one"],
      name_auth_1: json["name_auth_1"],
      nacimiento_auth_1: json["nacimiento_auth_1"],
      direccion_auth_1: json["direccion_auth_1"],
      telefono_auth_1: json["telefono_auth_1"],
      dpi_auth_1: json["dpi_auth_1"],
      licencia_auth_1: json["licencia_auth_1"],
      licencia_vence_auth_1: json["licencia_vence_auth_1"],
      tipo_licencia_auth_1: json["tipo_licencia_auth_1"],
      nit_auth_1: json["nit_auth_1"],
      id_user_auth_dos: json["id_user_auth_dos"],
      name_auth_2: json["name_auth_2"],
      nacimiento_auth_2: json["nacimiento_auth_2"],
      direccion_auth_2: json["direccion_auth_2"],
      telefono_auth_2: json["telefono_auth_2"],
      dpi_auth_2: json["dpi_auth_2"],
      licencia_auth_2: json["licencia_auth_2"],
      licencia_vence_auth_2: json["licencia_vence_auth_2"],
      tipo_licencia_auth_2: json["tipo_licencia_auth_2"],
      nit_auth_2: json["nit_auth_2"],
      dpiFront: json["dpifront"],
      dpiBack: json["dpiback"],
      licenseFront: json["licensefront"],
      licenseBack: json["licenseback"],
    );
  }

  int get yearsOld {
    final now = DateTime.now();
    final date = DateTime.parse(nacimiento ?? "2020-02-03");

    int age = now.year - date.year;
    int m1 = now.month, m2 = date.month;

    if (m2 > m1) {
      age--;
    } else if (m2 == m1) {
      int d1 = now.day, d2 = date.day;

      if (d2 > d1) {
        age--;
      }
    }

    return age;
  }

  int get yearsOldAuth1 {
    final now = DateTime.now();
    final date = DateTime.parse(nacimiento_auth_1 ?? "2020-02-03");

    int age = now.year - date.year;
    int m1 = now.month, m2 = date.month;

    if (m2 > m1) {
      age--;
    } else if (m2 == m1) {
      int d1 = now.day, d2 = date.day;

      if (d2 > d1) {
        age--;
      }
    }

    return age;
  }

  int get yearsOldAuth2 {
    final now = DateTime.now();
    final date = DateTime.parse(nacimiento_auth_2 ?? "2020-02-03");

    int age = now.year - date.year;
    int m1 = now.month, m2 = date.month;

    if (m2 > m1) {
      age--;
    } else if (m2 == m1) {
      int d1 = now.day, d2 = date.day;

      if (d2 > d1) {
        age--;
      }
    }

    return age;
  }
}
