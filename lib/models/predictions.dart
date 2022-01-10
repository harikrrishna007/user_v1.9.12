class Predictions {
  late String mainText;
  late String secondaryText;
  late String placeID;

  Predictions({required this.secondaryText, required this.mainText, required this.placeID});
  Predictions.fromJson(Map<String, dynamic> json) {
    placeID = json["place_id"];
    mainText = json["structured_formatting"]["main_text"];
    secondaryText = json["structured_formatting"]["secondary_text"];
  }
}