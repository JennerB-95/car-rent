class Report {
  String entity;
  String observation;
  String date;
  String fotografia;

  Report({this.entity, this.observation, this.date, this.fotografia});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        entity: json["empresa"],
        observation: json["observacion"],
        date: json["fecha_hora"],
        fotografia: json["fotografia"]);
  }
}
