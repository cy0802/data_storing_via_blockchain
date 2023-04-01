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
            setState(()=> isLastPage = index == 3);
          },
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Color.fromARGB(107, 0, 0, 0), BlendMode.dstATop),
                  image: AssetImage("assets/brown.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Spacer(flex: 2),
                    Text(
                      'First Step',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Spacer(flex: 2),
                    Spacer(flex: 1),
                    Text(
                      'Click "Upload Contract" botton',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(flex: 1),
                    Text(
                      'And fill in below Form',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(flex: 3),
                    Image.asset('assets/Form.png'),
                    Spacer(flex: 4),
                  ],
                ),
              )
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Color.fromARGB(107, 0, 0, 0), BlendMode.dstATop),
                  image: AssetImage("assets/brown.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Spacer(flex: 2),
                    Text(
                      'Second Step',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Spacer(flex: 1),
                    Text(
                      'Click "My contracts"',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Spacer(flex: 1),
                    Text(
                      'you will see Two tab bars',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(flex: 1),
                    Image.asset('assets/ShowBar.png'),
                    Spacer(flex: 2),
                    Center(
                      child: Text(
                        'In "wait to be uploaded"',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Center(
                      child: Text(
                        'you can see a list of contracts',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'waited for you to be uploaded',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                    Center(
                      child: Text(
                        'In "uploaded"',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Center(
                      child: Text(
                        'you can see a list of contracts',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'having already been uploaded',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Spacer(flex: 3),
                  ],
                ),
              )
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Color.fromARGB(107, 0, 0, 0), BlendMode.dstATop),
                  image: AssetImage("assets/brown.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Spacer(flex: 2),
                    Text(
                      'Third Step',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Spacer(flex: 1),
                    Text(
                      'In "wait to be uploaded"',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Spacer(flex: 1),
                    Text(
                      "each state below allows you to",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "view your contract's detail",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(flex: 2),
                      Image.asset(
                      'assets/StateWFA.png',
                      fit: BoxFit.contain
                    ),
                    Spacer(flex: 1),
                    Image.asset(
                      'assets/StateA.png',
                      fit: BoxFit.contain,
                    ),
                    Spacer(flex: 1),
                    Image.asset(
                      'assets/StateWFU.png',
                      fit: BoxFit.contain,
                    ),
                    Spacer(flex: 1),
                    Image.asset(
                      'assets/StateU.png',
                      fit: BoxFit.contain,
                    ),
                    Spacer(flex: 3),
                  ],
                ),
              )
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(Color.fromARGB(107, 0, 0, 0), BlendMode.dstATop),
                  image: AssetImage("assets/brown.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 2),
                    Text(
                      'Last Step',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Spacer(flex: 2),
                    Text(
                      'In "Uploaded"',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Spacer(flex: 1),
                    Text(
                      'After going through Previous process',
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
                    Text(
                      'Uploaded Contracts will be shown here',
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),
                    Spacer(flex: 1),
                    Text(
                      'each contract contains information including',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Contract's NFT",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Contract's key",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Spacer(flex: 2),
                    Text(
                      'You can also Click this button below',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'the "Uploaded screen" to check your contract',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),

                    Spacer(flex: 1),
                    Image.asset('assets/search.png'),
                    Spacer(flex: 4),
                  ],
                ),
              )
            ),
          
          ],
        ),
      ),
      bottomSheet: isLastPage
      ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 249, 207, 116),
              Color.fromARGB(231, 239, 157, 63),
            ],
          )
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            primary: Colors.white,
            backgroundColor: Colors.transparent,
            minimumSize: const Size.fromHeight(80)
          ),
            child: const Text(
              "Let's preserve your own contract!",
              style: TextStyle(fontSize: 24),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
      )
        : Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 251, 231, 190),
                Color.fromARGB(231, 237, 210, 178),
              ],
            )
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.brown,
                  )
                ),
                onPressed: () => controller.jumpToPage(3), 
                
              ),
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 4,
                  effect: WormEffect(
                    spacing: 16,
                    dotColor: Colors.black,
                    activeDotColor: Colors.brown,
                    
                  ),
                  onDotClicked: (index) => controller.animateToPage(
                    index, 
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.easeIn,
                  ),
                )
              ),
              TextButton(
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.brown,
                  )
                ),
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