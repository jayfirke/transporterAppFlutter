import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/radius.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/functions/postBookingApi.dart';
import 'package:liveasy/models/biddingModel.dart';
import 'package:liveasy/models/loadDetailsScreenModel.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:liveasy/screens/navigationScreen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ConfirmButtonSendRequest extends StatefulWidget {
  bool? directBooking;
  String? truckId;
  BiddingModel? biddingModel;
  String? postLoadId;
  LoadDetailsScreenModel? loadDetailsScreenModel;

  ConfirmButtonSendRequest(
      {
        this.directBooking,
      this.truckId,
      this.biddingModel,
        this.postLoadId,
      this.loadDetailsScreenModel});

  @override
  _ConfirmButtonSendRequestState createState() =>
      _ConfirmButtonSendRequestState();
}

class _ConfirmButtonSendRequestState extends State<ConfirmButtonSendRequest> {

  @override
  Widget build(BuildContext context) {

    if(widget.biddingModel != null){
      widget.biddingModel!.unitValue = widget.biddingModel!.unitValue == 'tonne' ? 'PER_TON' : 'PER_TRUCK' ;
    }
    ProviderData providerData = Provider.of<ProviderData>(context);
    return GestureDetector(
      onTap: widget.truckId != null ?
          () {
        if (widget.directBooking == true) {
          postBookingApi(widget.loadDetailsScreenModel!.loadId, widget.loadDetailsScreenModel!.rate, widget.loadDetailsScreenModel!.unitValue,
              widget.truckId, widget.loadDetailsScreenModel!.postLoadId);
          print("directBooking");
        } else {
          postBookingApi(
              widget.biddingModel!.loadId,
              widget.biddingModel!.currentBid,
              widget.biddingModel!.unitValue,
              widget.truckId,
              widget.postLoadId,
              );
        }
        Navigator.of(context).pop();
        providerData.updateLowerAndUpperNavigationIndex(3, 1);
        Get.offAll(NavigationScreen());

      }
      : null,
      child: Container(
        margin: EdgeInsets.only(right: space_3),
        height: space_6 + 1,
        width: space_16,
        decoration: BoxDecoration(
            color: widget.truckId != null ? darkBlueColor : unselectedGrey,
            borderRadius: BorderRadius.circular(radius_4)),
        child: Center(
          child: Text(
            "Confirm",
            style: TextStyle(
                color: white, fontWeight: normalWeight, fontSize: size_6 + 2),
          ),
        ),
      ),
    );
  }
}
