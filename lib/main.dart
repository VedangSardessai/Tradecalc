import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tradecalc/styles/my_text.dart';

import 'notifications/my_custom_notification.dart';
import 'styles/my_button.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String tradeCapital = '', stopLoss = '', riskToReward = '';
  bool isInputTradeCapital = false,
      isInputRiskToReward = false,
      isInputStopLoss = false,
      isInputTradeCapitalEntered = false,
      isInputRiskToRewardEntered = false,
      isInputStopLossEntered = false;

  double loss = 0, profit = 0, returns = 0, capitalAfterProfit = 0;

  String lossString = '',
      profitToString = '',
      returnsToString = '',
      capitalAfterProfitToString = '';

  List<String> valuesAfterCalc = [];

  MyNotifications myNotifications = MyNotifications();

  @override
  void initState() {
    super.initState();
    myNotifications.notificationInitialization();
  }

  void resetCalculations() {
    // setState(() {
    profitToString = '';
    lossString = '';
    returnsToString = '';
    capitalAfterProfitToString = '';

    isInputRiskToRewardEntered = false;
    isInputStopLossEntered = false;
    isInputTradeCapitalEntered = false;
    // });
  }

  String inputtingTradeCapital(String number) {
    String input = '';

    if (isInputTradeCapital && tradeCapital.length < 10) {
      tradeCapital += number;
      isInputTradeCapitalEntered = true;
      input = tradeCapital;
      setState(() {
        isInputTradeCapitalEntered = true;
      });
    }

    setState(() {
      tradeCapital;
    });

    if (isInputStopLoss) {
      if (stopLoss.length < 2) {
        stopLoss += number;
      }

      if (stopLoss.length == 2 && number == '.') {
        stopLoss += number;
      }

      if (stopLoss.contains('.') && number != '.') {
        stopLoss += number;
      }

      setState(() {
        isInputStopLossEntered = true;
      });

      input = stopLoss;
    }

    setState(() {
      stopLoss;
    });

    if (isInputRiskToReward) {
      if (riskToReward.isEmpty) {
        riskToReward += '$number:';
      } else if (riskToReward.length == 2) {
        riskToReward += number;
      }

      input = riskToReward;
    }

    setState(() {
      isInputRiskToRewardEntered = true;
    });
    setState(() {
      riskToReward;
    });

    resetCalculations();

    return input;
  }

  void clearInput() {
    // setState(() {
    if (isInputTradeCapital) {
      tradeCapital = '';
    }

    if (isInputStopLoss) {
      stopLoss = '';
    }

    if (isInputRiskToReward) {
      riskToReward = '';
    }

    resetCalculations();
    // });
  }

  void deleteLeftFn() {
    setState(() {
      if (tradeCapital.isNotEmpty && isInputTradeCapital) {
        tradeCapital = tradeCapital.substring(0, tradeCapital.length - 1);
      }

      if (riskToReward.isNotEmpty && isInputRiskToReward) {
        riskToReward = riskToReward.substring(0, riskToReward.length - 1);
      }

      if (stopLoss.isNotEmpty && isInputStopLoss) {
        stopLoss = stopLoss.substring(0, stopLoss.length - 1);
      }

      resetCalculations();
    });
  }

  List<String> calculateTarget(String tradingCapitalParam,
      String riskToRewardParam, String stopLossParam) {
    if (tradingCapitalParam.isNotEmpty &&
        riskToRewardParam.isNotEmpty &&
        stopLossParam.isNotEmpty) {
      double convertedTradingCapital = double.parse(tradingCapitalParam);
      double convertedLossRatio = double.parse(riskToRewardParam[0]);
      double convertedProfitRatio = double.parse(riskToRewardParam[2]);
      double convertedStopLoss = double.parse(stopLossParam) / 100;

      // setState(() {
      loss = (convertedStopLoss * convertedLossRatio * convertedTradingCapital)
          .roundToDouble();
      profit =
          (convertedStopLoss * convertedProfitRatio * convertedTradingCapital)
              .roundToDouble();

      capitalAfterProfit = (convertedTradingCapital + profit).roundToDouble();

      returns = (100 * profit / convertedTradingCapital).roundToDouble();

      if (profit >= 100000 && profit < 10000000) {
        profitToString = '${(profit / 100000).round().toString()} Lakhs';
      }

      if (loss >= 100000 && loss < 10000000) {
        lossString = '${(loss / 100000).round().toString()} Lakhs';
      }

      if (capitalAfterProfit >= 100000 && capitalAfterProfit < 10000000) {
        capitalAfterProfitToString =
            '${(capitalAfterProfit.roundToDouble() / 100000).round().toString()} Lakhs';
      }

      if (profit >= 10000000) {
        profitToString = '${(profit / 10000000).round().toString()} Crores';
      }

      if (loss >= 10000000) {
        lossString = '${(loss / 10000000).round().toString()} Crores';
      }

      if (capitalAfterProfit >= 10000000) {
        capitalAfterProfitToString =
            '${(capitalAfterProfit / 10000000).toString().substring(0, 3)} Crores';
      }

      if (profit < 100000) {
        profitToString = profit.toString();
      }
      if (loss < 100000) {
        lossString = loss.toString();
      }
      if (capitalAfterProfit < 100000) {
        capitalAfterProfitToString = capitalAfterProfit.toString();
      }

      returnsToString = returns.toString();
      if (mounted) {
        setState(() {
          returnsToString;
          lossString;
          profitToString;
          capitalAfterProfitToString;

          myNotifications.showTextNotification(
            'Wooohoo!! Here comes your profit',
            'Profit = $profitToString , Loss = $lossString \nReturns = $returnsToString , Capital after profit = $capitalAfterProfitToString\n',
          );
        });
      }
    } else {
      print('These parameters are required 201');
    }

    valuesAfterCalc.add(lossString);
    valuesAfterCalc.add(profitToString);
    valuesAfterCalc.add(returnsToString);
    valuesAfterCalc.add(capitalAfterProfitToString);

    return valuesAfterCalc;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) {
          var size = MediaQuery.of(context).size;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              title: Text(
                'Tradecalc'.toUpperCase(),
                style: GoogleFonts.poppins(
                    letterSpacing: 10,
                    fontSize: 40,
                    fontWeight: FontWeight.w500),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 10,
              ),
              child: Column(
                children: [
                  TextFormField(
                    showCursor: false,
                    // textDirection: TextDirection.rtl,
                    onTap: () => setState(() {
                      isInputTradeCapital = true;
                      isInputRiskToReward = false;
                      isInputStopLoss = false;
                    }),
                    style: GoogleFonts.poppins(
                      fontSize: size.width * .034,
                    ),
                    controller: TextEditingController(
                      text: tradeCapital,
                    ),
                    keyboardType: TextInputType.none,
                    decoration: InputDecoration(
                      labelText: 'Your Trading Capital',
                      hintText: 'Enter your trading capital in ₹',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: size.width * .036,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: size.width * 2,
                          margin: const EdgeInsets.only(right: 25),
                          child: TextFormField(
                            showCursor: false,
                            controller: TextEditingController(
                              text: riskToReward,
                            ),
                            onTap: () => setState(() {
                              isInputTradeCapital = false;
                              isInputRiskToReward = true;
                              isInputStopLoss = false;
                            }),
                            toolbarOptions: const ToolbarOptions(
                              copy: true,
                              cut: true,
                              selectAll: false,
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: size.width * .034,
                            ),
                            keyboardType: TextInputType.none,
                            decoration: InputDecoration(
                                hintStyle: GoogleFonts.poppins(
                                    fontSize: size.width * .036),
                                labelText: 'Risk to Reward',
                                hintText: '(Loss : Profit)'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: TextFormField(
                            showCursor: false,
                            controller: TextEditingController(text: stopLoss),
                            toolbarOptions: const ToolbarOptions(
                              copy: true,
                              cut: true,
                              selectAll: false,
                            ),
                            onTap: () => setState(() {
                              isInputTradeCapital = false;
                              isInputRiskToReward = false;
                              isInputStopLoss = true;
                            }),
                            keyboardType: TextInputType.none,
                            style: GoogleFonts.poppins(
                              fontSize: size.width * .034,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Stop Loss (%)',
                              hintText: 'Stop Loss in % ',
                              hintMaxLines: 1,
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: size.width * .036),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Target = $profitToString',
                            style: GoogleFonts.poppins(
                                fontSize: size.width * .034,
                                color: Colors.green),
                          ),
                          Container(
                            height: size.height * .02,
                          ),
                          Text(
                            'Loss = $lossString',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                                fontSize: size.width * .034, color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        child: Text(
                          'Returns % =  ${returnsToString}',
                          style: GoogleFonts.poppins(
                              fontSize: size.width * .036, color: Colors.green),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Capital After Profit = $capitalAfterProfitToString',
                          style: GoogleFonts.poppins(
                              fontSize: size.width * .036, color: Colors.green),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('7'),
                          child: MyTextStyles('7'),
                        ),
                      ),
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('8'),
                          child: MyTextStyles('8'),
                        ),
                      ),
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('9'),
                          child: MyTextStyles('9'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('4'),
                          child: MyTextStyles('4'),
                        ),
                      ),
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('5'),
                          child: MyTextStyles('5'),
                        ),
                      ),
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('6'),
                          child: MyTextStyles('6'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('1'),
                          child: MyTextStyles('1'),
                        ),
                      ),
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('2'),
                          child: MyTextStyles('2'),
                        ),
                      ),
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('3'),
                          child: MyTextStyles('3'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => inputtingTradeCapital('0'),
                          child: MyTextStyles('0'),
                        ),
                      ),

                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: MyButtonStyle.myButtonStyle,
                          onPressed: () => calculateTarget(
                              tradeCapital, riskToReward, stopLoss),
                          child: MyTextStyles('='),
                        ),
                      ),
                      // Container(
                      //   width: size.width * .27,
                      //   height: size.height * .065,
                      //   padding: const EdgeInsets.only(
                      //     top: 1,
                      //     bottom: 3,
                      //   ),
                      //   child: ElevatedButton(
                      //     style: MyButtonStyle.myButtonStyle,
                      //     onPressed: () => inputtingTradeCapital('.'),
                      //     child: MyTextStyles('.'),
                      //   ),
                      // ),

                      Container(
                        width: size.width * .3,
                        height: size.height * .14,
                        // padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(right: 2),
                                width: size.width * .13,
                                height: size.height * .14,
                                child: ElevatedButton(
                                  style: MyButtonStyle.myButtonStyle,
                                  onPressed: deleteLeftFn,
                                  child:
                                      const FaIcon(FontAwesomeIcons.deleteLeft),
                                ),
                              ),
                              Container(
                                width: size.width * .13,
                                height: size.height * .14,
                                padding: const EdgeInsets.only(left: 2),
                                child: ElevatedButton(
                                  style: MyButtonStyle.myButtonStyle,
                                  onPressed: clearInput,
                                  child: MyTextStyles('C'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
