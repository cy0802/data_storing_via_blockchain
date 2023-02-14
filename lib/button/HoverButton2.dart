import 'package:flutter/material.dart';

class HovBut2 extends StatefulWidget {
  const HovBut2({super.key});

  @override
  State<HovBut2> createState() => _HovBut2State();
}

class _HovBut2State extends State<HovBut2> {
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
            Icons.article_rounded,
            color: Colors.white,
          ),
          onTap:(){
            Navigator.pushNamed(context, '/StdCon');
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