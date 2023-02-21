class Report {
  String entity;
  String observation;
  String date;
  String photo;

  Report({this.entity, this.observation, this.date, this.photo});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        entity: json["empresa"],
        observation: json["observacion"],
        date: json["fecha_hora"],
        photo: json["photo"]);
  }
}
