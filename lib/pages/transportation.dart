import 'package:flutter/material.dart';
import 'sidebar.dart';

import '../components/constants.dart';

class Transportation extends StatelessWidget {
  const Transportation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Transport details',
        style: TextStyle(color: Colors.black),
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/shuttle.jpeg'),
            Container(
                padding: EdgeInsets.all(mobileDeviceWidth * 0.04),
                child: Column(children: [
                  const Text(
                    "NSBM Shuttle and Local transportion services",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: mobileDeviceWidth * 0.01,
                  ),
                  const Text(
                    "Apart from public and private transport services, a limited shuttle service is available during the peak hours between High-Level Road and NSBM Green University.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: mobileDeviceWidth * 0.01,
                  ),
                  const Divider(
                    color: Colors.black, // Specify the color of the line
                    thickness: 1.0, // Specify the thickness of the line
                    indent: 70.0, // Specify the start indentation of the line
                    endIndent: 70.0, // Specify the end indentation of the line
                  ),
                  SizedBox(
                    height: mobileDeviceWidth * 0.03,
                  ),
                  Table(
                    border: TableBorder.all(),
                    children: const [
                      TableRow(
                        decoration: BoxDecoration(color: buttonColor),
                        children: [
                          TableCell(
                              child: Center(
                                  child: Text(
                            'Bus type',
                            style: TextStyle(color: white),
                          ))),
                          TableCell(
                              child: Center(
                                  child: Text('Time',
                                      style: TextStyle(color: white)))),
                          TableCell(
                              child: Center(
                                  child: Text('Start at',
                                      style: TextStyle(color: white)))),
                          TableCell(
                              child: Center(
                                  child: Text('End in',
                                      style: TextStyle(color: white)))),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('Shuttle')),
                          ),
                          TableCell(child: Center(child: Text('07:30h'))),
                          TableCell(
                            child: Center(child: Text('Makumbura')),
                          ),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('')),
                          ),
                          TableCell(child: Center(child: Text('08:00h'))),
                          TableCell(
                            child: Center(child: Text('Makumbura')),
                          ),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('')),
                          ),
                          TableCell(child: Center(child: Text('08:30h'))),
                          TableCell(
                            child: Center(child: Text('Makumbura')),
                          ),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('CTB')),
                          ),
                          TableCell(child: Center(child: Text('07:30h'))),
                          TableCell(
                            child: Center(child: Text('Nugegoda')),
                          ),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('')),
                          ),
                          TableCell(child: Center(child: Text('08:00h'))),
                          TableCell(
                            child: Center(child: Text('Nugegoda')),
                          ),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('')),
                          ),
                          TableCell(child: Center(child: Text('08:15h'))),
                          TableCell(
                            child: Center(child: Text('Nugegoda')),
                          ),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('CTB')),
                          ),
                          TableCell(child: Center(child: Text('13:15h'))),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                          TableCell(
                            child: Center(child: Text('Maharagama')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('')),
                          ),
                          TableCell(child: Center(child: Text('15:30h'))),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                          TableCell(
                            child: Center(child: Text('Maharagama')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('')),
                          ),
                          TableCell(child: Center(child: Text('16:45h'))),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                          TableCell(
                            child: Center(child: Text('Kottawa')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('')),
                          ),
                          TableCell(child: Center(child: Text('17:15h'))),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                          TableCell(
                            child: Center(child: Text('Kottawa')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(child: Text('Private')),
                          ),
                          TableCell(child: Center(child: Text('16:45h'))),
                          TableCell(
                            child: Center(child: Text('NSBM')),
                          ),
                          TableCell(
                            child: Center(child: Text('Kadawatha')),
                          ),
                        ],
                      ),
                    ],
                  )
                ]))
          ],
        ),
      ),
    );
  }
}
