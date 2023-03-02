
import 'Yodo1Mas.dart';
import 'dart:io';
import '../utils/Extensions/shared_pref.dart';
import '../utils/constant.dart';
import 'package:yodo1mas/testmasfluttersdktwo.dart';


void startInitSdk()
{

  Yodo1Mas.instance.setInterstitialListener((event, message) {
    switch(event) {
      case Yodo1Mas.AD_EVENT_OPENED:
        print('Interstitial AD_EVENT_OPENED');
        break;
      case Yodo1Mas.AD_EVENT_ERROR:
        print('Interstitial AD_EVENT_ERROR' + message);
        break;
      case Yodo1Mas.AD_EVENT_CLOSED:
        print('Interstitial AD_EVENT_CLOSED');
        break;
    }
  });

  Yodo1Mas.instance.setBannerListener((event, message) {
    switch(event) {
      case Yodo1Mas.AD_EVENT_OPENED:
        print('Banner AD_EVENT_OPENED');
        break;
      case Yodo1Mas.AD_EVENT_ERROR:
        print('Banner AD_EVENT_ERROR' + message);
        break;
      case Yodo1Mas.AD_EVENT_CLOSED:
        print('Banner AD_EVENT_CLOSED');
        break;
    }
  });
  Yodo1Mas.instance.init("ydXsAz3Tzk", (successful) {

  });

}

void GiveRewardDelegate()
  {
    Yodo1Mas.instance.setRewardListener((event, message) {
      switch(event) {
        case Yodo1Mas.AD_EVENT_OPENED:
          print('RewardVideo AD_EVENT_OPENED');
          break;
        case Yodo1Mas.AD_EVENT_ERROR:
          print('RewardVideo AD_EVENT_ERROR' + message);
          break;
        case Yodo1Mas.AD_EVENT_CLOSED:
          print('RewardVideo AD_EVENT_CLOSED');
          break;
        case Yodo1Mas.AD_EVENT_EARNED:
          print('RewardVideo AD_EVENT_EARNED');
          _incrementCounter();
          break;
      }
    });


  }
  void showBannerAds()
  {
    Yodo1Mas.instance.showBannerAd();

  }
  void hideBannerAds()
  {
    Yodo1Mas.instance.dismissBannerAd();
  }
  void showInterAds()
  {
    Yodo1Mas.instance.showInterstitialAd();


  }
  void showRewardedAds()
  {

    Yodo1Mas.instance.showRewardAd();
    GiveRewardDelegate();
  }