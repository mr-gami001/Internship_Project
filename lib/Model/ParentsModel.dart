

class ParentsModel{

  String? password;
  String? userid;
  String? name;
  String? studentuserid;

  ParentsModel(
      this.userid,
      this.password,
      this.name,
      this.studentuserid
      );

  ParentsModel.fromJson(Map json){
    this.userid = json['userid'];
    this.password = json['password'];
    this.name = json['name'];
    this.studentuserid = json['studentuserid'];
  }

  toJson(){
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['userid'] = this.userid;
    json['password'] = this.password;
    json['name'] = this.name;
    json['studentuserid'] = this.studentuserid;
  }

}