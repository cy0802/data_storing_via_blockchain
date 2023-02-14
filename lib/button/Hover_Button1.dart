import 'package:flutter/material.dart';

class HovBut1 extends StatefulWidget {
  const HovBut1({super.key});

  @override
  State<HovBut1> createState() => _HovBut1State();
}

class _HovBut1State extends State<HovBut1> {
  bool isHover=false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 250,
      width: 150,
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(top: (isHover) ? 20 : 30.0, bottom:!(isHover)? 20:30),
      child: Container(
        height: 1000,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 106, 182, 244),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),  
        ),
        child: InkWell(
          child: const Icon(
            Icons.add_to_home_screen,
            color: Colors.white,
          ),
          onTap:(){
            Navigator.pushNamed(context, '/NormCon');
          },
          onHover:(val){
            setState((){
              isHover=val;
            });
          } 
        ),
      ),
    );
  }
}