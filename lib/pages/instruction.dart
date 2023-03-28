import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Instruction extends StatefulWidget {
  const Instruction({super.key});

  @override
  State<Instruction> createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index){
            setState(()=> isLastPage = index == 2);
          },
          children: [
            Container(
              color: Colors.red,
              child: const Center(child: Text('page 1'))
            ),
            Container(
              color: Colors.red,
              child: const Center(child: Text('page 1'))
            ),
            Container(
              color: Colors.red,
              child: const Center(child: Text('page 1'))
            )
          ],
        ),
      ),
      bottomSheet: isLastPage
      ? TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          primary: Colors.white,
          backgroundColor: Colors.teal.shade700,
          minimumSize: const Size.fromHeight(80)
        ),
          child: const Text(
            "Let's preserve your own contract!",
            style: TextStyle(fontSize: 24),
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        )
        : Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text('Skip'),
                onPressed: () => controller.jumpToPage(2), 
                
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 3,
                  effect: WormEffect(
                    spacing: 16,
                    dotColor: Colors.black,
                    activeDotColor: Colors.teal.shade700,
                  ),
                  onDotClicked: (index) => controller.animateToPage(
                    index, 
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.easeIn,
                  ),
                )
              ),
              TextButton(
                child: const Text('Next'),
                onPressed: () => controller.nextPage(
                  duration: const Duration(milliseconds: 500), 
                  curve: Curves.easeOut,
                ), 
                
              )
          ],
        )
      ),
    );
  }
}