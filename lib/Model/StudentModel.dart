
class StudentModel{

  String? name;
  String? userid;
  int? busno;
  String? rollno;

  StudentModel(
      this.name,
      this.userid,
      this.busno,
      this.rollno
      );

  factory StudentModel.fromJson(Map json){
    return StudentModel(json['name'], json['userid'],json['busno'],json['rollno']);
  }

  toJson(){
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['name'] = this.name;
    json['userid'] = this.userid;
    json['busno'] = this.busno;
    json['password'] = this.rollno;
  }
}