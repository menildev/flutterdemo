class ProductModel {
   String name;
   String launchedAt;
   String launchSite;
   double popularity;

  ProductModel(this.name, this.launchedAt,this.launchSite,this.popularity);

  ProductModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        launchedAt = json['launchedAt'],
        launchSite = json['launchSite'],
        popularity = json['popularity'];

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "name": name,
      "launchedAt": launchedAt,
      "launchSite": launchSite,
      "popularity": popularity,
    };
  }
}
