class UserPreserve {
  final String name;
  final String contractname;
  final String another_email;
  final String key;
  final String time;
  final String pic_cid;

  
  UserPreserve({
    required this.name,
    required this.contractname,
    required this.another_email,
    required this.key,
    required this.time,
    required this.pic_cid,
  });

  Map<String, dynamic> toJson() =>{
    'name': name,
    'contractname': contractname,
    'another_email': another_email,
    'key': key,
    'time': time,
    'pic_cid': pic_cid,

  };
  
  static UserPreserve fromJson(Map<String, dynamic> json)=>UserPreserve(
    name: json['name'],
    contractname: json['contractname'],
    another_email: json['another_email'],
    key: json['key'],
    time: json['time'],
    pic_cid: json['pic_cid'],
  );
}