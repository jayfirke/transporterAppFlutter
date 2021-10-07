import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/models/truckModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/TruckScreens/AddNewTruck/truckDescriptionScreen.dart';
import 'package:liveasy/widgets/buttons/callButton.dart';
import 'package:liveasy/widgets/buttons/trackButton.dart';
import 'package:liveasy/variables/truckFilterVariables.dart';
import 'package:liveasy/widgets/newRowTemplate.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class MyTruckCard extends StatefulWidget {
  TruckModel truckData;
  // String? truckId;
  // // String? transporterId;
  // String? truckNo;
  // bool truckApproved;
  // String? imei;
  // // int? passingWeight;
  // // String? driverId;
  // String? truckType;
  // String? tyres;
  // String? driverName;
  // String? phoneNum;

  MyTruckCard(
      {
        required this.truckData,
        // this.truckId,
        // // this.transporterId,
        // this.truckNo,
        // required this.truckApproved,
        // this.imei,
        // // this.passingWeight,
        // // this.driverId,
        // this.truckType,
        // this.driverName,
        // this.phoneNum, // will be valid number or 'NA'
        // this.tyres
      });

  @override
  _MyTruckCardState createState() => _MyTruckCardState();
}

class _MyTruckCardState extends State<MyTruckCard> {
  TruckFilterVariables truckFilterVariables = TruckFilterVariables();

  bool? verified;
  Position? userLocation;

  getUserLocation() async {
    PermissionStatus permission =
    await LocationPermissions().checkPermissionStatus();
    if (permission == PermissionStatus.granted) {
      userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(userLocation);
    }
  }

  @override
  void initState() {
    super.initState();
    // getUserLocation();
  }

  @override
  Widget build(BuildContext context) {



    String truckType = truckFilterVariables.truckTypeValueList.contains(widget.truckData.truckType)
        ? truckFilterVariables.truckTypeTextList[truckFilterVariables.truckTypeValueList.indexOf(widget.truckData.truckType)]
        : 'NA';

    Map<String, Color> statusColor = {
      'Available': liveasyGreen,
      'Busy': Colors.red,
      'Offline': unselectedGrey,
    };

    verified = truckType != 'NA' ||
        widget.truckData.tyres != 'NA' ||
        widget.truckData.driverName != 'NA' ||
        widget.truckData.driverNum != "NA"
        ? true
        : false;

    if (widget.truckData.driverName!.length > 15) {
      widget.truckData.driverName = widget.truckData.driverName!.substring(0, 14) + '..';
    }

    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(space_3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              verified!
                  ?
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, space_2, 0),
                        height: space_2,
                        width: space_2,
                        decoration: BoxDecoration(
                          color: statusColor['Offline'],
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.offline,
                        style: TextStyle(
                            fontWeight: mediumBoldWeight, fontSize: size_8),
                      ),
                    ],
                  ),
                  SizedBox(height: space_2,),
                  NewRowTemplate(label: AppLocalizations.of(context)!.vehicleNumber , value: widget.truckData.truckNo),
                  NewRowTemplate(label: AppLocalizations.of(context)!.truckType, value: truckType ,width: 98,),
                  NewRowTemplate(label: AppLocalizations.of(context)!.tyre, value: widget.truckData.tyres.toString()  , width: 98,),
                  NewRowTemplate(label: AppLocalizations.of(context)!.driver, value: widget.truckData.driverName , width: 98,),
                  Container(
                    margin: EdgeInsets.only(top: space_2),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: space_2),
                            child: TrackButton(
                              truckApproved: widget.truckData.truckApproved!,
                              phoneNo: widget.truckData.driverNum,
                              TruckNo: widget.truckData.truckNo,
                              DriverName: widget.truckData.driverName,
                              imei: widget.truckData.imei,
                            )
                        ),
                        CallButton(directCall: true , phoneNum: widget.truckData.driverNum,)
                      ],
                    ),
                  ),

                ],
              )


                  :   Column(
                children: [
                  Row(
                    children: [
                      Image(
                          height: 16 ,
                          width: 18,
                          image: AssetImage('assets/icons/errorIcon.png')
                      ),
                      Container(
                        margin: EdgeInsets.only(left: space_1),
                        child: Text(
                           AppLocalizations.of(context)!.verificationFailed,
                          style: TextStyle(
                              fontWeight: mediumBoldWeight,
                              fontSize: size_8),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: space_3),
                      child: NewRowTemplate(label: AppLocalizations.of(context)!.vehicleNumber, value: widget.truckData.truckNo)
                  ),
                  Container(
                    child: Text(
                      AppLocalizations.of(context)!.truckDetailsArePending,
                      style: TextStyle(
                          fontWeight: mediumBoldWeight,
                          color: Colors.red
                      ),
                    ),
                  ),

                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: space_5),
                      height: 32,
                      width: 201,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(darkBlueColor),
                        ),
                        onPressed: () {
                          providerData.updateIsAddTruckSrcDropDown(true);
                          Get.to( () => TruckDescriptionScreen(truckId : widget.truckData.truckId! , truckNumber: widget.truckData.truckNo! ,)
                          );
                          providerData.resetTruckFilters();
                        },
                        child: Container(
                          child: Text(
                            AppLocalizations.of(context)!.uploadTruckDetails,
                            style: TextStyle(
                              letterSpacing: 0.7,
                              fontWeight: normalWeight,
                              color: white,
                              fontSize: size_7,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )


                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}