import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dropdowncheckboxitem.dart';

class DropdownCheckbox extends StatefulWidget {
  final List<DropdownCheckboxItem> items;
  DropdownCheckbox({required this.items});
  @override
  _DropdownCheckboxState createState() => _DropdownCheckboxState();
}
class _DropdownCheckboxState extends State<DropdownCheckbox> {
  bool isDropdownOpened = false;
  List<DropdownCheckboxItem> selectedItems = [];
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child:
      SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isDropdownOpened = !isDropdownOpened;
                });
              },
              child: Container(

                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF1F1F1),
                  border: Border.all(color: Color(0xFFFFC53E),width: 0.5),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text('Supervisor',

                      style: TextStyle(color: Color(0xFFC2C2C2), fontSize: 12,
                      fontFamily: 'Poppins-Bold',),),
                   Image.asset("assets/imgs/school/Vector (12).png",width: 14,height: 9,),
                   // Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            if (isDropdownOpened)
              Align(alignment: AlignmentDirectional.bottomStart,
                child: Container(

                  // decoration: BoxDecoration(
                  //
                  //   border: Border.all(color: Color(0xFF442B72)),
                  //   borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(5.0),
                  //     bottomRight: Radius.circular(5.0),
                  //   ),
                  // ),
                  child: Column(
                    children: widget.items.map((item) {
                      return Transform.scale(
                        scale: 1.2,
                        child: CheckboxListTile(
                          visualDensity: VisualDensity.compact,
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0), // Adjust the border radius as needed

                          ),
                            //side: BorderSide(color: Color(0xFF442B72),width: 2),
                          //to make border appear in checked and not checked
                          side: MaterialStateBorderSide.resolveWith(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return const BorderSide(color: Color(0xFF442B72),width: 1.5);
                              }
                              return const BorderSide(color: Color(0xFF442B72),width: 1.5);
                            },
                          ),
                          checkColor:  Color(0xFF442B72),
                          activeColor: Colors.white,
                          // activeColor: Color(0xFF442B72) ,
                           //tileColor: Colors.white,
                          selectedTileColor: Color(0xFF442B72),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.0), // Adjust the padding as needed
                          controlAffinity: ListTileControlAffinity.leading, // Align checkbox to the left
                          title: Text(item.label,style: TextStyle(color:Color(0xFF442B72), ),),
                          value: item.isChecked,
                          onChanged: (value) {
                            setState(() {
                              item.isChecked = value!;
                              if (value) {
                                selectedItems.add(item); // Add to selected items list
                              } else {
                                selectedItems.remove(item); // Remove from selected items list
                              }
                            });
                            // setState(() {
                            //   item.isChecked = value!;
                            // });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}