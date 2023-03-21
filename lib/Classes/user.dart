class User {
  final String name;
  final String contractname;
  final String another_email;
  final String time;
  final String order;
  final String path;

  User({
    required this.name,
    required this.contractname,
    required this.another_email,
    required this.time,
    required this.order,
    required this.path,
  });

  Map<String, dynamic> toJson() =>{
    'name': name,
    'contractname': contractname,
    'another_email': another_email,
    'time': time,
    'order': order,
    'path': path,
  };
  
  static User fromJson(Map<String, dynamic> json)=>User(
    name: json['name'],
    contractname: json['contractname'],
    another_email: json['another_email'],
    time: json['time'],
    order: json['order'], 
    path: json['path'],
  );
}