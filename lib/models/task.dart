// models used to get and fetch data in database
class Task {
  int? id; // id in database
  String? title;
  String? note;
  bool? isCompleted;
  String? date;
  String? startTime;
  // String? endTime;
  int? color;
  int? remind;
  String? repeat;
  bool? isStar;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    // this.endTime,
    this.color,
    this.remind,
    this.repeat,
    this.isStar,
  });

  /* 从数据库获取信息
  * Fetch data from database
  * */
  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    // endTime = json['endTime'];
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'];
    isStar = json['isStar'];
  }

  /* 信息写入数据库
  * Write in data into database
  * */
  Map<String, dynamic> toJson() {
    // Json format: "key","value"
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // TODO ?? this. is necessary?
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['note'] = this.note;
    data['isCompleted'] = this.isCompleted;
    data['startTime'] = this.startTime;
    // data['endTime'] = this.endTime;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['repeat'] = this.repeat;
    data['isStar'] = this.isStar;
    return data;
  }
}
