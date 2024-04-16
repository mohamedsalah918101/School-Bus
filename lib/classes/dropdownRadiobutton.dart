import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dropdowncheckboxitem.dart';

class DropdownRadiobutton extends StatefulWidget {
  // final List<DropdownCheckboxItem> items;
  // DropdownRadiobutton({required this.items});

  final List<DropdownCheckboxItem> items;
  final List<DropdownCheckboxItem> selectedItems;
  final Function(List<DropdownCheckboxItem>) onSelectionChanged;
  DropdownRadiobutton({
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  });
  @override
  _DropdownRadiobuttonState createState() => _DropdownRadiobuttonState();
}

class _DropdownRadiobuttonState extends State<DropdownRadiobutton> {
  bool isDropdownOpened = false;
//radiobutton select more than one
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: Column(
//         children: [
//           // InkWell(
//           //   onTap: () {
//           //     setState(() {
//           //       isDropdownOpened = !isDropdownOpened;
//           //     });
//           //   },
//             //child:
//             Container(
//               padding: EdgeInsets.all(10),
//
//               // decoration: BoxDecoration(
//               //   border: Border.all(color: Colors.grey),
//               //   borderRadius: BorderRadius.circular(5.0),
//               // ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Filter'),
//                  // Icon(Icons.arrow_drop_down),
//                 ],
//               ),
//             ),
//           //),
//          // if (isDropdownOpened)
//             Container(
//               // decoration: BoxDecoration(
//               //   border: Border.all(color: Colors.grey),
//               //   borderRadius: BorderRadius.only(
//               //     bottomLeft: Radius.circular(5.0),
//               //     bottomRight: Radius.circular(5.0),
//               //   ),
//               // ),
//               child: Column(
//                 children: widget.items.map<Widget>((item) {
//                   return InkWell(
//                     onTap: () {
//                       setState(() {
//                         item.isChecked = !item.isChecked;
//                         if (item.isChecked) {
//                           widget.selectedItems.add(item);
//                         } else {
//                           widget.selectedItems.remove(item);
//                         }
//                         widget.onSelectionChanged(widget.selectedItems);
//                       });
//                     },
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 18,
//                           height: 18,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Color(0xFF442B72), width: 1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: AnimatedContainer(
//                               duration: Duration(milliseconds: 300),
//                               width: item.isChecked ? 12 : 0,
//                               height: item.isChecked ? 12 : 0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF442B72),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 5),
//                         Text(item.label,style: TextStyle(color: Color(0xff442B72)),),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter',style: TextStyle(color: Color(0xff993D9A),
                  fontSize: 18,
                  fontFamily: 'Poppins-Bold',
                  ),),
                   Divider(
                  color: Color(0xFF442B72),
                  thickness: 0.5,
                height: 40,
                //  width: 20, // Adjust the width as needed
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: widget.items.map<Widget>((item) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          // Unselect all items
                          for (var selectedItem in widget.selectedItems) {
                            selectedItem.isChecked = false;
                          }
                          // Clear selected items list
                          widget.selectedItems.clear();

                          // Select the tapped item
                          item.isChecked = true;
                          widget.selectedItems.add(item);

                          // Notify the parent about the selection change
                          widget.onSelectionChanged(widget.selectedItems);
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF442B72), width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: item.isChecked ? 12 : 0,
                                height: item.isChecked ? 12 : 0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF442B72),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            item.label,
                            style: TextStyle(color: Color(0xff442B72)),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );

              }).toList(),
            ),
          ),

        ],
      ),
    );
  }

}
// class _DropdownRadiobuttonState extends State<DropdownRadiobutton> {
//   bool isDropdownOpened = false;
//   //code to make checkbox
//   // @override
//   // Widget build(BuildContext context) {
//   //   return DropdownButtonHideUnderline(
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.stretch,
//   //       children: [
//   //         InkWell(
//   //           onTap: () {
//   //             setState(() {
//   //               isDropdownOpened = !isDropdownOpened;
//   //             });
//   //           },
//   //           child: Container(
//   //             padding: EdgeInsets.all(10),
//   //             decoration: BoxDecoration(
//   //               border: Border.all(color: Colors.grey),
//   //               borderRadius: BorderRadius.circular(5.0),
//   //             ),
//   //             child: Row(
//   //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //               children: [
//   //                 Text('Select options'),
//   //                 Icon(Icons.arrow_drop_down),
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //         if (isDropdownOpened)
//   //           Container(
//   //             decoration: BoxDecoration(
//   //               border: Border.all(color: Colors.grey),
//   //               borderRadius: BorderRadius.only(
//   //                 bottomLeft: Radius.circular(5.0),
//   //                 bottomRight: Radius.circular(5.0),
//   //               ),
//   //             ),
//   //             child: Column(
//   //               children: widget.items.map((item) {
//   //                 return CheckboxListTile(
//   //                   checkColor:  Color(0xFF442B72),
//   //                   activeColor: Colors.white,
//   //                   selectedTileColor: Color(0xFF442B72),
//   //                   title: Text(item.label),
//   //                   value: item.isChecked,
//   //                   onChanged: (value) {
//   //                     setState(() {
//   //                       item.isChecked = value!;
//   //                     });
//   //                   },
//   //                 );
//   //               }).toList(),
//   //             ),
//   //           ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   //code to make like radiobutton but select more than one button
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonHideUnderline(
//       child: Column(
//         // crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           InkWell(
//             onTap: () {
//               setState(() {
//                 isDropdownOpened = !isDropdownOpened;
//               });
//             },
//             child: Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Select options'),
//                   Icon(Icons.arrow_drop_down),
//                 ],
//               ),
//             ),
//           ),
//           if (isDropdownOpened)
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(5.0),
//                   bottomRight: Radius.circular(5.0),
//                 ),
//               ),
//               child: Column(
//                 children: widget.items.map<Widget>((item) {
//                   return Column(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             item.isChecked = !item.isChecked;
//                           });
//                         },
//                         child: Row(
//                           //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   item.isChecked = !item.isChecked;
//                                 });
//                               },
//                               child: Container(
//                                 width: 24,
//                                 height: 24,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Color(0xFF442B72), width: 2),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: Center(
//                                   child: AnimatedContainer(
//                                     duration: Duration(milliseconds: 300),
//                                     width: item.isChecked ? 16 : 0,
//                                     height: item.isChecked ? 16 : 0,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Color(0xFF442B72),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 5),
//                             Text(item.label),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }