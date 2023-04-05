import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NewRemindersScreen extends StatefulWidget {
  @override
  State<NewRemindersScreen> createState() => _NewRemindersScreenState();
}

class _NewRemindersScreenState extends State<NewRemindersScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> timeList = ["11:15 AM", "12:30 PM", "05:00 PM"];
  List<bool> switchListTileValueList = [true, true, true];

  final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: FloatingActionButton.extended(
              onPressed: () {
                _selectTime(context);
              },
              icon: Icon(Icons.add),
              elevation: 10, label: Text('Add Reminder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: timeList.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 2,
                    child: SwitchListTile(
                      value: switchListTileValueList[index],
                      onChanged: (newValue) => setState(
                          () => switchListTileValueList[index] = newValue),
                      title: Text(
                        timeList[index],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      tileColor: Color(0xFF5C5C5C),
                      dense: false,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
    print(Text("${selectedTime.hour}:${selectedTime.minute}"));
    setState(() {
      timeList.add("${selectedTime.format(context)}");
      switchListTileValueList.add(true);
    });
  }
}
