import 'package:flutter/material.dart';
import 'package:venti_metri/screens/venti_m_q_dashboard.dart';
import 'package:venti_metri/utils/utils.dart';

class BranchChooseScreen extends StatefulWidget {
  static String id = 'choose';
  @override
  _BranchChooseScreenState createState() => _BranchChooseScreenState();
}

class _BranchChooseScreenState extends State<BranchChooseScreen> {
  ScrollController scrollViewColtroller = ScrollController();


  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        backgroundColor: VENTI_METRI_GREY,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: VENTI_METRI_GREY,
          title: Center(child: Text('20m² - Drink & Enjoy')),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.person ,size: 30.0, color: Colors.white,), onPressed: (){

            }
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () =>
                        showDialog(
                            context: context,
                            builder: (context) {
                              return VentiMetriQuadriDashboard(
                                branch: 'Cisternino',
                              );
                            }
                        ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/cisternino.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Cisternino', style: TextStyle(color: Colors.white, fontSize: 30),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () =>
                        showDialog(
                            context: context,
                            builder: (context) {
                              return VentiMetriQuadriDashboard(
                                branch: 'Locorotondo',
                              );
                            }
                        ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/locorotondo.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Locorotondo', style: TextStyle(color: Colors.white, fontSize: 30),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () =>
                        showDialog(
                            context: context,
                            builder: (context) {
                              return VentiMetriQuadriDashboard(
                                branch: 'Monopoli',
                              );
                            }
                        ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/monopoli.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Monopoli', style: TextStyle(color: Colors.white, fontSize: 30),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  color: Colors.white,
                  child: GestureDetector(
                    onTap: () => {},
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/discoteche.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.black, BlendMode.dst),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Serate', style: TextStyle(color: Colors.white, fontSize: 30),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
