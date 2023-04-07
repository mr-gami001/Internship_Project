
class StudentModel{

  String? name;
  String? userid;
  int? busno;
  String? password;

  StudentModel(
      this.name,
      this.userid,
      this.busno,
      this.password
      );

  factory StudentModel.fromJson(Map json){
    return StudentModel(json['name'], json['userid'],json['busno'],json['password']);
  }

  toJson(){
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['name'] = this.name;
    json['userid'] = this.userid;
    json['busno'] = this.busno;
    json['password'] = this.password;
  }
}