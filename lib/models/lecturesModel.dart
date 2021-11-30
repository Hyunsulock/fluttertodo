class LecturesModel {
  int? id;
  String? course_id;
  int? start;
  int? end;
  int? date;
  int? table_id;

  LecturesModel(
      {this.id,
      this.course_id,
      this.start,
      this.end,
      this.date,
      this.table_id});

  LecturesModel.fromJson(Map<String, dynamic> json, {int table = -1}) {
    id = json['id'];
    course_id = json['course_id'];
    start = json['start'];
    end = json['end'];
    date = json['date'];
    table_id = json['table_id'] != null ? json['table_id'] : table;
    ;
  }

  Map<String, dynamic> ToJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.course_id;
    data['start'] = this.start;
    data['end'] = this.end;
    data['date'] = this.date;
    data['table_id'] = this.table_id;
    return data;
  }

  String ToString() {
    return '{id : ${this.id}, course_id: ${this.course_id}, start: ${this.start},end: ${this.end},date: ${this.date}, table_id : ${this.table_id}';
  }
}
