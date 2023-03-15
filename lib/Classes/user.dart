class User {
  final String name;
  final String contractname;
  final String another_email;
  final bool have_checked;
  final String time;
  final String order;
  final String path;
  

  
  User({
    required this.name,
    required this.contractname,
    required this.another_email,
    required this.have_checked,
    required this.time,
    required this.order,
    required this.path,
  });

  Map<String, dynamic> toJson() =>{
    'name': name,
    'contractname': contractname,
    'another_email': another_email,
    'have_checked': have_checked,
    'time': time,
    'order': order,
    'path': path
  };
  
  static User fromJson(Map<String, dynamic> json)=>User(
    name: json['name'],
    contractname: json['contractname'],
    another_email: json['another_email'],
    have_checked: json['have_checked'],
    time: json['time'],
    order: json['order'], 
    path: json['path'],
  );
}