import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:phone_verification/helpers/TextStyle.dart';
import 'package:phone_verification/helpers/colors_constant.dart';
import 'package:phone_verification/screens/customer/ProfilePage/Detail/detail_controller.dart';
import 'package:phone_verification/widgets/button_raised.dart';
import 'package:phone_verification/widgets/input_text.dart';

class EditDetailView extends StatefulWidget {
  @override
  _EditDetailViewState createState() => _EditDetailViewState();
}

class _EditDetailViewState extends State<EditDetailView> {
  DetailUserInfoController _controller = new DetailUserInfoController();
  DateTime birthDay;
  bool _isBirthdayConfirm = false;
  bool _isEditPage = false;
  List<String> gender = ['Male', 'Female'];
  //TODO: data
  String _fullName;
  String _address;
  String _genderData;
  String _phone;
  String _birthday;

  @override
  Widget build(BuildContext context) {
    //ConstScreen.setScreen(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              //brightness: Brightness.dark,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.black87,
                  //size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: true,
              title: Text(
                'Edit Detail',
                style: kBoldTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              // title: InkWell(
              //   onTap: () {
              //     Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => SearchView(),
              //       ),
              //     );
              //   },
              //   child:  ClipRRect(
              //     borderRadius: BorderRadius.circular(99),
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
              //       child: InkWell(
              //         //highlightColor: Colors.transparent,
              //         //splashColor: Colors.transparent,
              //         //onTap: voidCallback,
              //         child: Container(
              //           height: 40 ,
              //           width: _w ,
              //           alignment: Alignment.center,
              //           decoration: BoxDecoration(
              //             color: Colors.white.withOpacity(.05),
              //             borderRadius: BorderRadius.circular(99),
              //             border: Border.all(color: Colors.black),
              //           ),
              //           child: Padding(
              //             padding: EdgeInsets.only(left: 10),
              //             child: Row(
              //               children: [
              //                 Icon(
              //                   Icons.search,
              //                     color: Colors.black.withOpacity(.6)
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Text(
              //                   'Search...',
              //                   style: TextStyle(color: Colors.black.withOpacity(.6)),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              iconTheme: IconThemeData.fallback(),
            ),
          ),
        ),
      ),
      body: Container(
        color: kColorWhite,
        child: Padding(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //TODO: First & Last Name
              StreamBuilder(
                  stream: _controller.fullNameStream,
                  builder: (context, snapshot) {
                    return InputText(
                      title: 'Full Name',
                      errorText: snapshot.hasError ? snapshot.error : '',
                      onValueChange: (value) {
                        _fullName = value;
                      },
                    );
                  }),

              SizedBox(
                height: 10,
              ),
              //TODO: Address
              StreamBuilder(
                  stream: _controller.addressStream,
                  builder: (context, snapshot) {
                    return InputText(
                      title: 'Address',
                      errorText: snapshot.hasError ? snapshot.error : '',
                      onValueChange: (value) {
                        _address = value;
                      },
                    );
                  }),

              SizedBox(
                height: 10,
              ),
              //TODO: Mobile Phone and Gender picker
              Row(
                children: <Widget>[
                  //TODO: Mobile Phone
                  StreamBuilder(
                      stream: _controller.phoneStream,
                      builder: (context, snapshot) {
                        return Expanded(
                          flex: 2,
                          child: InputText(
                            title: 'Mobile',
                            errorText: snapshot.hasError ? snapshot.error : '',
                            inputType: TextInputType.number,
                            onValueChange: (value) {
                              _phone = value;
                            },
                          ),
                        );
                      }),
                  SizedBox(
                    width: 7,
                  ),
                  //TODO: Gender picker
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54)),
                      child: Padding(
                        padding: EdgeInsets.only(top: 3, bottom: 3, left: 3,),
                        child: Center(
                          child: StreamBuilder(
                              stream: _controller.genderStream,
                              builder: (context, snapshot) {
                                return DropdownButton(
                                  isExpanded: true,
                                  value: _genderData,
                                  hint: (snapshot.hasError)
                                      ? AutoSizeText(
                                          snapshot.error,
                                          style: kBoldTextStyle.copyWith(
                                              fontSize: 15,
                                              color: kColorRed),
                                          minFontSize: 10,
                                          maxLines: 1,
                                        )
                                      : AutoSizeText(
                                          'Choose gender',
                                          style: kBoldTextStyle.copyWith(
                                              fontSize: 15,
                                              color: kColorBlack),
                                          minFontSize: 10,
                                          maxLines: 1,
                                        ),
                                  onChanged: (value) {
                                    setState(() {
                                      _genderData = value;
                                    });
                                  },
                                  items: gender.map((String value) {
                                    return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: kBoldTextStyle.copyWith(
                                              fontSize: 15),
                                        ));
                                  }).toList(),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //TODO: Date Picker
              GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(1950, 12, 31),
                      maxTime: DateTime(DateTime.now().year, 12, 31),
                      onChanged: (date) {
                    print('change $date');
                    birthDay = date;
                  }, onConfirm: (date) {
                    birthDay = date;
                    _birthday = (birthDay.day.toString() +
                        '/' +
                        birthDay.month.toString() +
                        '/' +
                        birthDay.year.toString());
                    setState(() {
                      _isBirthdayConfirm = true;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.vi);
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: kColorBlack.withOpacity(0.7))),
                  child: Center(
                    child: Text(
                      _isBirthdayConfirm
                          ? ('Birthday: ' +
                              birthDay.day.toString() +
                              '/' +
                              birthDay.month.toString() +
                              '/' +
                              birthDay.year.toString())
                          : 'Birthday Picker',
                      style: TextStyle(
                          color: kColorBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: _controller.btnLoading,
                  builder: (context, snapshot) {
                    return CusRaisedButton(
                      height: 90,
                      title: 'Save',
                      isDisablePress: snapshot.hasData ? snapshot.data : true,
                      backgroundColor: kColorBlack,
                      onPress: () async {
                        bool result = await _controller.onSave(
                            fullName: _fullName,
                            address: _address,
                            phone: _phone,
                            gender: _genderData,
                            birthday: _birthday);
                        if (result) {
                          setState(() {
                            _isEditPage = !_isEditPage;
                          });
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            backgroundColor: kColorWhite,
                            content: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.error,
                                  color: kColorRed,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    'Update profile failed.',
                                    style: kBoldTextStyle.copyWith(fontSize: 14,),
                                  ),
                                )
                              ],
                            ),
                          ));
                        }
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
