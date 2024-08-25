import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/supervisor_parent/components/dialogs.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/edit_children.dart';
import '../../model/ParentModel.dart';

class ChildrenCard extends StatefulWidget {
  ParentModel? childrenData;
  ChildrenCard(this.childrenData, {super.key, });
  @override
  State<ChildrenCard> createState() => _ChildrenCardState();
}

class _ChildrenCardState extends State<ChildrenCard> {

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: widget.childrenData!.supervisors!.length > 1 ? media.height*.20 : media.height*.18,
      child: Card(
        elevation: 8,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Padding(
            padding: (sharedpref?.getString('lang') == 'ar')
                ? EdgeInsets.only(top: 15.0, right: 12,)
                : EdgeInsets.only(top: 15.0, left: 12,),
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Image.asset(
                                'assets/images/Group 237679 (2).png',
                                height: 50,
                                width: 50,
                              ),
                            ),  const SizedBox(
                              width: 15,
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    widget.childrenData!.child_name!,
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      color: Color(0xFF432B72),
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w700,
                                      height: 0.94,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Class: '.tr+widget.childrenData!.class_name!,
                                  style:
                                  Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    color: Color(0xFF919191),
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Light',
                                    fontWeight: FontWeight.w400,
                                    height: 1.33,
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Today’s Bus : '.tr,
                                        style: TextStyle(
                                          color: Color(0xFF919191),
                                          fontSize: 12,
                                          fontFamily: 'Poppins-Light',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.childrenData!.bus_number!,
                                        style: TextStyle(
                                          color: Color(0xFF442B72),
                                          fontSize: 12,
                                          fontFamily: 'Poppins-Light',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                // Row(
                                //   children: [
                                //     Container(
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(50),
                                //         color: const Color(0xFF13DC64),
                                //         boxShadow: const [
                                //           BoxShadow(
                                //             color: Color(0xFF13DC64),
                                //             spreadRadius: 2,
                                //             blurRadius: 2,
                                //             // offset: Offset(0, 3), // changes position of shadow
                                //           ),
                                //         ],
                                //       ),
                                //       width: 5,
                                //       height: 5,
                                //     ),
                                //     const SizedBox(
                                //       width: 9,
                                //     ),
                                //     Text(
                                //       'Available Today'.tr,
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .headline6!
                                //           .copyWith(
                                //             color: Color(0xFF919191),
                                //             fontSize: 12,
                                //             fontFamily: 'Poppins-Light',
                                //             fontWeight: FontWeight.w400,
                                //             height: 1.33,
                                //           ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ],
                        ),

                        Align(
                          alignment:
                          (sharedpref?.getString('lang') == 'ar') ?
                          Alignment.topRight:
                          Alignment.topLeft ,
                          child:
                          Padding(
                            padding:
                             const EdgeInsets.only(right: 7.0,left: 7.0),
                            child: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                              ),
                              constraints: BoxConstraints.tightFor(width: 111, height: 100),
                              color: Colors.white,
                              surfaceTintColor: Colors.transparent,
                              offset: Offset(0, 30), // Custom offset to adjust menu position
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'item1',
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        (sharedpref?.getString('lang') == 'ar')
                                            ? 'assets/images/edittt_white_translate.png'
                                            : 'assets/images/edittt_white.png',
                                        width: 12.81,
                                        height: 12.76,),
                                      SizedBox(width: 7,),
                                      Text('Edit'.tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Light',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                          color: Color(0xFF432B72),
                                        ),),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'item2',
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/delete.png',
                                        width: 12.77,
                                        height: 13.81,),
                                      SizedBox(width: 7,),
                                      Text('Remove'.tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Light',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: Color(0xFF432B72),
                                        ),),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (String value) {
                                if (value == 'item1') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditChildren(widget.childrenData!),
                                    ),
                                  );
                                } else if (value == 'item2') {
                                  Dialoge.RemoveChildDialog(context);
                                }
                              },
                              child: Image.asset(
                                'assets/images/more.png',
                                width: 20.8,
                                height: 20.8,
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 5
                    ),

                    widget.childrenData!.supervisors!.length == 1 && widget.childrenData!.supervisors!.length >0 ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child:Row(
                            children: [
                              Text(
                                'Supervisor#1'.tr,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Poppins-Light',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff7269AD)
                                ),
                              ),
                              SizedBox(width: media.width * .02),
                              Text(
                                widget.childrenData!.supervisors!.length >0? widget.childrenData!.supervisors![0].name!:'',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins-Poppins-Light',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff929292)
                                ),
                              ),
                            ],
                          )
                        ),


                      ],
                    ):  widget.childrenData!.supervisors!.length >0 ?Padding(
                      padding: const EdgeInsets.only(right: 10.0,left: 10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child:
                            Row(
                              children: [
                                Text(
                                  'Supervisor#1'.tr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Poppins-Light',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff7269AD)
                                  ),
                                ),
                                SizedBox(width: media.width * .02),
                                Text(
                                  widget.childrenData!.supervisors!.length >0? widget.childrenData!.supervisors![0].name!:'',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Poppins-Light',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff929292)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  'Supervisor#2'.tr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Poppins-Light',
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff7269AD)
                                  ),
                                ),
                                SizedBox(width: media.width * .02),
                                Text(
                                  widget.childrenData!.supervisors!.length >0 ? widget.childrenData!.supervisors![1].name!:'',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Poppins-Light',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff929292)
                                  ),
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ):Container(),
                    SizedBox(
                      height: 4,
                    ),
                    // Spacer(),


                  ],
                )              ],
            )),

      ),
    );
  }
}
