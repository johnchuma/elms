// ignore_for_file: use_key_in_widget_constructors, unused_local_variable, unused_element, library_private_types_in_public_api

import 'dart:async';

import 'package:elms/utils/app_colors.dart';
import 'package:elms/widgets/appbar.dart';
import 'package:elms/widgets/device_entry.dart';
import 'package:elms/widgets/heading.dart';
import 'package:elms/widgets/muted_text.dart';
import 'package:elms/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:icons_plus/icons_plus.dart';

class DiscoveryPage extends StatefulWidget {
  
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;

  const DiscoveryPage({this.start = true});

  @override
  _DiscoveryPage createState() => _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;

  _DiscoveryPage();

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      print(r.device);
      print(r.rssi);
      print(r.device.address);
      print(r.device.name);
      print(r.device.isBonded);
      print(r.device.isConnected);

      setState(() {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0)
          results[existingIndex] = r;
        else
          results.add(r);
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, index) {
        BluetoothDiscoveryResult result = results[index];
        final device = result.device;
        final address = device.address;
        return Row(
          children: [
            Icon(Icons.bluetooth),
            Expanded(
              child: Column(
                children: [
                  heading(device.address,fontSize: 14),
                  mutedText(text:  device.name ?? 'Unknown'),
                 
                ],
              ),
              
            ),
             GestureDetector(
                    onTap: () async {
                      try {
                        bool bonded = false;
                        if (device.isBonded) {
                          await FlutterBluetoothSerial.instance
                              .removeDeviceBondWithAddress(address);
                         
                        } else {
                          BluetoothConnection connection =
                              await BluetoothConnection.toAddress(address);
                          bonded = (await FlutterBluetoothSerial.instance
                              .bondDeviceAtAddress(address))!;
                         
                        }
                        setState(() {
                          results[results.indexOf(result)] =
                              BluetoothDiscoveryResult(
                                  device: BluetoothDevice(
                                    name: device.name ?? '',
                                    address: address,
                                    type: device.type,
                                    bondState: bonded
                                        ? BluetoothBondState.bonded
                                        : BluetoothBondState.none,
                                  ),
                                  rssi: result.rssi);
                        });
                      } catch (ex) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error occured while bonding'),
                              content: Text("${ex.toString()}"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: paragraph("Connect", color: AppColors.primaryColor))
          ],
        );
      },
    );
  }
}
