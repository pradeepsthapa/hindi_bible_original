import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FacebookBannerAd(
        // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047",
        placementId: "347970317051061_347970603717699",
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("Banner Ad: $result -->  $value");
        },
      ),
    );
  }
}
