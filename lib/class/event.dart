class Event {
  int id;
  String title;
  String description;
  double? longitude;
  double? latitude;
  String? street;
  String? city;
  String? zipcode;
  String date;

  Event(this.id, this.title, this.description, this.longitude, this.latitude,
      this.street, this.city, this.zipcode, this.date);
}
