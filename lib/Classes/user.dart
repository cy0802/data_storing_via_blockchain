class User {
  final String name;
  final String contractname;
  final String another_email;
  final bool have_checked;
  
  User({
    required this.name,
    required this.contractname,
    required this.another_email,
    required this.have_checked,
  });

  Map<String, dynamic> toJson() =>{
    'name': name,
    'contractname': contractname,
    'another_email': another_email,
    'have_checked': have_checked,
  };
  
  static User fromJson(Map<String, dynamic> json)=>User(
    name: json['name'],
    contractname: json['contractname'],
    another_email: json['another_email'],
    have_checked: json['have_checked'],
  );
}