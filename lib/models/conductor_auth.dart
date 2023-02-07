class ConductorAutorizado {
  String id;
  String id_user;
  String nombre_aux;
  String fecha_nacimiento;
  String direccion_aux;
  String telefono_aux;
  String dpi_pass;
  String licencia_aux;
  String licencia_vence_aux;
  String tipo_licencia_aux;
  String nit_aux;

  ConductorAutorizado({
    this.id,
    this.id_user,
    this.nombre_aux,
    this.fecha_nacimiento,
    this.direccion_aux,
    this.telefono_aux,
    this.dpi_pass,
    this.licencia_aux,
    this.licencia_vence_aux,
    this.tipo_licencia_aux,
    this.nit_aux,
  });

  factory ConductorAutorizado.fromJson(Map<String, dynamic> json) {
    return ConductorAutorizado(
      id: json["id"],
      id_user: json["id_user"],
      nombre_aux: json["nombre_aux"],
      fecha_nacimiento: json["fecha_nacimiento"],
      direccion_aux: json["direccion_aux"],
      telefono_aux: json["telefono_aux"],
      dpi_pass: json["dpi_pass"],
      licencia_aux: json["licencia_aux"],
      licencia_vence_aux: json["licencia_vence_aux"],
      tipo_licencia_aux: json["tipo_licencia_aux"],
      nit_aux: json["nit_aux"],
    );
  }
}
