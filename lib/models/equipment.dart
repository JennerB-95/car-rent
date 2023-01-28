class Equipment {
  String id;
  String equipment_category_id;
  String equipment_id;
  String title;
  String slug;
  String features;
  String description;
  String thumbnail_image;
  String slider_images;
  String name;
  String per_day_price;
  String per_week_price;
  /*String city;
  String address;
  bool alive;
  bool active;
  int entity;
  int cabin;
  String email;*/

  Equipment({
    this.id,
    this.equipment_category_id,
    this.equipment_id,
    this.title,
    this.slug,
    this.features,
    this.description,
    this.thumbnail_image,
    this.slider_images,
    this.name,
    this.per_day_price,
    this.per_week_price,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      equipment_category_id: json['equipment_category_id'],
      equipment_id: json['equipment_id'],
      title: json['title'],
      slug: json['slug'],
      features: json['features'],
      description: json['description'],
      thumbnail_image: json['thumbnail_image'],
      slider_images: json['slider_images'],
      name: json['name'],
      per_day_price: json['per_day_price'],
      per_week_price: json['per_week_price'],
    );
  }
}
