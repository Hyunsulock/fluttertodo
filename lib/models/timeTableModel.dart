class TimeTableModel {
  int? id;
  String? title;
  int? year;
  int? semester;

  TimeTableModel({this.id, this.title, this.year, this.semester});

  TimeTableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    year = json['year'];
    semester = json['semester'];
  }

  Map<String, dynamic> ToJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['year'] = this.year;
    data['semester'] = this.semester;
    return data;
  }
}
