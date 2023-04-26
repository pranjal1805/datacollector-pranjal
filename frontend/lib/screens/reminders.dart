import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ListViewHomeLayout extends StatefulWidget {
  @override
  ListViewHome createState() {
    return new ListViewHome();
  }
}

class ListViewHome extends State<ListViewHomeLayout> {

  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> timeList = ["11:15 AM", "12:30 PM", "05:00 PM"];
  List<bool> switchListTileValueList = [true, true, true];

  final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.small(
            onPressed: () {
              _selectTime(context);
            },
            child: Icon(Icons.add),
            elevation: 10,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: timeList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: SwitchListTile(
                      value: switchListTileValueList[index],
                      onChanged: (newValue) =>
                          setState(() => switchListTileValueList[index] = newValue),
                      title: Text(
                        timeList[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      tileColor: Color(0xFF5C5C5C),
                      dense: false,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,

    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
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

