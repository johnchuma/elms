// import 'package:elms/pages/bluetooth_discovery.dart'; // Corrected typo in import
import 'dart:async';
import 'dart:typed_data';

import 'package:elms/controllers/price_controller.dart';
import 'package:elms/controllers/record_controller.dart';
import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/bottomsheet_template.dart';
import 'package:elms/widgets/custom_button.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
// Removed unnecessary import: 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({super.key});

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  bool isConnected = false;
  bool isDataReceived =
      false; // Corrected variable name from issDataReceived to isDataReceived
  double weight = 10;

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  requestPermission() async {
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetooth.request();
  }

  Rx<List<BluetoothDiscoveryResult>> results =
      Rx<List<BluetoothDiscoveryResult>>([]);
  RecordController recordController = Get.find();
  double price = 3000;
  PriceController priceController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, title: "Add new record"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder<List<BluetoothDiscoveryResult>>(
            stream: results.stream,
            builder: (context, snapshot) {
              List<BluetoothDiscoveryResult> newList = results.value;

              return Container(
                width: double.infinity,
                child: newList
                        .where((item) =>
                            item.device.bondState == BluetoothBondState.bonded)
                        .isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            OctIcons.cloud_offline,
                            size: 100,
                            color: Colors.grey,
                          ),
                          heading("Hardware is not connected",
                              color: Color.fromARGB(255, 180, 182, 181),
                              textAlign: TextAlign.center),
                          const SizedBox(
                            height: 20,
                          ),
                          customButton("Establish Connection",
                              onClick: () async {
                            print("Listening for devices");
                            List<BluetoothDiscoveryResult> tempList = [];
                            var subscription = FlutterBluetoothSerial.instance
                                .startDiscovery()
                                .listen((r) {
                              print(r.device.address);
                              final existingIndex = tempList.indexWhere(
                                  (element) =>
                                      element.device.address ==
                                      r.device.address);
                              if (existingIndex >= 0) {
                                tempList[existingIndex] = r;
                              } else {
                                tempList.add(r);
                              }
                            });

                            subscription.onDone(() {
                              results.value =
                                  tempList; // Update the observable list once after collecting all results
                              print("Done");
                            });

                            Get.bottomSheet(bottomSheetTemplate(
                                widget: Container(
                              height: 300,
                              child: StreamBuilder<
                                      List<BluetoothDiscoveryResult>>(
                                  stream: results.stream,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Column(
                                        children: [
                                          heading("Discovered Devices"),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    List<BluetoothDiscoveryResult> newList =
                                        snapshot.requireData;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        heading("Discovered Devices"),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Expanded(
                                            child: ListView.builder(
                                          itemCount: newList.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            BluetoothDiscoveryResult result =
                                                newList[index];
                                            final device = result.device;
                                            final address = device.address;
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.bluetooth,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        heading(device.address,
                                                            fontSize: 14),
                                                        mutedText(
                                                            text: device.name ??
                                                                'Unknown'),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () async {
                                                        try {
                                                          bool bonded = false;
                                                          List<BluetoothDiscoveryResult>
                                                              tempList =
                                                              results.value;

                                                          BluetoothConnection
                                                              connection =
                                                              await BluetoothConnection
                                                                  .toAddress(
                                                                      address);
                                                          bonded = (await FlutterBluetoothSerial
                                                              .instance
                                                              .bondDeviceAtAddress(
                                                                  address))!;
                                                          tempList[index] =
                                                              BluetoothDiscoveryResult(
                                                                  device:
                                                                      BluetoothDevice(
                                                                    name: device
                                                                            .name ??
                                                                        'Unknown',
                                                                    address:
                                                                        address,
                                                                    type: device
                                                                        .type,
                                                                    bondState:bonded?
                                                                        BluetoothBondState
                                                                            .bonded:BluetoothBondState.none,
                                                                  ),
                                                                  rssi: result
                                                                      .rssi);
                                                          print(
                                                              "Uploading value");
                                                          results.value = [];
                                                          results.value =
                                                              tempList;
                                                          print(
                                                              "Updated successfully");
                                                          Get.back();
                                                          listenForWeightValues(
                                                              connection);
                                                        } catch (ex) {
                                                          print(ex);
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Error occurred while bonding'),
                                                                content: Text(
                                                                    "${ex.toString()}"),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    child: const Text(
                                                                        "Close"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                      child: paragraph(
                                                          device.bondState ==
                                                                  BluetoothBondState
                                                                      .bonded
                                                              ? "Connected"
                                                              : "Connect",
                                                          color: device
                                                                      .bondState ==
                                                                  BluetoothBondState
                                                                      .bonded
                                                              ? AppColors
                                                                  .primaryColor
                                                              : Colors.grey))
                                                ],
                                              ),
                                            );
                                          },
                                        )),
                                      ],
                                    );
                                  }),
                            )));
                          })
                        ],
                      )
                    : weight == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                OctIcons.check_circle,
                                size: 100,
                                color: AppColors.primaryColor,
                              ),
                              heading("Hardware is now connected",
                                  color: Color.fromARGB(255, 180, 182, 181),
                                  textAlign: TextAlign.center),
                              const SizedBox(
                                height: 20,
                              ),
                              customButton("Waiting for Data...",
                                  background: Colors.grey, onClick: () {})
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              heading("Weight: $weight KG",
                                  textAlign: TextAlign.center, fontSize: 35),
                              paragraph(
                                  "Price: ${weight * priceController.prices.first.price}TSH"),
                              SizedBox(
                                height: 20,
                              ),
                              customButton("Save Record", onClick: () async {
                                RecordController().addRecord(
                                    weight: weight,
                                    price: (weight *
                                        priceController.prices.first.price));
                                Get.back();
                              })
                            ],
                          ),
              );
            }),
      ),
    );
  }

// Function to listen for weight values from the HC-05 module
  void listenForWeightValues(BluetoothConnection connection) {
    StreamSubscription? _streamSubscription;
    _streamSubscription = connection.input!.listen((Uint8List data) {
      String receivedData = ascii.decode(data);
      List<String> values = receivedData.split('\n');
      for (String value in values) {
        if (value.isNotEmpty) {
          try {
            setState(() {
              weight = double.parse(value.trim());
            });
            print("Received weight value: $weight");
          } catch (e) {
            print("Error parsing weight value: $e");
          }
        }
      }
    }, onDone: () {
      print("Stream closed");
      _streamSubscription?.cancel();
    }, onError: (error) {
      print("Error: $error");
      _streamSubscription?.cancel();
    });
  }
}
