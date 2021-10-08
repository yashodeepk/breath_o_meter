class DataModel {
  final int id;
  final double holdPeriod;
  final int timeStamp;

  DataModel({
    this.id,
    this.holdPeriod,
    this.timeStamp,
  });

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
        id: json["id"],
        holdPeriod: json["holdPeriod"],
        timeStamp: json["timeStamp"],
      );

  Map<String, dynamic> tomap() => {
        "id": id,
        "holdPeriod": holdPeriod,
        "timeStamp": timeStamp,
      };
}
