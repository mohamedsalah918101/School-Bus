import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CountryPhoneNumberField extends StatelessWidget {
  final String hintTxt;
  final double width;

  const CountryPhoneNumberField({
    Key? key,
    required this.hintTxt,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 75,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        border: Border.all(
          color: const Color(0xFFFFC53E),
          width: 0.5,
        ),
        color: const Color(0xFFF1F1F1),
      ),
      child: Row(
        children: [
          SizedBox(width: 16), // Add padding to the left
          Text(
            'Country',
            style: TextStyle(
              color: Color(0xFFC2C2C2),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8), // Add spacing between '+' and text field
          Expanded(
            child: Container(
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  // Handle phone number input changes if needed
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                formatInput: false,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: InputBorder.none, // Remove default border
                hintText: 'Your Phone'.tr,
                // No hintText in IntlPhoneField
                textFieldController: TextEditingController(),
                onSaved: (PhoneNumber? number) {
                  // Handle saving phone number if needed
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//
// class CountryPhoneNumberField extends StatelessWidget {
//   final String hintTxt;
//   final double width;
//
//   const CountryPhoneNumberField({
//     Key? key,
//     required this.hintTxt,
//     required this.width,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       height: 75, // Fixed height to prevent unbounded constraints error
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(7.0),
//           border: Border.all(
//             color: const Color(0xFFFFC53E),
//             width: 0.5,
//           ),
//           color: const Color(0xFFF1F1F1),
//         ),
//         child: Row(
//           children: [
//             SizedBox(width: 16), // Add padding to the left
//             Text(
//               '+',
//               style: TextStyle(
//                 color: Color(0xFFC2C2C2),
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(width: 8), // Add spacing between '+' and text field
//             Expanded(
//               child: TextFormField(
//                 cursorColor: const Color(0xFF442B72),
//                 textDirection: TextDirection.ltr,
//                 scrollPadding: const EdgeInsets.symmetric(vertical: 40),
//                 decoration: InputDecoration(
//                   border: InputBorder.none, // Remove default border
//                   hintText: hintTxt,
//                   hintStyle: const TextStyle(
//                     color: Color(0xFFC2C2C2),
//                     fontSize: 12,
//                     fontFamily: 'Inter-Bold',
//                     fontWeight: FontWeight.w700,
//                     height: 1.33,
//                   ),
//                   isDense: true, // Reduce height of input field
//                   contentPadding: EdgeInsets.zero, // Remove default padding
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
