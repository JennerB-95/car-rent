class MisReservas {
  String user_id;
  String start_date;
  String end_date;
  String grand_total;
  String thumbnail_image;

  MisReservas({
    this.user_id,
    this.start_date,
    this.end_date,
    this.grand_total,
    this.thumbnail_image,
  });

  factory MisReservas.fromJson(Map<String, dynamic> json) {
    return MisReservas(
      user_id: json["user_id"],
      start_date: json["start_date"],
      end_date: json["end_date"],
      grand_total: json["grand_total"],
      thumbnail_image: json["thumbnail_image"],
    );
  }
}
