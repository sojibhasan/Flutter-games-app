import 'dart:io';
import 'package:mighty_games/component/ItemWidget.dart';
import 'package:mighty_games/network/RestApis.dart';
import 'package:mighty_games/screen/WebViewScreen.dart';
import 'package:mighty_games/utils/Extensions/Widget_extensions.dart';
import 'package:mighty_games/utils/appWidget.dart';
import 'package:mighty_games/utils/constant.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';

class ViewAllScreen extends StatefulWidget {
  static String tag = '/ViewAllScreen';
  final int? categoryId;
  final bool? isFeatured;
  final String? title;
  final bool? isCategory;

  ViewAllScreen({this.categoryId, this.title, this.isFeatured = false, this.isCategory = false});

  @override
  ViewAllScreenState createState() => ViewAllScreenState();
}

class ViewAllScreenState extends State<ViewAllScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    FacebookAudienceNetwork.init(
      testingId: FACEBOOK_KEY,
      iOSAdvertiserTrackingEnabled: true,
    );
    if (widget.isCategory == true) {
      if (mCategoryViewAllInterstitialAds == '1') loadInterstitialAds();
    } else {
      if (mViewAllInterstitialAds == '1') loadInterstitialAds();
    }
  }

  @override
  void dispose() {
    if (widget.isCategory == true) {
      if (mCategoryViewAllInterstitialAds == '1') {
        if (mAdCategoryViewAllShowCount < int.parse(adsInterval)) {
          mAdCategoryViewAllShowCount++;
        } else {
          mAdCategoryViewAllShowCount = 0;
          showInterstitialAds();
        }
      }
    } else {
      if (mViewAllInterstitialAds == '1') {
        if (mAdViewAllShowCount < int.parse(adsInterval)) {
          mAdViewAllShowCount++;
        } else {
          mAdViewAllShowCount = 0;
          showInterstitialAds();
        }
      }
    }
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.isFeatured == true ? language.lblFeatured : widget.title!, showBack: true),
      bottomNavigationBar: widget.isCategory == true
          ? mCategoryViewAllBannerAds == '1'
              ? showBannerAds()
              : SizedBox()
          : mViewAllBannerAds == '1'
              ? showBannerAds()
              : SizedBox(),
      body: FutureBuilder<List<Category>>(
        future: widget.isFeatured == true ? getGames(isFeatured: widget.isFeatured!) : getGames(id: widget.categoryId!, isFeatured: widget.isFeatured!),
        builder: (_, snap) {
          if (snap.hasData) {
            return snap.data!.length == 0
                ? noDataWidget(context)
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Wrap(
                      runSpacing: 16,
                      spacing: 8,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        snap.data!.length,
                        (index) {
                          Category data = snap.data![index];
                          return AnimationConfiguration.staggeredGrid(
                            duration: Duration(milliseconds: 750),
                            columnCount: 1,
                            position: index,
                            child: ItemWidget(data, isFavourite: true, onTap: () async {
                              if (Platform.isAndroid) {
                                if (data.url!.contains("market://") || data.url!.contains("play.google.com")) {
                                  await launchUrl(Uri.parse(data.url!));
                                } else {
                                  WebViewScreen(isAdsLoad: true, mInitialUrl: data.url).launch(context);
                                }
                              } else {
                                WebViewScreen(isAdsLoad: true, mInitialUrl: data.url).launch(context);
                              }
                            }),
                          );
                        },
                      ),
                    ),
                  );
          }
          return snapWidgetHelper(snap, loadingWidget: mProgress());
        },
      ),
    );
  }
}
